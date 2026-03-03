import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadiView.dart';
import 'package:vikas_app/screeens/models/response/jeevanadi_member.dart';

class ReferredByDropdown extends StatefulWidget {
  final TextEditingController controller;
  final Function(Map<String, dynamic>?) onSelected;
  final Map<String, dynamic>? initialValue;

  const ReferredByDropdown({
    super.key,
    required this.controller,
    required this.onSelected,
    this.initialValue,
  });

  @override
  State<ReferredByDropdown> createState() => _ReferredByDropdownState();
}

class _ReferredByDropdownState extends State<ReferredByDropdown> {
  static const int PAGE_SIZE = 30;
  int _currentPage = 0;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;
  
  // Store ALL loaded users
  final List<JeevanaadiUser> _allUsers = [];
  final Set<String> _loadedUserIds = {};
  
  String _lastSearchPattern = '';
  Timer? _debounceTimer;
  
  bool _isInitialLoadDone = false;
  Map<String, dynamic>? _selectedReferredBy;
  
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _selectedReferredBy = widget.initialValue;
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!['userName'] ?? '';
    }
    _loadFirstPage();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    // Auto-load when scrolled to 80% of the list
    final threshold = _scrollController.position.maxScrollExtent * 0.8;
    if (_scrollController.position.pixels >= threshold) {
      _loadMoreOnScroll();
    }
  }

  Future<void> _loadMoreOnScroll() async {
    if (_isLoadingMore || !_hasMoreData || _isLoading) return;
    
    setState(() => _isLoadingMore = true);
    await _loadNextPage();
    setState(() => _isLoadingMore = false);
  }

  Future<void> _loadFirstPage() async {
    setState(() => _isLoading = true);

    try {
      context.read<JeevanaadiBloc>().add(FetchJeevanaadisEvent(0));
      await Future.delayed(const Duration(milliseconds: 500));
      
      final state = context.read<JeevanaadiBloc>().state;
      _totalPages = state.totalpages ?? 1;
      
      final newUsers = state.jeevanaadisMems.where(
        (user) => !_loadedUserIds.contains(user.id)
      ).toList();
      
      setState(() {
        _allUsers.addAll(newUsers);
        _loadedUserIds.addAll(newUsers.map((e) => e.id));
        _currentPage = 1;
        _hasMoreData = _currentPage < _totalPages;
        _isLoading = false;
        _isInitialLoadDone = true;
      });

      print('✅ Loaded ${_allUsers.length} users - Page 1/$_totalPages');
    } catch (e) {
      print('❌ Error: $e');
      setState(() => _isLoading = false);
    }
  }

   Future<void> _loadNextPage() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() => _isLoading = true);

    try {
      context.read<JeevanaadiBloc>().add(FetchJeevanaadisEvent(_currentPage));
      await Future.delayed(const Duration(milliseconds: 300));
      
      final state = context.read<JeevanaadiBloc>().state;
      
      final newUsers = state.jeevanaadisMems.where(
        (user) => !_loadedUserIds.contains(user.id)
      ).toList();
      
      setState(() {
        _allUsers.addAll(newUsers);
        _loadedUserIds.addAll(newUsers.map((e) => e.id));
        _currentPage++;
        _hasMoreData = _currentPage < _totalPages;
        _isLoading = false;
      });

      print('✅ Loaded page $_currentPage/$_totalPages - Total: ${_allUsers.length}');
    } catch (e) {
      print('❌ Error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<List<dynamic>> _getSuggestions(String pattern) async {
    _lastSearchPattern = pattern;

    if (!_isInitialLoadDone) {
      return [_buildLoadingItem('Loading users...')];
    }

    final results = <dynamic>[];
    results.add(_buildManualEntry(pattern));

    if (pattern.isEmpty) {
      // Show ALL loaded users (not just first page)
      if (_allUsers.isNotEmpty) {
        results.addAll(_allUsers);
      }

      // Add loading indicator at bottom if more data available
      if (_hasMoreData) {
        results.add(_buildLoadingMoreItem());
      } else if (_allUsers.isNotEmpty) {
        results.add(_buildInfoItem('✓ All ${_allUsers.length} users loaded'));
      }
    } else {
      // Search in ALL loaded users
      final searchPattern = pattern.toLowerCase();
      final matches = _allUsers.where((user) {
        final userName = user.fullName?.toLowerCase() ?? '';
        final email = user.email?.toLowerCase() ?? '';
        final jeevanaadiNo = user.jeevanaadiNo?.toLowerCase() ?? '';
        return userName.contains(searchPattern) ||
               email.contains(searchPattern) ||
               jeevanaadiNo.contains(searchPattern);
      }).toList();

      if (matches.isEmpty) {
        results.add(_buildInfoItem('No matches found in ${_allUsers.length} users'));
      } else {
        results.addAll(matches);
        results.add(_buildInfoItem('Found ${matches.length} matches'));
      }

      // Add loading indicator for search results if more data available
      if (_hasMoreData && matches.length < 20) {
        results.add(_buildSearchMoreItem());
      }
    }

    return results;
  }

  Map<String, dynamic> _buildManualEntry(String pattern) => {
    'isManual': true,
    'userName': pattern,
    'displayText': pattern.isEmpty ? '-- Enter Name Manually --' : '-- Use "$pattern" --',
    'type': 'manual',
  };

  Map<String, dynamic> _buildLoadingMoreItem() => {
    'isLoadingMore': true,
    'displayText': '-- Loading more users... (${_allUsers.length} loaded) --',
    'type': 'loadingmore',
  };

  Map<String, dynamic> _buildSearchMoreItem() => {
    'isSearchMore': true,
    'displayText': '-- Loading more users for better search results... --',
    'type': 'searchmore',
  };

  Map<String, dynamic> _buildInfoItem(String msg) => {
    'isInfo': true,
    'displayText': msg,
    'type': 'info',
  };

  Map<String, dynamic> _buildLoadingItem(String msg) => {
    'isLoading': true,
    'displayText': msg,
    'type': 'loading',
  };

  Future<void> _onSearchMore() async {
    if (_isLoading || !_hasMoreData) return;
    await _loadNextPage();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: _isLoading
          ? Container(
              margin: const EdgeInsets.all(12),
              width: 20,
              height: 20,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.brown,
              ),
            )
          : const Icon(Icons.arrow_drop_down, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.brown),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypeAheadField<dynamic>(
          controller: widget.controller,
          scrollController: _scrollController,
          builder: (context, controller, focusNode) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(fontSize: 14),
              decoration: _inputDecoration("Referred By").copyWith(
                hintText: _isLoading && !_isInitialLoadDone
                    ? 'Loading users...'
                    : 'Search or enter name...',
              ),
            );
          },
          suggestionsCallback: _getSuggestions,
          itemBuilder: (context, dynamic item) {
            // Loading indicator
            if (item is Map && item['type'] == 'loading') {
              return Container(
                padding: const EdgeInsets.all(16),
                child: const Center(child: CircularProgressIndicator(color: Colors.brown)),
              );
            }
            
            // Loading more indicator (auto-load)
            if (item is Map && item['type'] == 'loadingmore') {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  border: Border(
                    top: BorderSide(color: Colors.brown.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['displayText'],
                      style: TextStyle(
                        color: Colors.brown.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            // Info
            if (item is Map && item['type'] == 'info') {
              return Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    item['displayText'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              );
            }
            
            // Search More
            if (item is Map && item['type'] == 'searchmore') {
              return Container(
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: const Icon(Icons.search, color: Colors.blue),
                  title: Text(
                    item['displayText'],
                    style: const TextStyle(color: Colors.blue),
                  ),
                  onTap: _onSearchMore,
                ),
              );
            }
            
            // Manual
            if (item is Map && item['type'] == 'manual') {
              return Container(
                color: Colors.grey.shade100,
                child: ListTile(
                  leading: const Icon(Icons.edit, color: Colors.brown),
                  title: Text(
                    item['displayText'],
                    style: const TextStyle(color: Colors.brown),
                  ),
                  subtitle: item['userName']?.isNotEmpty == true
                      ? Text('Use "${item['userName']}"')
                      : null,
                ),
              );
            }

            // User item
            final user = item;
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: ListTile(
                title: Text(
                  user.userName ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  user.email ?? user.jeevanaadiNo ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                onTap: () {
                  final selected = {
                    'id': user.id,
                    'userName': user.userName,
                    'email': user.email,
                    'jeevanaadiNo': user.jeevanaadiNo,
                  };
                  setState(() {
                    _selectedReferredBy = selected;
                    widget.controller.text = user.userName ?? '';
                  });
                  widget.onSelected(selected);
                  FocusScope.of(context).unfocus();
                },
              ),
            );
          },
          onSelected: (dynamic item) {
            if (item is Map && item['type'] == 'manual') {
              final selected = {
                'id': '0',
                'userName': item['userName'],
                'isManual': true,
              };
              setState(() {
                _selectedReferredBy = selected;
                widget.controller.text = item['userName'];
              });
              widget.onSelected(selected);
            }
          },
          hideOnEmpty: false,
          debounceDuration: const Duration(milliseconds: 300),
        ),
        
        if (_selectedReferredBy != null)
          Container(
            margin: const EdgeInsets.only(top: 8, left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _selectedReferredBy!['isManual'] == true 
                  ? Colors.orange.shade50 
                  : Colors.green.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              // children: [
              //   Icon(
              //     _selectedReferredBy!['isManual'] == true 
              //         ? Icons.edit 
              //         : Icons.check_circle,
              //     color: _selectedReferredBy!['isManual'] == true 
              //         ? Colors.orange 
              //         : Colors.green,
              //     size: 16,
              //   ),
              //   const SizedBox(width: 4),
                // Expanded(
                //   child: Text(
                //     _selectedReferredBy!['isManual'] == true 
                //         ? 'Manual: ${_selectedReferredBy!['userName']}'
                //         : 'Selected: ${_selectedReferredBy!['userName']}',
                //     style: TextStyle(
                //       fontSize: 12, 
                //       color: _selectedReferredBy!['isManual'] == true 
                //           ? Colors.orange 
                //           : Colors.green,
                //     ),
                //   ),
                // ),
             // ],
            ),
          ),
      ],
    );
  }
}