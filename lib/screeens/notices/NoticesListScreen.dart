import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/notices/notice_bloc.dart';
import 'package:vikas_app/bloc_management/notices/notice_event.dart';
import 'package:vikas_app/bloc_management/notices/notice_state.dart';
import 'package:vikas_app/screeens/common/notice_dilouge.dart';
import 'package:vikas_app/screeens/notices/notice_detail_screen.dart';
import 'package:vikas_app/screeens/notices/notices.dart';
import 'package:vikas_app/views/layouts/layout.dart';
import 'package:vikas_app/screeens/models/response/notice_response.dart';

class NoticesListScreen extends StatefulWidget {
  const NoticesListScreen({super.key});

  @override
  State<NoticesListScreen> createState() => _NoticesListScreenState();
}

class _NoticesListScreenState extends State<NoticesListScreen> {
  // Dropdown options
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Today',
    'This Week',
    'This Month',
    'This Year',
  ];

  String _selectedUserType = 'All Users';
  final List<String> _userTypeOptions = [
    'All Users',
    'Admin',
    'Karyakatha',
    'Staff',
  ];

  String _searchQuery = '';
  Timer? _debounce;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadNotices();
    _scrollController.addListener(_onScroll);
  }

  void _loadNotices() {
    context.read<NoticeBloc>().add(
      FetchNoticesEvent(
        page: 0,
        filterType: _selectedFilter,
        userType: _selectedUserType,
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<NoticeBloc>().state;
      if (state.status != NoticeStatus.loading &&
          !state.isLoadingMore &&
          state.currentPage < state.totalPages - 1) {
        context.read<NoticeBloc>().add(
          FetchNoticesEvent(
            page: state.currentPage + 1,
            filterType: _selectedFilter,
            userType: _selectedUserType,
            searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
          ),
        );
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
      _loadNotices();
    });
  }

  void _onFilterChanged() {
    _loadNotices();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Color _getAudienceColor(String audience) {
    switch (audience) {
      case 'All Users':
        return Colors.blue.shade600;
      case 'Admin':
        return Colors.red.shade600;
      case 'Karyakatha':
        return Colors.green.shade600;
      case 'Staff':
        return Colors.orange.shade600;
      default:
        return Colors.purple.shade600;
    }
  }

  void _addNewNotice() {
    Get.toNamed('/notices');
  }

  void _viewNoticeDetails(NoticeResponse notice) {
    Get.toNamed('view/notice', arguments: notice);
  }

  void _showDeleteDialog(BuildContext context, String id, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Notice'),
          content: Text('Are you sure you want to delete "$title"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<NoticeBloc>().add(DeleteNoticeEvent(id));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: BlocConsumer<NoticeBloc, NoticeState>(
        listener: (context, state) {
          if (state.formStatus == NoticeFormStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notice added successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.formStatus == NoticeFormStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.formErrorMessage ?? 'Error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == NoticeStatus.loading && state.notices.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notices',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      // Add Notice Button
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _loadNotices,
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _addNewNotice,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add Notice'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search notices...',
                                hintStyle: const TextStyle(fontSize: 13),
                                border: InputBorder.none,
                                prefixIcon: const Icon(
                                  Icons.search,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                isDense: true,
                              ),
                              style: const TextStyle(fontSize: 13),
                              onChanged: _onSearchChanged,
                            ),
                          ),
                        ),

                        // Vertical divider
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey.shade300,
                        ),

                        // User Type Dropdown
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedUserType,
                                isExpanded: true,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                                dropdownColor: Colors.white,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedUserType = newValue;
                                    });
                                    _onFilterChanged();
                                  }
                                },
                                items: _userTypeOptions
                                    .map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ),

                        // Vertical divider
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey.shade300,
                        ),

                        // Filter Dropdown
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedFilter,
                                isExpanded: true,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                                dropdownColor: Colors.white,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedFilter = newValue;
                                    });
                                    _onFilterChanged();
                                  }
                                },
                                items: _filterOptions
                                    .map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Notices count
                  Text(
                    '${state.totalElements} notices found',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 16),

                  // Notices list
                  state.notices.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text('No notices found'),
                          ),
                        )
                      : Column(
                          children: [
                            ...state.notices
                                .map((notice) => _buildNoticeCard(notice))
                                .toList(),
                            if (state.isLoadingMore)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoticeCard(NoticeResponse notice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    notice.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _getAudienceColor(notice.audience),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    notice.audience,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    notice.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 97, 97, 97),
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => _viewNoticeDetails(notice),
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 20),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date and time
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      '${notice.date} • ${notice.time}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                // Action buttons
                Row(
                  children: [
                    // View Button
                    // ElevatedButton.icon(
                    //   onPressed: () => _viewNoticeDetails(notice),
                    //   icon: const Icon(Icons.remove_red_eye, size: 14),
                    //   label: const Text('View'),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue.shade50,
                    //     foregroundColor: Colors.blue.shade700,
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 12,
                    //       vertical: 6,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(6),
                    //     ),
                    //     elevation: 0,
                    //     minimumSize: Size.zero,
                    //   ),
                    // ),
                    //const SizedBox(width: 0),
                    // Edit Button
                    IconButton(
                      onPressed: () {
                        Get.toNamed('/notices', arguments: notice);
                      },
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      color: Colors.orange,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: 8),

                    // Delete Button
                    // IconButton(
                    //   onPressed: () {
                    //     _showDeleteDialog(context, notice.id, notice.title);
                    //   },
                    //   icon: const Icon(Icons.delete_outline, size: 18),
                    //   color: Colors.red,
                    //   constraints: const BoxConstraints(),
                    //   padding: EdgeInsets.zero,
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
