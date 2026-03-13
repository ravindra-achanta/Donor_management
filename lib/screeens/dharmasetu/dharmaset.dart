import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_bloc.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_event.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_state.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/deletion_popup.dart';
import 'package:vikas_app/screeens/common/list_view.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/models/request/dharmasetu_model.dart';
import 'package:vikas_app/screeens/models/response/Dharmasetu_view.dart';

import 'package:vikas_app/views/layouts/layout.dart';

class DharmasetuListScreen extends StatefulWidget {
  const DharmasetuListScreen({super.key});

  @override
  State<DharmasetuListScreen> createState() => _DharmasetuListScreenState();
}

class _DharmasetuListScreenState extends State<DharmasetuListScreen> {
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
    DeletionPopup.showDeleteConfirmation(
      context: context,
      title: 'Delete Dharmasetu',
      message:
          'Are you sure you want to delete "$name"?\nThis action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      onConfirm: () {
        // This will be called after the popup is dismissed and user confirms
        if (context.mounted) {
          context.read<DharmasetuBloc>().add(DeleteDharmasetu(id));
          // Hide profile view after delete
          setState(() {
            _isProfileViewVisible = false;
            _selectedDharmasetu = null;
          });
        }
      },
    );
  }

  void _onDharmasetuTap(String id, List<DharmasetuView> dharmasetuList) {
    try {
      final dharmasetu = dharmasetuList.firstWhere((d) => d.id == id);

      setState(() {
        _isProfileViewVisible = true;
        _isProfileLoading = true;
        _selectedDharmasetu = dharmasetu;
      });

      context.read<DharmasetuBloc>().add(LoadDharmasetuDetails(id));
    } catch (e) {
      debugPrint('Dharmasetu not found with id: $id');
      setState(() {
        _isProfileLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<DharmasetuBloc, DharmasetuState>(
          listener: (context, state) {
            // Handle profile loading states
            if (state.profileLoading == true) {
              setState(() {
                _isProfileLoading = true;
              });
            } else if (state.profileLoading == false) {
              setState(() {
                _isProfileLoading = false;
              });
            }

            // Update selected dharmasetu when details are loaded
            if (state.selectedDharmasetuView != null) {
              setState(() {
                _selectedDharmasetu = state.selectedDharmasetuView;
              });
            }

            // Handle profile error
            if (state.profileErrorMsg != null) {
              setState(() {
                _isProfileLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.profileErrorMsg!),
                  backgroundColor: Colors.red,
                ),
              );
            }

            // Handle success messages
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: Colors.green,
                ),
              );
            }

            // Handle error messages
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
            if (state.status == DharmasetuApiStatus.loading &&
                state.dharmasetuList.isEmpty) {
              return const Center(child: ScreenLoader());
            } else if (state.status == DharmasetuApiStatus.error &&
                state.dharmasetuList.isEmpty) {
              return Center(
                child: ErrorCard(
                  message: state.errorMessage ?? 'Failed to load dharmasetu',
                  onRetry: () {
                    context.read<DharmasetuBloc>().add(
                      const LoadDharmasetu(page: 0),
                    );
                  },
                ),
              );
            } else {
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
                              Row(
                                children: [
                                  const Text(
                                    "Dharmasetu Records :",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text('${state!.totalElements}'),
                                    avatar: const Icon(Icons.people, size: 18),
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                ],
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
                                users: state.dharmasetuList,
                                screenType: "DHARMASETU",
                                onUserTap: (id) {
                                  _onDharmasetuTap(id, state.dharmasetuList);
                                },
                                onDelete: (id) {
                                  String? userType = Vikasdb().getString(
                                    "USER_TYPE",
                                  );
                                  bool canDelete =
                                      userType == "OFFICE_STAFF" ||
                                      userType == "KARYAKARTHA";

                                  if (canDelete) {
                                    final item = state.dharmasetuList
                                        .firstWhere((d) => d.id == id);
                                    _showDeleteDialog(
                                      context,
                                      id,
                                      item.communityName,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'You do not have permission to delete',
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                onUpdate: (id) {
                                  final item = state.dharmasetuList.firstWhere(
                                    (d) => d.id == id,
                                  );
                                  final model = DharmasetuModel.fromView(item);
                                  Get.toNamed(
                                    '/add/dharmasetu',
                                    arguments: {'model': model, 'isEdit': true},
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
                                              context
                                                  .read<DharmasetuBloc>()
                                                  .add(
                                                    LoadDharmasetu(
                                                      page:
                                                          state.currentPage - 1,
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
                                      onPressed:
                                          state.currentPage <
                                              state.totalPages - 1
                                          ? () {
                                              context
                                                  .read<DharmasetuBloc>()
                                                  .add(
                                                    LoadDharmasetu(
                                                      page:
                                                          state.currentPage + 1,
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
                                key: ValueKey(
                                  'profile_${_selectedDharmasetu?.id}',
                                ),
                                // data: (_selectedDharmasetu,),
                                data: _selectedDharmasetu,
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
                                      _selectedDharmasetu!.communityName,
                                    );
                                  }
                                },
                                onViewMore: () {
                                  if (_selectedDharmasetu != null) {
                                    Get.toNamed(
                                      '/view/dharmasetu',
                                      arguments: _selectedDharmasetu!.id,
                                    );
                                  }
                                },
                              ),
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
