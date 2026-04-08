import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/Activity/activity_bloc.dart';
import 'package:vikas_app/bloc_management/Activity/activity_event.dart';
import 'package:vikas_app/bloc_management/Activity/activity_state.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/add_button.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/common/stats_grid.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen({super.key});

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityBloc>().add(
            const FetchActivitiesEvent(page: 0, pageSize: 10),
          );
    });
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          // TextButton(
          //   onPressed: () {
          //     Navigator.pop(dialogContext);
          //     context.read<ActivityBloc>().add(DeleteActivityEvent(id));
          //   },
          //   child: const Text('Delete', style: TextStyle(color: Colors.red)),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StatsGrid(visibleType: "ACTIVITY"),
            BlocBuilder<ActivityBloc, ActivityState>(
              builder: (context, state) {
                switch (state.status) {
                  case ActivityStatus.loading:
                    return const ScreenLoader();
                  case ActivityStatus.error:
                    return Center(
                      child: ErrorCard(message: state.errorMessage ?? 'Unknown error'),
                    );
                  case ActivityStatus.loaded:
                    return Column(
                      children: [
                        // Header with title, count chip, and add button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Call Logs List",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text('${state.totalElements}'),
                                    avatar: const Icon(Icons.assignment, size: 18),
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                ],
                              ),
                              AddButton().addButton(
                                context: context,
                                buttonText: "Add Call Data",
                                onClicked: () {
                                  Get.toNamed('/activity');
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              CommonList<dynamic>(
                                currentPage: state.currentPage,
                                users: state.activities,
                                screenType: 'ACTIVITY',
                                onUserTap: (id) {
                                  // Optional: handle tap
                                  print('Tapped activity: $id');
                                },
                                onDelete: (id) => _showDeleteConfirmation(context, id),
                                onUpdate: (id) {
                                  Get.toNamed('/activity-edit', arguments: id);
                                },
                              ),
                              // Pagination controls
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: state.currentPage > 0
                                          ? () {
                                              context.read<ActivityBloc>().add(
                                                    FetchActivitiesEvent(
                                                      page: state.currentPage - 1,
                                                      pageSize: 10,
                                                    ),
                                                  );
                                            }
                                          : null,
                                      icon: const Icon(Icons.skip_previous_outlined),
                                    ),
                                    Text(
                                      "${state.currentPage + 1}/${state.totalPages}",
                                    ),
                                    IconButton(
                                      onPressed: state.currentPage < state.totalPages - 1
                                          ? () {
                                              context.read<ActivityBloc>().add(
                                                    FetchActivitiesEvent(
                                                      page: state.currentPage + 1,
                                                      pageSize: 10,
                                                    ),
                                                  );
                                            }
                                          : null,
                                      icon: const Icon(Icons.skip_next_outlined),
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
    );
  }
}