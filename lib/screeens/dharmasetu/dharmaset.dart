import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_bloc.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_event.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_state.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/models/response/dharmasetu_view.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class DharmasetuListScreen extends StatefulWidget {
  const DharmasetuListScreen({super.key});

  @override
  State<DharmasetuListScreen> createState() => _DharmasetuListScreenState();
}

class _DharmasetuListScreenState extends State<DharmasetuListScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
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

              // Calculate total pages (assuming 10 items per page)
              final int totalPages = (state.dharmasetuList.length / 10).ceil();

              return Column(
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

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 220,
                      child: Column(
                        children: [
                          // Common List widget with view icon in actions
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: CommonList<DharmasetuView>(
                                  currentPage: 0,
                                  users: viewList,
                                  screenType: "DHARMASETU",
                                  onUserTap: (id) {
                                    print('Row tapped: $id');
                                  },
                                  onDelete: (id) {
                                    final item = viewList.firstWhere(
                                      (d) => d.id == id,
                                    );
                                    _showDeleteDialog(context, id, item.name);
                                  },
                                  onUpdate: (id) {
                                    Get.snackbar(
                                      'Info',
                                      'Edit functionality coming soon for ID: $id',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  },
                                  onApprove: (id) {
                                    Get.snackbar(
                                      'View Details',
                                      'Viewing details for ID: $id',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          // Pagination
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(12),
                              ),
                              border: Border(
                                top: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: null,
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
                                      "1/${totalPages}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: null,
                                    icon: const Icon(Icons.skip_next_outlined),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
