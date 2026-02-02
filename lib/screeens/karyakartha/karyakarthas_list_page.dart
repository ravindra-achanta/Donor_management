import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class KaryakarthasListPage extends StatelessWidget {
  const KaryakarthasListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the whole page in the Layout widget
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= HEADER =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Karyakarthas",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to Add Karyakartha page
                    // Get.toNamed('/karyakarthas/add');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Karyakartha"),
                )
              ],
            ),
            const SizedBox(height: 16),

            /// ================= TABLE CARD =================
            SizedBox(
              height: MediaQuery.of(context).size.height - 220,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _buildTable(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= DATA TABLE =================
  Widget _buildTable() {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 48,
            dataRowHeight: 56,
            headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
            columnSpacing: 48,
            columns: const [
              DataColumn(label: Text('K.ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Mobile')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: List.generate(10, (index) {
              return DataRow(
                cells: [
                  DataCell(Text('K-${index + 1}')),
                  const DataCell(Text('Ravi Kumar')),
                  const DataCell(Text('9876543210')),

                  /// STATUS
                  DataCell(
                    Switch(
                      value: index % 2 == 0,
                      onChanged: (value) {
                        // TODO: call status update API
                      },
                    ),
                  ),

                  /// ACTIONS
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'View',
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                             Get.toNamed('/karyakarthas/view', arguments: index);
                          },
                        ),
                        IconButton(
                          tooltip: 'Edit',
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            // Get.toNamed('/karyakarthas/edit', arguments: index);
                          },
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: _confirmDelete,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  /// ================= DELETE CONFIRM =================
  void _confirmDelete() {
    Get.defaultDialog(
      title: "Delete Karyakartha",
      middleText: "Are you sure you want to delete this karyakartha?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        // TODO: call delete API
      },
    );
  }
}
