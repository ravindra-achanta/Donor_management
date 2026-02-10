import 'package:flutter/material.dart';
import 'package:vikas_app/screeens/common/notice_dilouge.dart';
import 'package:vikas_app/screeens/notices/notice_detail_screen.dart';
import 'package:vikas_app/screeens/notices/notices.dart';
import 'package:vikas_app/views/layouts/layout.dart';
import 'package:vikas_app/screeens/models/request/notice.dart';

class NoticesListScreen extends StatefulWidget {
  const NoticesListScreen({super.key});

  @override
  State<NoticesListScreen> createState() => _NoticesListScreenState();
}

class _NoticesListScreenState extends State<NoticesListScreen> {
  // Sample notices data
  final List<Notice> _notices = [
    Notice(
      id: '1',
      title: 'Monthly Meeting Announcement',
      message:
          'All staff members are requested to attend the monthly meeting on Friday at 10 AM.',
      audience: 'All Users',
      date: '2024-01-15',
      time: '10:00 AM',
      sender: 'Admin',
    ),
    Notice(
      id: '2',
      title: 'System Maintenance',
      message:
          'The system will be under maintenance from 2 AM to 4 AM tomorrow.',
      audience: 'Karyakatha',
      date: '2024-01-14',
      time: '2:00 AM',
      sender: 'guruji',
    ),
    Notice(
      id: '3',
      title: 'Holiday Announcement',
      message: 'Office will remain closed on 26th January for Republic Day.',
      audience: 'All Users',
      date: '2024-01-13',
      time: '9:00 AM',
      sender: 'guruji',
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Layout(child: _buildContent());
  }

  Widget _buildContent() {
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
                // Add Notice Button
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

            const SizedBox(height: 20),

            // Search and Filters Row
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
                  // Search bar (compact)
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
                        onChanged: (value) {
                          // Implement search functionality
                        },
                      ),
                    ),
                  ),

                  // Vertical divider
                  Container(width: 1, height: 30, color: Colors.grey.shade300),

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
                            }
                          },
                          items: _userTypeOptions.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(color: Colors.black87),
                                ),

                                //child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),

                  // Vertical divider
                  Container(width: 1, height: 30, color: Colors.grey.shade300),

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
                            }
                          },
                          items: _filterOptions.map<DropdownMenuItem<String>>((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              //child: Text(value),
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.black87),
                              ),
                            );
                          }).toList(),
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
              '${_notices.length} notices found',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 16),

            // Notices list - REMOVED Expanded
            Column(
              children: _notices
                  .map((notice) => _buildNoticeCard(notice))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeCard(Notice notice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and audience badge
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

            // const SizedBox(height: 10),

            // Message
            // Text(
            //   notice.message,
            //   style: const TextStyle(
            //     fontSize: 14,
            //     color: Color.fromARGB(255, 97, 97, 97),
            //     height: 1.5,
            //   ),
            //   maxLines: 2,
            //   overflow: TextOverflow.ellipsis,
            // ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  notice.message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 97, 97, 97),
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                IconButton(
                  onPressed: () {
                    NoticePopup.show(
                      context: context,
                      imageUrl:
                          "https://images.unsplash.com/photo-1519389950473-47ba0277781c",
                      title: "Scheduled System Maintenance",
                      description:
                          "Our platform will undergo scheduled maintenance today from 12:00 AM to 2:00 AM.\n"
                          "During this time, some features may be temporarily unavailable.\n"
                          "Thank you for your patience.",
                    );
                  },
                  icon: Icon(Icons.remove_red_eye_outlined),
                ),
              ],
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     // Date and time
            //     Row(
            //       children: [
            //         const Icon(Icons.access_time, size: 14, color: Colors.grey),
            //         const SizedBox(width: 6),
            //         Text(
            //           '${notice.date} • ${notice.time}',
            //           style: const TextStyle(
            //             fontSize: 12,
            //             color: Colors.grey,
            //           ),
            //         ),
            //       ],
            //     ),

            //     // Sender
            //     Row(
            //       children: [
            //         const Icon(Icons.person_outline, size: 14, color: Colors.grey),
            //         const SizedBox(width: 4),
            //         Text(
            //           notice.sender,
            //           style: const TextStyle(
            //             fontSize: 12,
            //             color: Colors.grey,
            //             fontStyle: FontStyle.italic,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // Footer with date, sender and view button
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

                // View Button
                ElevatedButton.icon(
                  onPressed: () => _viewNoticeDetails(notice),
                  icon: const Icon(Icons.remove_red_eye, size: 14),
                  label: const Text('View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    foregroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                    minimumSize: Size.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
    print('Add new notice pressed');
    Navigator.push(context, MaterialPageRoute(builder: (context) => Notices()));
  }

  void _viewNoticeDetails(Notice notice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoticeDetailScreen(notice: notice),
      ),
    );
  }
}
