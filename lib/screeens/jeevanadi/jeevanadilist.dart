import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/screeens/models/request/jeevanadi_member.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class JeevanadiMembersPage extends StatelessWidget {
  const JeevanadiMembersPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  "Jeevanadi Members",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to Add Jeevanadi Member page
                    // Get.toNamed('/jeevanadi/add');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Jeevanadi Member"),
                ),
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
    // Sample Data
    final members = List.generate(
      10,
      (index) => JeevanadiMember(
        id: 'JN-100${index + 1}',
        name: index % 2 == 0 ? 'Arun Kumar' : 'Meena Patel',
        joined: '2024-0${index % 12 + 1}-0${index + 1}',
        mobile: '98765432${10 + index}',
        gothram: index % 2 == 0 ? 'Kashyapa' : 'Bharadwaja',
        referredBy: index % 2 == 0 ? 'Admin' : 'KA-001',
        email: index % 2 == 0 ? 'arun@example.com' : 'meena@example.com',
        role: 'DONOR',
        status: index % 2 == 0,
      ),
    );

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
              DataColumn(label: Text('SNO')),
              DataColumn(label: Text('JN-ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Mobile')),
              DataColumn(label: Text('Gothram')),
              DataColumn(label: Text('Referred By')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Role')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: List.generate(members.length, (index) {
              final member = members[index];
              return DataRow(
                cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(Text(member.id)),
                  DataCell(Text(member.name)),
                  DataCell(Text(member.mobile)),
                  DataCell(Text(member.gothram)),
                  DataCell(Text(member.referredBy)),
                  DataCell(Text(member.email)),
                  DataCell(Text(member.role)),

                  /// STATUS
                  DataCell(
                    Switch(
                      value: member.status,
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
                            // TODO: Navigate to View Page
                            // Get.toNamed('/jeevanadi/view', arguments: index);
                          },
                        ),
                        IconButton(
                          tooltip: 'Edit',
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            // TODO: Navigate to Edit Page
                            // Get.toNamed('/jeevanadi/edit', arguments: index);
                          },
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => _confirmDelete(member),
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
  void _confirmDelete(JeevanadiMember member) {
    Get.defaultDialog(
      title: "Delete Jeevanadi Member",
      middleText:
          "Are you sure you want to delete ${member.name} from Jeevanadi Members?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
      },
    );
  }
}