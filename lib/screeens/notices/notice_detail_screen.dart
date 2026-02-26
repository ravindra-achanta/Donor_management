import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/notices/notice_bloc.dart';
import 'package:vikas_app/bloc_management/notices/notice_event.dart';
import 'package:vikas_app/bloc_management/notices/notice_state.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/models/response/notice_response.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class NoticeDetailScreen extends StatefulWidget {
  final NoticeResponse? notice;
  final String? noticeId;

  const NoticeDetailScreen({Key? key, this.notice, this.noticeId})
    : super(key: key);

  @override
  State<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  late NoticeResponse _notice;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.notice != null) {
      _notice = widget.notice!;
      return;
    }

    final args = Get.arguments;
    if (args != null && args is NoticeResponse) {
      _notice = args;
      return;
    }

    if (widget.noticeId != null && widget.noticeId!.isNotEmpty) {
      _fetchNoticeDetails();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No notice data found'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      });
    }
  }

  void _fetchNoticeDetails() {
    setState(() => _isLoading = true);
    context.read<NoticeBloc>().add(ViewNoticeDetailsEvent(widget.noticeId!));
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Notice'),
          content: Text('Are you sure you want to delete "${_notice.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<NoticeBloc>().add(DeleteNoticeEvent(_notice.id));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Deleting notice...'),
                    backgroundColor: Colors.orange,
                  ),
                );

                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    Navigator.pop(context);
                    context.read<NoticeBloc>().refreshNotices();
                  }
                });
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
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

  Widget _buildCompactInfoChip({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: BlocConsumer<NoticeBloc, NoticeState>(
        listener: (context, state) {
          if (state.selectedNotice != null && _isLoading) {
            setState(() {
              _notice = state.selectedNotice!;
              _isLoading = false;
            });
          } else if (state.errorMessage != null && _isLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
            setState(() => _isLoading = false);
          }

          if (state.formStatus == NoticeFormStatus.success) {
            // Handle any form success if needed
          }
        },
        builder: (context, state) {
          if (_isLoading) {
            return const Center(child: ScreenLoader());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Notice Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                    // Action buttons
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            Get.toNamed('/edit/notice', arguments: _notice);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: _showDeleteDialog,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Notice Card
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Title:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _notice.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getAudienceColor(_notice.audience),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _notice.audience,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Message
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Message:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.brown,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _notice.message,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildCompactInfoChip(
                                icon: Icons.calendar_today,
                                value: _notice.date,
                                color: Colors.blue,
                              ),
                              Container(
                                height: 20,
                                width: 1,
                                color: Colors.blue.shade200,
                              ),
                              _buildCompactInfoChip(
                                icon: Icons.access_time,
                                value: _notice.time,
                                color: Colors.blue,
                              ),
                              Container(
                                height: 20,
                                width: 1,
                                color: Colors.blue.shade200,
                              ),
                              _buildCompactInfoChip(
                                icon: Icons.person_outline,
                                value: _notice.sender,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Created: ${_notice.createdAt.toString().split(' ')[0]}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
