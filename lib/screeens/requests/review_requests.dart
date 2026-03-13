import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/api_services/network_repos/review_repo.dart';
import 'package:vikas_app/bloc_management/review/review_request_bloc.dart';
import 'package:vikas_app/bloc_management/review/review_request_event.dart';
import 'package:vikas_app/bloc_management/review/review_request_state.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/common/stats_grid.dart';
import 'package:vikas_app/screeens/models/response/review_request.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ReviewRequests extends StatefulWidget {
  const ReviewRequests({super.key});

  @override
  State<ReviewRequests> createState() => _ReviewRequestsState();
}

class _ReviewRequestsState extends State<ReviewRequests> {
  @override
  void initState() {
    super.initState();
  }

  void _showApproveDialog(String jeevanadiId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Approve Request'),
          content: const Text('Are you sure you want to approve this request?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Request approved successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
  }

  void _showRejectDialog(String jeevanadiId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reject Request'),
          content: const Text('Are you sure you want to reject this request?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Request rejected successfully'),
                    backgroundColor: Colors.orange,
                  ),
                );
                // TODO: Implement reject API call
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewRequestBloc(repository: ReviewRepo())
        ..add(
          const FetchReviewRequestsEvent(page: 0, size: 10),
        ), // Add event here
      child: Layout(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              StatsGrid(visibleType: "REQUESTS"),
              BlocBuilder<ReviewRequestBloc, ReviewRequestState>(
                builder: (context, state) {
                  switch (state.status) {
                    case ReviewRequestStatus.loading:
                      return const ScreenLoader();
              
                    case ReviewRequestStatus.error:
                      return Center(
                        child: ErrorCard(
                          message: state.errorMessage ?? "Failed to load requests",
                          onRetry: () {
                            context.read<ReviewRequestBloc>().add(
                              const FetchReviewRequestsEvent(page: 0, size: 10),
                            );
                          },
                        ),
                      );
              
                    case ReviewRequestStatus.loaded:
                      return Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "All Review Requests",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      CommonList<ReviewRequest>(
                                        currentPage: state.currentPage,
                                        users: state.requests,
                                        // onUserTap: (id) {
                                        //   Get.toNamed(
                                        //     '/jeevandiview',
                                        //     arguments: id,
                                        //   );
                                        // },
                                        onUserTap: (id) {
                                          Get.toNamed(
                                            '/jeevandiview',
                                            arguments: {
                                              'jeevanadiId': id,
                                              'isFromRequest': true,
                                            },
                                          );
                                        },
                                        screenType: "REVIEW_REQUEST",
                                        onDelete: (id) {
                                          _showRejectDialog(id);
                                        },
                                        onUpdate: (id) {
                                          Get.toNamed(
                                            '/jeevandiview',
                                            arguments: {
                                              'jeevanadiId': id,
                                              'isFromRequest': true,
                                            },
                                            
                                          );
                                        },
                                        onApprove: (id) {
                                          // Add this line
                                          _showApproveDialog(id);
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 50,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if (state.currentPage > 0) {
                                                  context
                                                      .read<ReviewRequestBloc>()
                                                      .add(
                                                        FetchReviewRequestsEvent(
                                                          page:
                                                              state.currentPage - 1,
                                                          size: 10,
                                                        ),
                                                      );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.skip_previous_outlined,
                                              ),
                                            ),
                                            Text(
                                              "${state.currentPage + 1}/${state.totalPages}",
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (state.currentPage <
                                                    state.totalPages - 1) {
                                                  context
                                                      .read<ReviewRequestBloc>()
                                                      .add(
                                                        FetchReviewRequestsEvent(
                                                          page:
                                                              state.currentPage + 1,
                                                          size: 10,
                                                        ),
                                                      );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.skip_next_outlined,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
              
                    default:
                      return const ScreenLoader();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
