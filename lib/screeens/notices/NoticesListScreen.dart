import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vikas_app/bloc_management/notices/notice_bloc.dart';
import 'package:vikas_app/bloc_management/notices/notice_event.dart';
import 'package:vikas_app/bloc_management/notices/notice_state.dart';
import 'package:vikas_app/screeens/common/deletion_popup.dart';
import 'package:vikas_app/views/layouts/layout.dart';
import 'package:vikas_app/screeens/models/response/notice_response.dart';

class NoticesListScreen extends StatefulWidget {
  const NoticesListScreen({super.key});

  @override
  State<NoticesListScreen> createState() => _NoticesListScreenState();
}

class _NoticesListScreenState extends State<NoticesListScreen> {
  // Filter options
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

  List<NoticeResponse> _allNotices = [];

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  void _loadNotices() {
    context.read<NoticeBloc>().add(FetchNoticesEvent());
  }

  // List<NoticeResponse> get _filteredNotices {
  //   return _allNotices.where((notice) {
  //     // TODO: Implement search by title/description
  //     // TODO: Implement filter by date (sendTime)
  //     // TODO: Implement filter by audience (sendTo)
  //     return true;
  //   }).toList();
  // }
  List<NoticeResponse> get _filteredNotices {
  return _allNotices.where((notice) {
    // 1. search title/description
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      if (!notice.title.toLowerCase().contains(q) &&
          !notice.description.toLowerCase().contains(q)) {
        return false;
      }
    }

    // 2. audience type dropdown
    if (_selectedUserType != 'All Users') {
      final aud = notice.sendTo ?? '';
      if (_selectedUserType == 'Admin' && aud != 'TO_ADMINS') return false;
      if (_selectedUserType == 'Karyakatha' && aud != 'TO_KARYAKARTHAS')
        return false;
      if (_selectedUserType == 'Staff' && aud != 'TO_OFFICESTAFF') return false;
    }

    // 3. date filter
    if (_selectedFilter != 'All') {
      final dt = notice.sendTime;
      if (dt == null) return false;
      final now = DateTime.now();
      switch (_selectedFilter) {
        case 'Today':
          if (!(dt.year == now.year &&
              dt.month == now.month &&
              dt.day == now.day)) return false;
          break;
        case 'This Week':
          final weekStart =
              now.subtract(Duration(days: now.weekday - 1)); // Mon
          if (dt.isBefore(weekStart)) return false;
          break;
        case 'This Month':
          if (dt.year != now.year || dt.month != now.month) return false;
          break;
        case 'This Year':
          if (dt.year != now.year) return false;
          break;
      }
    }

    return true;
  }).toList();
}

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  void _onFilterChanged() {
    setState(() {}); 
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Color _getAudienceColor(String sendTo) {
    switch (sendTo) {
      case 'TO_ALL':
        return Colors.blue.shade600;
      case 'TO_ADMIN':
        return Colors.red.shade600;
      case 'TO_KARYAKATHA':
        return Colors.green.shade600;
      case 'TO_STAFF':
        return Colors.orange.shade600;
      default:
        return Colors.purple.shade600;
    }
  }

  String _getAudienceDisplay(String sendTo) {
    switch (sendTo) {
      case 'TO_ALL':
        return 'All Users';
      case 'TO_ADMIN':
        return 'Admin';
      case 'TO_KARYAKATHA':
        return 'Karyakatha';
      case 'TO_STAFF':
        return 'Staff';
      default:
        return sendTo; // fallback to raw value
    }
  }

void _addNewNotice() {
    // Clear arguments to ensure fresh form (no stale NoticeResponse)
    Get.toNamed('/notices', arguments: null);
  }

  void _viewNoticeDetails(NoticeResponse notice) {
    Get.toNamed('/view/notice', arguments: notice);
  }

  void _showDeleteDialog(BuildContext context, String id, String title) {
  DeletionPopup.showDeleteConfirmation(
    context: context,
    title: 'Delete Notice',
    message: 'Are you sure you want to delete "$title"?',
    onConfirm: () {
      context.read<NoticeBloc>().add(DeleteNoticeEvent(id));
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: BlocConsumer<NoticeBloc, NoticeState>(
        listener: (context, state) {
          // Update local list when new data arrives
          if (state.status == NoticeStatus.success) {
            _allNotices = state.notices;
          }

          // Handle create/update form status
          if (state.formStatus == NoticeFormStatus.success) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text('Notice saved successfully'),
            //     backgroundColor: Colors.green,
            //   ),
            // );
          } else if (state.formStatus == NoticeFormStatus.error) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state.formErrorMessage ?? 'Operation failed'),
            //     backgroundColor: Colors.red,
            //   ),
            // );
          }

          // Handle general error
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == NoticeStatus.loading && _allNotices.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final displayedNotices = _filteredNotices;

          return SingleChildScrollView(
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

                  // Filter bar
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
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey.shade300,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: 
                            DropdownButtonHideUnderline(
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
                                    .map<DropdownMenuItem<String>>(
                                      (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey.shade300,
                        ),
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
                                    .map<DropdownMenuItem<String>>(
                                      (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Notices count (based on filtered list)
                  Text(
                    '${displayedNotices.length} notices found',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 16),

                  // Notices list
                  displayedNotices.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text('No notices found'),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayedNotices.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final notice = displayedNotices[index];
                            return _buildNoticeCard(notice);
                          },
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
    // Use sendTime directly if it's already a DateTime
    DateTime? sendDateTime;
    try {
      sendDateTime = notice.sendTime is String
          ? DateTime.parse(notice.sendTime as String).toLocal()
          : (notice.sendTime as DateTime?);
    } catch (e) {
      sendDateTime = null;
    }
    String formattedDate = sendDateTime != null
        ? DateFormat('MMM d, y • h:mm a').format(sendDateTime)
        : 'Invalid date';

    // Audience display and color
    final audienceDisplay = _getAudienceDisplay(notice.sendTo ?? 'TO_ALL');
    final audienceColor = _getAudienceColor(notice.sendTo ?? 'TO_ALL');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and audience chip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                     'Title: ${notice.title}',
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
                    color: audienceColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    audienceDisplay,
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

            // Description
            Text(
             'Description: ${notice.description}',
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 97, 97, 97),
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _viewNoticeDetails(notice),
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 20),
                      iconSize: 40,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
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
                    IconButton(
                      onPressed: () {
                        _showDeleteDialog(context, notice.id, notice.title);
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      color: Colors.red,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
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