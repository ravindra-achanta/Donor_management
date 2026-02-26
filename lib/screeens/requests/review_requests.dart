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
    // Don't add event here - moved to build method with BlocProvider
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
                // TODO: Implement approve API call
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
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
      create: (context) => ReviewRequestBloc(
        repository: ReviewRepo(),
      )..add(const FetchReviewRequestsEvent(page: 0, size: 10)), // Add event here
      child: Layout(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<ReviewRequestBloc, ReviewRequestState>(
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
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    onUserTap: (id) {
                                      // Handle user tap - show details
                                      Get.toNamed('/jeevandiview', arguments: id);
                                    },
                                    screenType: "REVIEW_REQUEST",
                                    onDelete: (id) {
                                      _showRejectDialog(id);
                                    },
                                    onUpdate: (id) {
                                      Get.toNamed('/jeevandiview', arguments: id);
                                    },
                                    onApprove: (id) { // Add this line
                                      _showApproveDialog(id);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 50),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (state.currentPage > 0) {
                                              context.read<ReviewRequestBloc>().add(
                                                FetchReviewRequestsEvent(
                                                  page: state.currentPage - 1,
                                                  size: 10,
                                                ),
                                              );
                                            }
                                          },
                                          icon: const Icon(Icons.skip_previous_outlined),
                                        ),
                                        Text(
                                          "${state.currentPage + 1}/${state.totalPages}",
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (state.currentPage < state.totalPages - 1) {
                                              context.read<ReviewRequestBloc>().add(
                                                FetchReviewRequestsEvent(
                                                  page: state.currentPage + 1,
                                                  size: 10,
                                                ),
                                              );
                                            }
                                          },
                                          icon: const Icon(Icons.skip_next_outlined),
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
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:vikas_app/api_services/network_repos/review_repo.dart';
// import 'package:vikas_app/bloc_management/review/review_request_bloc.dart';
// import 'package:vikas_app/bloc_management/review/review_request_event.dart';
// import 'package:vikas_app/bloc_management/review/review_request_state.dart';
// import 'package:vikas_app/screeens/common/ErrorText.dart';
// import 'package:vikas_app/screeens/common/deletion_popup.dart';
// import 'package:vikas_app/screeens/common/loader.dart';
// import 'package:vikas_app/views/layouts/layout.dart';

// class ReviewRequests extends StatefulWidget {
//   const ReviewRequests({super.key});

//   @override
//   State<ReviewRequests> createState() => _ReviewRequestsState();
// }

// class _ReviewRequestsState extends State<ReviewRequests> {
//   final ScrollController _scrollController = ScrollController();
//   final int _pageSize = 10;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (_isBottom) {
//       final state = context.read<ReviewRequestBloc>().state;
//       if (!state.hasReachedMax && state.status != ReviewRequestStatus.loading) {
//         context.read<ReviewRequestBloc>().add(
//           FetchReviewRequestsEvent(
//             page: state.currentPage + 1,
//             size: _pageSize,
//             isLoadMore: true,
//           ),
//         );
//       }
//     }
//   }

//   bool get _isBottom {
//     if (!_scrollController.hasClients) return false;
//     final maxScroll = _scrollController.position.maxScrollExtent;
//     final currentScroll = _scrollController.offset;
//     return currentScroll >= (maxScroll * 0.9);
//   }

//   void _refresh() {
//     context.read<ReviewRequestBloc>().add(
//       const FetchReviewRequestsEvent(page: 0, size: 10),
//     );
//   }

//   Color getStatusColor(String status) {
//     switch (status) {
//       case "Approved":
//         return Colors.green;
//       case "Rejected":
//         return Colors.red;
//       default:
//         return Colors.orange;
//     }
//   }

//   void _showApproveDialog(String jeevanadiId) {
//     ApprovePopup.showApproveConfirmation(
//       context: context,
//       title: "Approve?",
//       message: "Are you sure you want to Approve this request?",
//       buttonText: "Approve",
//       onConfirm: () {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Request approved successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       },
//     );
//   }

//   void _showRejectDialog(String jeevanadiId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Reject Request'),
//           content: const Text('Are you sure you want to reject this request?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Request rejected successfully'),
//                     backgroundColor: Colors.orange,
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//               ),
//               child: const Text('Reject'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   int _getCrossAxisCount(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     if (width < 800) {
//       return 2;
//     } else {
//       return 3;
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ReviewRequestBloc(
//         repository: ReviewRepo(),
//       )..add(const FetchReviewRequestsEvent(page: 0, size: 10)),
//       child: Layout(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               // Header
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "All Review Requests",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
              
//               Container(
//                 height: 500, 
//                 child: RefreshIndicator(
//                   onRefresh: () async => _refresh(),
//                   child: BlocConsumer<ReviewRequestBloc, ReviewRequestState>(
//                     listener: (context, state) {
//                       if (state.errorMessage != null && state.requests.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(state.errorMessage!),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     },
//                     builder: (context, state) {
//                       if (state.status == ReviewRequestStatus.loading && state.requests.isEmpty) {
//                         return const Center(child: ScreenLoader());
//                       }

//                       if (state.status == ReviewRequestStatus.error && state.requests.isEmpty) {
//                         return Center(
//                           child: ErrorCard(
//                             message: state.errorMessage ?? 'Failed to load requests',
//                             onRetry: _refresh,
//                           ),
//                         );
//                       }

//                       return GridView.builder(
//                         controller: _scrollController,
//                         padding: const EdgeInsets.all(8),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: _getCrossAxisCount(context),
//                           crossAxisSpacing: 20,
//                           mainAxisSpacing: 20,
//                           childAspectRatio: 1.6,
//                         ),
//                         itemCount: state.requests.length,
//                         itemBuilder: (context, index) {
//                           final request = state.requests[index];
//                           return Card(
//                             elevation: 2,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(12),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 20,
//                                         backgroundColor: Colors.blue.shade100,
//                                         child: Text(
//                                           request.jeevnadiName.isNotEmpty 
//                                               ? request.jeevnadiName[0].toUpperCase() 
//                                               : '?',
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.blue,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               request.jeevnadiName,
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                             Text(
//                                               'ID: ${request.jeevanadiId}',
//                                               style: TextStyle(
//                                                 fontSize: 11,
//                                                 color: Colors.grey.shade600,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 4,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: getStatusColor(request.status ?? 'Pending')
//                                               .withOpacity(0.1),
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                         child: Text(
//                                           request.status ?? 'Pending',
//                                           style: TextStyle(
//                                             color: getStatusColor(request.status ?? 'Pending'),
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const Spacer(),
//                                   Text(
//                                     'Updated by: ${request.updatedBy}',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey.shade700,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: ElevatedButton(
//                                           onPressed: () => _showApproveDialog(request.jeevanadiId),
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.green,
//                                             padding: const EdgeInsets.symmetric(vertical: 8),
//                                           ),
//                                           child: const Text('Approve', style: TextStyle(fontSize: 11)),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Expanded(
//                                         child: OutlinedButton(
//                                           onPressed: () => Get.toNamed('/jeevandiview', 
//                                               arguments: request.jeevanadiId),
//                                           style: OutlinedButton.styleFrom(
//                                             foregroundColor: Colors.blue,
//                                             padding: const EdgeInsets.symmetric(vertical: 8),
//                                           ),
//                                           child: const Text('View', style: TextStyle(fontSize: 11)),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Expanded(
//                                         child: OutlinedButton(
//                                           onPressed: () => _showRejectDialog(request.jeevanadiId),
//                                           style: OutlinedButton.styleFrom(
//                                             foregroundColor: Colors.red,
//                                             side: const BorderSide(color: Colors.red),
//                                             padding: const EdgeInsets.symmetric(vertical: 8),
//                                           ),
//                                           child: const Text('Reject', style: TextStyle(fontSize: 11)),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),
              
//               // Load More button
//               BlocBuilder<ReviewRequestBloc, ReviewRequestState>(
//                 builder: (context, state) {
//                   if (!state.hasReachedMax && state.requests.isNotEmpty) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       child: Center(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             context.read<ReviewRequestBloc>().add(
//                               FetchReviewRequestsEvent(
//                                 page: state.currentPage + 1,
//                                 size: _pageSize,
//                                 isLoadMore: true,
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.add_circle_outline),
//                           label: const Text("Load More"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF4F46E5),
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                   return const SizedBox.shrink();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

