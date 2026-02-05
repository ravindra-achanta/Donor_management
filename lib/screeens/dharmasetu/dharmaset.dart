import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/views/layouts/layout.dart';

/// Dharmasetu Model
class Dharmasetu {
  final String id;
  final String uid;
  final String type; // community, home, virtual
  final String name;
  final String feedback;
  final String date;
  final String referredBy;
  final String status;

  Dharmasetu({
    required this.id,
    required this.uid,
    required this.type,
    required this.name,
    required this.feedback,
    required this.date,
    required this.referredBy,
    required this.status,
  });
}

// Sample data
List<Dharmasetu> sampleDharmasetu = [
  Dharmasetu(
    id: '1',
    uid: 'DM001',
    type: 'Community',
    name: 'Community Outreach Program',
    feedback: 'Excellent community engagement',
    date: '2024-01-15',
    referredBy: 'Rajesh Kumar',
    status: 'Active',
  ),
  Dharmasetu(
    id: '2',
    uid: 'DM002',
    type: 'Home',
    name: 'Home Assistance Program',
    feedback: 'Good response from members',
    date: '2024-01-20',
    referredBy: 'Priya Singh',
    status: 'Active',
  ),
  Dharmasetu(
    id: '3',
    uid: 'DM003',
    type: 'Virtual',
    name: 'Online Spiritual Sessions',
    feedback: 'High attendance rate',
    date: '2024-01-25',
    referredBy: 'Amit Patel',
    status: 'Pending',
  ),
  Dharmasetu(
    id: '4',
    uid: 'DM004',
    type: 'Community',
    name: 'Community Health Camp',
    feedback: 'Very successful event',
    date: '2024-02-01',
    referredBy: 'Neha Gupta',
    status: 'Completed',
  ),
  Dharmasetu(
    id: '5',
    uid: 'DM005',
    type: 'Home',
    name: 'Home Prayer Sessions',
    feedback: 'Positive family feedback',
    date: '2024-02-05',
    referredBy: 'Vikram Reddy',
    status: 'Active',
  ),
];

class DhramSetuScreen extends StatefulWidget {
  const DhramSetuScreen({super.key});

  @override
  State<DhramSetuScreen> createState() => _DhramSetuScreenState();
}

class _DhramSetuScreenState extends State<DhramSetuScreen> {
  late List<Dharmasetu> dharmasetus;

  @override
  void initState() {
    super.initState();
    // Initialize list from sample data
    dharmasetus = List.from(sampleDharmasetu);
  }

  /// Get status badge color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  /// Get type badge color
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'community':
        return Colors.purple;
      case 'home':
        return Colors.indigo;
      case 'virtual':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  /// Show delete confirmation dialog
  void _showDeleteDialog(Dharmasetu dharma) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Dharmasetu'),
          content: Text(
            'Are you sure you want to delete the dharmasetu record for ${dharma.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  dharmasetus.removeWhere((d) => d.id == dharma.id);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Dharmasetu record deleted for ${dharma.name}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
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
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height - 180,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Dharmasetu",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed('/add/dharmasetu');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Dharmasetu"),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                /// DATA TABLE
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        columnSpacing: 15,
                        dataRowHeight: 70,
                        columns: const [
                          DataColumn(label: Text('UID')),
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Feedback')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Referred By')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: dharmasetus.map((dharma) {
                          return DataRow(cells: [
                            DataCell(Text(dharma.uid)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getTypeColor(dharma.type)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _getTypeColor(dharma.type),
                                  ),
                                ),
                                child: Text(
                                  dharma.type,
                                  style: TextStyle(
                                    color: _getTypeColor(dharma.type),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(dharma.name)),
                            DataCell(
                              SizedBox(
                                width: 150,
                                child: Text(
                                  dharma.feedback,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(Text(dharma.date)),
                            DataCell(Text(dharma.referredBy)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(dharma.status)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _getStatusColor(dharma.status),
                                  ),
                                ),
                                child: Text(
                                  dharma.status,
                                  style: TextStyle(
                                    color: _getStatusColor(dharma.status),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'View',
                                    icon: const Icon(
                                      Icons.visibility_outlined,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      Get.toNamed('/view/dharmasetu', arguments: {
                                        'id': dharma.id,
                                        'uid': dharma.uid,
                                        'type': dharma.type,
                                        'name': dharma.name,
                                        'feedback': dharma.feedback,
                                        'date': dharma.date,
                                        'referredBy': dharma.referredBy,
                                        'status': dharma.status,
                                      });
                                    },
                                  ),
                                  IconButton(
                                    tooltip: 'Edit',
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      // TODO: Navigate to edit dharmasetu page
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Edit feature coming soon for ${dharma.name}'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    tooltip: 'Delete',
                                    icon: const Icon(
                                      Icons.delete_outlined,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _showDeleteDialog(dharma);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                /// PAGINATION
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_previous_outlined),
                      ),
                      const Text("1/1"),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_next_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
