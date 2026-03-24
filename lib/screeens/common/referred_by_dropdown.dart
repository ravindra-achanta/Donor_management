import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    Key? key,
    required this.controller,
    required this.onSelected,
    this.initialValue,
  }) : super(key: key);

  @override
  State<ReferredByDropdown> createState() => _ReferredByDropdownState();
}

class _ReferredByDropdownState extends State<ReferredByDropdown> {
  // Current suggestions shown in the list (search results)
  List<dynamic> _suggestions = [];
  bool _showSuggestions = false;

  // For search via BLoC
  bool _isSearching = false;
  String? _searchError;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!['userName'] ?? '';
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // Build search results (including manual entry at top)
  List<dynamic> _buildSearchResults(List<JeevanaadiUser> results) {
    final list = <dynamic>[];
    list.add(_buildManualEntry(widget.controller.text));
    if (results.isEmpty) {
      list.add(_buildInfoItem('No matching users found'));
    } else {
      list.addAll(results);
    }
    return list;
  }

  // Build a message when query is empty
  List<dynamic> _buildEmptyQueryMessage() {
    return [
      _buildManualEntry(''),
      _buildInfoItem('Enter a name and tap search'),
    ];
  }

  // ---------- Item builders ----------
  Map<String, dynamic> _buildManualEntry(String pattern) => {
        'isManual': true,
        'userName': pattern,
        'displayText': pattern.isEmpty
            ? '-- Enter Manually --'
            : '-- Use "$pattern" as custom name --',
        'type': 'manual',
      };

  Map<String, dynamic> _buildInfoItem(String msg) => {
        'isInfo': true,
        'displayText': msg,
        'type': 'info',
      };

  // ---------- UI for each suggestion type ----------
  Widget _buildInfoTile(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Center(
        child: Text(
          item['displayText'],
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildManualTile(Map<String, dynamic> item) {
    return Container(
      color: Colors.amber.shade50,
      child: ListTile(
        leading: const Icon(Icons.edit, color: Colors.brown),
        title: Text(
          item['displayText'],
          style: const TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: item['userName']?.isNotEmpty == true
            ? Text(
                'Custom name: "${item['userName']}"',
                style: const TextStyle(fontSize: 12),
              )
            : null,
        onTap: () {
          final selected = {
            'id': '0',
            'userName': item['userName'],
            'isManual': true,
          };
          widget.controller.text = item['userName'];
          widget.onSelected(selected);
          setState(() => _showSuggestions = false);
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _buildUserTile(JeevanaadiUser user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.brown.shade100,
        child: Text(
          user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
          style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        user.jeevanaadiNo?.isNotEmpty == true
            ? 'Jeevanadi No: ${user.jeevanaadiNo}'
            : (user.email ?? ''),
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      onTap: () {
        final selected = {
          'id': user.id,
          'userName': user.fullName,
          'email': user.email,
          'jeevanaadiNo': user.jeevanaadiNo,
          'isManual': false,
        };
        widget.controller.text = user.fullName;
        widget.onSelected(selected);
        setState(() => _showSuggestions = false);
        FocusScope.of(context).unfocus();
      },
    );
  }

  // ---------- Search action ----------
  void _performSearch() {
    final query = widget.controller.text.trim();
    if (query.isEmpty) {
      // Show a message instead of performing search
      setState(() {
        _suggestions = _buildEmptyQueryMessage();
        _showSuggestions = true;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchError = null;
      _showSuggestions = true; // show the list (will be populated by bloc listener)
    });

    // Trigger BLoC search
    context.read<JeevanaadiBloc>().add(SearchJeevanaadiUsersEvent(query));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JeevanaadiBloc, JeevanaadiState>(
      listenWhen: (previous, current) =>
          previous.searchResults != current.searchResults ||
          previous.searchLoading != current.searchLoading ||
          previous.searchError != current.searchError,
      listener: (context, state) {
        if (!state.searchLoading && _isSearching) {
          setState(() {
            _isSearching = false;
            if (state.searchError != null) {
              _searchError = state.searchError;
              _suggestions = [
                _buildManualEntry(widget.controller.text),
                _buildInfoItem('Search failed: ${state.searchError}'),
              ];
            } else {
              _suggestions = _buildSearchResults(state.searchResults);
            }
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text field with search icon inside
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Referred By',
               hintText: 'Search by phoneNumber or jeevanadiNo', 
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: _isSearching
                  ? Container(
                      margin: const EdgeInsets.all(12),
                      width: 20,
                      height: 20,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _performSearch,
                      color: Colors.brown,
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            onTap: () {
              // Optionally hide suggestions when field is tapped?
              // We'll keep it simple: suggestions stay visible until selection.
            },
          ),
          const SizedBox(height: 4),

          // Suggestions list (visible only when _showSuggestions is true)
          Visibility(
            visible: _showSuggestions,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final item = _suggestions[index];
                  if (item is Map<String, dynamic>) {
                    if (item['type'] == 'manual') {
                      return _buildManualTile(item);
                    } else if (item['type'] == 'info') {
                      return _buildInfoTile(item);
                    }
                  } else if (item is JeevanaadiUser) {
                    return _buildUserTile(item);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}