// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_bloc.dart';
// import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_event.dart';
// import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_state.dart';
// import 'package:vikas_app/screeens/common/ErrorText.dart';
// import 'package:vikas_app/screeens/common/common_list.dart';
// import 'package:vikas_app/screeens/common/loader.dart';
// import 'package:vikas_app/screeens/models/response/dharmasetu_view.dart';
// import 'package:vikas_app/views/layouts/layout.dart';

// class DharmasetuListScreen extends StatefulWidget {
//   const DharmasetuListScreen({super.key});

//   @override
//   State<DharmasetuListScreen> createState() => _DharmasetuListScreenState();
// }

// class _DharmasetuListScreenState extends State<DharmasetuListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         context.read<DharmasetuBloc>().add(const LoadDharmasetu(page: 0));
//       }
//     });
//   }

//   void _showDeleteDialog(BuildContext context, String id, String name) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete Dharmasetu'),
//           content: Text('Are you sure you want to delete "$name"?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 if (context.mounted) {
//                   context.read<DharmasetuBloc>().add(DeleteDharmasetu(id));
//                 }
//               },
//               style: TextButton.styleFrom(foregroundColor: Colors.red),
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Layout(
//       child: Container(
//         width: double.infinity,
//         height: MediaQuery.of(context).size.height,
//         padding: const EdgeInsets.all(16),
//         child: BlocBuilder<DharmasetuBloc, DharmasetuState>(
//           builder: (context, state) {
//             if (state is DharmasetuLoading) {
//               return const Center(child: ScreenLoader());
//             } else if (state is DharmasetuError) {
//               return Center(child: ErrorCard(message: state.message));
//             } else if (state is DharmasetuLoaded) {
//               // Convert DharmasetuModel to DharmasetuView for CommonList
//               final List<DharmasetuView> viewList = state.dharmasetuList
//                   .map((model) => DharmasetuView.fromDharmasetuModel(model))
//                   .toList();

//               // Calculate total pages (assuming 10 items per page)
//               final int totalPages = (state.dharmasetuList.length / 10).ceil();

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header with title and add button
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Dharmasetu Records",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.refresh),
//                               onPressed: () {
//                                 context.read<DharmasetuBloc>().add(
//                                   const LoadDharmasetu(page: 0),
//                                 );
//                               },
//                             ),
//                             const SizedBox(width: 8),
//                             ElevatedButton.icon(
//                               onPressed: () {
//                                 Get.toNamed('/add/dharmasetu');
//                               },
//                               icon: const Icon(Icons.add),
//                               label: const Text("Add Dharmasetu"),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: SizedBox(
//                       height: MediaQuery.of(context).size.height - 220,
//                       child: Column(
//                         children: [
//                           // Common List widget with view icon in actions
//                           Expanded(
//                             child: ClipRRect(
//                               borderRadius: const BorderRadius.vertical(
//                                 top: Radius.circular(12),
//                               ),
//                               child: SingleChildScrollView(
//                                 physics: const AlwaysScrollableScrollPhysics(),
//                                 child: CommonList<DharmasetuView>(
//                                   currentPage: 0,
//                                   users: viewList,
//                                   screenType: "DHARMASETU",
//                                   onUserTap: (id) {
//                                     print('Row tapped: $id');
//                                   },
//                                   onDelete: (id) {
//                                     final item = viewList.firstWhere(
//                                       (d) => d.id == id,
//                                     );
//                                     _showDeleteDialog(context, id, item.name);
//                                   },
//                                   onUpdate: (id) {
//                                     Get.snackbar(
//                                       'Info',
//                                       'Edit functionality coming soon for ID: $id',
//                                       snackPosition: SnackPosition.BOTTOM,
//                                     );
//                                   },
//                                   onApprove: (id) {
//                                     Get.snackbar(
//                                       'View Details',
//                                       'Viewing details for ID: $id',
//                                       snackPosition: SnackPosition.BOTTOM,
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),

//                           // Pagination
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade50,
//                               borderRadius: const BorderRadius.vertical(
//                                 bottom: Radius.circular(12),
//                               ),
//                               border: Border(
//                                 top: BorderSide(color: Colors.grey.shade200),
//                               ),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 50,
//                                 vertical: 12,
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   IconButton(
//                                     onPressed: null,
//                                     icon: const Icon(
//                                       Icons.skip_previous_outlined,
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 8,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey.shade100,
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Text(
//                                       "1/${totalPages}",
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                   IconButton(
//                                     onPressed: null,
//                                     icon: const Icon(Icons.skip_next_outlined),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }
//             return const Center(child: ScreenLoader());
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_bloc.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_event.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_state.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/list_view.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/models/response/dharmasetu_view.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class DharmasetuListScreen extends StatefulWidget {
  const DharmasetuListScreen({super.key});

  @override
  State<DharmasetuListScreen> createState() => _DharmasetuListScreenState();
}

class _DharmasetuListScreenState extends State<DharmasetuListScreen> {
  // Track selected dharmasetu for profile view
  DharmasetuView? _selectedDharmasetu;
  bool _isProfileViewVisible = false;
  bool _isProfileLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DharmasetuBloc>().add(const LoadDharmasetu(page: 0));
      }
    });
  }

  void _showDeleteDialog(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Dharmasetu'),
          content: Text('Are you sure you want to delete "$name"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (context.mounted) {
                  context.read<DharmasetuBloc>().add(DeleteDharmasetu(id));
                  // Hide profile view after delete
                  setState(() {
                    _isProfileViewVisible = false;
                    _selectedDharmasetu = null;
                  });
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Handle row tap to show profile view
  void _onDharmasetuTap(String id, List<DharmasetuView> dharmasetuList) {
    try {
      final dharmasetu = dharmasetuList.firstWhere((d) => d.id == id);
      setState(() {
        _selectedDharmasetu = dharmasetu;
        _isProfileViewVisible = true;
        _isProfileLoading = false;
      });
    } catch (e) {
      debugPrint('Dharmasetu not found with id: $id');
    }
  }

  // Convert DharmasetuView to User format that ListViewScreen expects
  User? _convertDharmasetuToUser(DharmasetuView? dharmasetu) {
    if (dharmasetu == null) return null;

    return User(
      id: dharmasetu.id,
      name: dharmasetu.name,
      email: '',
      mobileNumber: '',
      userType: 'Dharmasetu',
      status: dharmasetu.status,
      uniqueId: dharmasetu.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<DharmasetuBloc, DharmasetuState>(
          builder: (context, state) {
            if (state is DharmasetuLoading) {
              return const Center(child: ScreenLoader());
            } else if (state is DharmasetuError) {
              return Center(child: ErrorCard(message: state.message));
            } else if (state is DharmasetuLoaded) {
              // Convert DharmasetuModel to DharmasetuView for CommonList
              final List<DharmasetuView> viewList = state.dharmasetuList
                  .map((model) => DharmasetuView.fromDharmasetuModel(model))
                  .toList();

              return Row(
                children: [
                  // Main list section (70%)
                  Expanded(
                    flex: _isProfileViewVisible ? 6 : 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with title and add button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Dharmasetu Records",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () {
                                      context.read<DharmasetuBloc>().add(
                                        const LoadDharmasetu(page: 0),
                                      );
                                      // Hide profile view on refresh
                                      setState(() {
                                        _isProfileViewVisible = false;
                                        _selectedDharmasetu = null;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Get.toNamed('/add/dharmasetu');
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text("Add Dharmasetu"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // List card
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              CommonList<DharmasetuView>(
                                currentPage: state.currentPage,
                                users: viewList,
                                screenType: "DHARMASETU",
                                onUserTap: (id) {
                                  _onDharmasetuTap(id, viewList);
                                },
                                onDelete: (id) {
                                  final item = viewList.firstWhere(
                                    (d) => d.id == id,
                                  );
                                  _showDeleteDialog(context, id, item.name);
                                },
                                onUpdate: (id) {
                                  final item = viewList.firstWhere(
                                    (d) => d.id == id,
                                  );
                                  Get.toNamed(
                                    '/edit/dharmasetu',
                                    arguments: item,
                                  );
                                },
                              ),
                              
                              // Pagination
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: state.currentPage > 0
                                          ? () {
                                              context.read<DharmasetuBloc>().add(
                                                LoadDharmasetu(
                                                  page: state.currentPage - 1,
                                                ),
                                              );
                                              // Hide profile view on page change
                                              setState(() {
                                                _isProfileViewVisible = false;
                                                _selectedDharmasetu = null;
                                              });
                                            }
                                          : null,
                                      icon: const Icon(
                                        Icons.skip_previous_outlined,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "${state.currentPage + 1}/${state.totalPages}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: state.currentPage <
                                          state.totalPages - 1
                                          ? () {
                                              context.read<DharmasetuBloc>().add(
                                                LoadDharmasetu(
                                                  page: state.currentPage + 1,
                                                ),
                                              );
                                              setState(() {
                                                _isProfileViewVisible = false;
                                                _selectedDharmasetu = null;
                                              });
                                            }
                                          : null,
                                      icon: const Icon(
                                        Icons.skip_next_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile view section (30%)
                  if (_isProfileViewVisible)
                    Expanded(
                      flex: 3,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              ...previousChildren,
                              if (currentChild != null) currentChild,
                            ],
                          );
                        },
                        transitionBuilder: (child, animation) {
                          final slideAnimation = Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(animation);

                          final fadeAnimation = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(animation);

                          return FadeTransition(
                            opacity: fadeAnimation,
                            child: SlideTransition(
                              position: slideAnimation,
                              child: child,
                            ),
                          );
                        },
                        child: _isProfileLoading
                            ? const ScreenLoader(key: ValueKey('loader'))
                            : ListViewScreen(
                                key: ValueKey('profile_${_selectedDharmasetu?.id}'),
                                user: _convertDharmasetuToUser(_selectedDharmasetu),
                                dharmasetuData: _selectedDharmasetu,
                                onClose: () {
                                  setState(() {
                                    _isProfileViewVisible = false;
                                    _selectedDharmasetu = null;
                                  });
                                },
                                screenType: "DHARMASETU",
                                onDelete: () {
                                  if (_selectedDharmasetu != null) {
                                    _showDeleteDialog(
                                      context,
                                      _selectedDharmasetu!.id,
                                      _selectedDharmasetu!.name,
                                    );
                                  }
                                },
                                onViewMore: () {
                                  if (_selectedDharmasetu != null) {
                                    Get.toNamed(
                                      '/view/dharmasetu',
                                      arguments: _selectedDharmasetu,
                                    );
                                  }
                                },
                              ),
                      ),
                    ),
                ],
              );
            }
            return const Center(child: ScreenLoader());
          },
        ),
      ),
    );
  }
}
