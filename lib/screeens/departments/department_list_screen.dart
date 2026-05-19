import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:vikas_app/bloc_management/department/department_bloc.dart';
import 'package:vikas_app/bloc_management/department/department_event.dart';
import 'package:vikas_app/bloc_management/department/department_state.dart';
import 'package:vikas_app/screeens/common/add_button.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/departments/edit_department_page.dart';
import 'package:vikas_app/screeens/models/request/DepartmentRequest.dart';
import 'package:vikas_app/screeens/models/response/DepartmentResponse.dart';
import 'package:vikas_app/views/layouts/layout.dart';
import 'package:flutter/material.dart';

class DepartmentListPage extends StatefulWidget {
  const DepartmentListPage({super.key});

  @override
  State<DepartmentListPage> createState() => _DepartmentListPageState();
}

class _DepartmentListPageState extends State<DepartmentListPage> {
  @override
  void initState() {
    super.initState();
    context.read<DepartmentBloc>().add(FetchDepartmentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<DepartmentBloc, DepartmentState>(
          builder: (context, state) {
            switch (state.status) {
              case DepartmentStatus.loading:
              case DepartmentStatus.initial:
                return const Center(child: ScreenLoader());

              case DepartmentStatus.error:
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(state.errorMsg ?? "Something went wrong"),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          context.read<DepartmentBloc>().add(
                            FetchDepartmentsEvent(),
                          );
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );

              case DepartmentStatus.success:
                return SizedBox(
                  height: 90,
                  child: Column(
                    children: [
                      // ================= HEADER (same style as Users screen) =================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "All Departments",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),

                              Chip(
                                label: Text('${state.departments.length}'),
                                avatar: const Icon(Icons.business, size: 18),
                                backgroundColor: Colors.grey.shade200,
                              ),
                            ],
                          ),

                          AddButton().addButton(
                            context: context,
                            buttonText: "Add Department",
                            onClicked: () => _showAddDialog(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ================= COMMON LIST =================
                      Expanded(
                        child: CommonList<DepartmentResponse>(
                          users: state.departments,
                          currentPage: 0,
                          screenType: "DEPARTMENT",

                          onUserTap: (id) {
                            // optional: view department details
                          },

                          //                           onUpdate: (id) {
                          //                             final dept = state.departments.firstWhere(
                          //                               (e) => e.id.toString() == id,
                          //                             );
                          // Get.toNamed(
                          //   '/edit-department',
                          //   arguments: dept,
                          // );                         },
                          onUpdate: (id) {
                            // Find the full department object
                            final dept = state.departments.firstWhere(
                              (e) => e.id == id,
                              orElse: () => DepartmentResponse(),
                            );
                            // Pass the full object
                            Get.toNamed('/edit-department', arguments: dept);
                          },

                          onDelete: (id) {
                            _showDeleteConfirmation(id);
                          },
                        ),
                      ),
                    ],
                  ),
                );

              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  // ================= ADD =================
  void _showAddDialog() {
    final name = TextEditingController();
    final desc = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Department"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: "Department Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: desc,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (name.text.trim().isNotEmpty) {
                context.read<DepartmentBloc>().add(
                  CreateDepartmentEvent(
                    DepartmentRequest(
                      departmentName: name.text.trim(),
                      description: desc.text.trim(),
                    ),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  // ================= EDIT =================
  

  // ================= DELETE =================
  void _showDeleteConfirmation(String id) {
    final dept = context.read<DepartmentBloc>().state.departments.firstWhere(
      (e) => e.id == id,
      orElse: () => DepartmentResponse(),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Department"),
        content: Text(
          'Are you sure you want to delete "${dept.departmentName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Pass String id directly (no parsing needed)
              context.read<DepartmentBloc>().add(DeleteDepartmentEvent(id));
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
