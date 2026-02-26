// lib/screeens/visits/visits_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/visits/visit_bloc.dart';
import 'package:vikas_app/bloc_management/visits/visit_event.dart';
import 'package:vikas_app/bloc_management/visits/visit_state.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/models/response/visit_view.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class VisitsListScreen extends StatefulWidget {
  const VisitsListScreen({super.key});

  @override
  State<VisitsListScreen> createState() => _VisitsListScreenState();
}

class _VisitsListScreenState extends State<VisitsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<VisitBloc>().add(const LoadVisits(page: 0));
      }
    });
  }

  void _showDeleteDialog(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Visit'),
          content: Text(
            'Are you sure you want to delete the visit for "$name"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (context.mounted) {
                  context.read<VisitBloc>().add(DeleteVisit(id));
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
        child: BlocBuilder<VisitBloc, VisitState>(
          builder: (context, state) {
            if (state is VisitLoading) {
              return const Center(child: ScreenLoader());
            } else if (state is VisitError) {
              return Center(child: ErrorCard(message: state.message));
            } else if (state is VisitLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Visits",
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
                                context.read<VisitBloc>().add(
                                  const LoadVisits(page: 0),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                Get.toNamed('/add/visit');
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Add Visit"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            children: [
                              SizedBox(
                                height: constraints.maxHeight - 60,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: CommonList<VisitView>(
                                      currentPage: state.currentPage,
                                      users: state.visitList,
                                      screenType: "VISIT",
                                      onUserTap: (id) {
                                        // Row tap - optional
                                        print('Row tapped: $id');
                                      },
                                      onDelete: (id) {
                                        final item = state.visitList.firstWhere(
                                          (d) => d.id == id,
                                        );
                                        _showDeleteDialog(
                                          context,
                                          id,
                                          item.name,
                                        );
                                      },
                                      onUpdate: (id) {
                                        // Navigate to edit
                                        final item = state.visitList.firstWhere(
                                          (d) => d.id == id,
                                        );
                                        Get.toNamed(
                                          '/edit/visit',
                                          arguments: item,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              // Pagination - fixed at bottom
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(12),
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: state.currentPage > 0
                                            ? () {
                                                context.read<VisitBloc>().add(
                                                  LoadVisits(
                                                    page: state.currentPage - 1,
                                                  ),
                                                );
                                              }
                                            : null,
                                        icon: const Icon(
                                          Icons.skip_previous_outlined,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                                context.read<VisitBloc>().add(
                                                  LoadVisits(
                                                    page: state.currentPage + 1,
                                                  ),
                                                );
                                              }
                                            : null,
                                        icon: const Icon(
                                          Icons.skip_next_outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
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
