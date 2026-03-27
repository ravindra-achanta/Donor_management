


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadiView.dart';

class ReferredByDropdown extends StatefulWidget {
  final TextEditingController controller;
  final Function(Map<String, dynamic>?) onSelected;
  final Map<String, dynamic>? initialValue; // <-- added (optional)

  const ReferredByDropdown({
    Key? key,
    required this.controller,
    required this.onSelected,
    this.initialValue, // <-- optional parameter
  }) : super(key: key);

  @override
  State<ReferredByDropdown> createState() => _ReferredByDropdownState();
}

class _ReferredByDropdownState extends State<ReferredByDropdown> {
  List<JeevanaadiUser> _users = [];
  bool _showSuggestions = false;
  bool _isLoading = false;
  bool _isLastPage = false;
  int _currentPage = 0;

  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Set initial text if provided (edit mode)
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!['userName'] ?? '';
    }

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _resetAndLoad();
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 50 &&
          !_isLoading &&
          !_isLastPage) {
        _loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _resetAndLoad() {
    _currentPage = 0;
    _users.clear();
    _isLastPage = false;
    _fetchData();
  }

  void _loadNextPage() {
    _currentPage++;
    _fetchData();
  }

  void _fetchData() {
    final query = widget.controller.text.trim();
    setState(() {
      _isLoading = true;
      _showSuggestions = true;
    });

    context.read<JeevanaadiBloc>().add(
          FetchJeevanaadisEvent(
            _currentPage,
            10,
            query.isNotEmpty ? query : null,
            null,
          ),
        );
  }

  void _performSearch() {
    _resetAndLoad();
  }

  List<dynamic> _buildList() {
    final list = <dynamic>[];
    list.add({
      'type': 'manual',
      'userName': widget.controller.text,
      'displayText': widget.controller.text.isEmpty
          ? '-- Enter Manually --'
          : '-- Use "${widget.controller.text}" as custom name --',
    });
    list.addAll(_users);
    if (_isLoading) {
      list.add({'type': 'loader'});
    }
    return list;
  }

  Widget _buildManualTile(Map item) {
    return Container(
      color: Colors.amber.shade50,
      child: ListTile(
        leading: const Icon(Icons.edit, color: Colors.brown),
        title: Text(
          item['displayText'],
          style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.w500),
        ),
        subtitle: item['userName']?.isNotEmpty == true
            ? Text('Custom name: "${item['userName']}"', style: const TextStyle(fontSize: 12))
            : null,
        onTap: () {
          widget.controller.text = item['userName'] ?? '';
          widget.onSelected({
            'id': '0',
            'userName': item['userName'],
            'isManual': true,
          });
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
        widget.controller.text = user.fullName;
        widget.onSelected({
          'id': user.id,
          'userName': user.fullName,
          'isManual': false,
        });
        setState(() => _showSuggestions = false);
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JeevanaadiBloc, JeevanaadiState>(
      listener: (context, state) {
        if (state.status == JeevanaadiApiStatus.loaded && _isLoading) {
          setState(() {
            _isLoading = false;
            _users.addAll(state.jeevanaadisMems);
            if (_currentPage >= (state.totalpages - 1)) {
              _isLastPage = true;
            }
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Referred By',
              hintText: 'Search by phoneNumber or jeevanadiNo',
              filled: true,
              fillColor: Colors.white,
              suffixIcon: _isLoading
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 4),
          if (_showSuggestions)
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _buildList().length,
                itemBuilder: (context, index) {
                  final item = _buildList()[index];
                  if (item is Map && item['type'] == 'manual') {
                    return _buildManualTile(item);
                  } else if (item is Map && item['type'] == 'loader') {
                    return _buildLoader();
                  } else if (item is JeevanaadiUser) {
                    return _buildUserTile(item);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
        ],
      ),
    );
  }
}
