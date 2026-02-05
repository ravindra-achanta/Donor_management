// import 'package:flutter/material.dart';
// import 'package:vikas_app/views/layouts/layout.dart';

// class Visits extends StatefulWidget {
//   const Visits({super.key});

//   @override
//   State<Visits> createState() => _VisitsState();
// }

// class _VisitsState extends State<Visits> {
//   @override
//   Widget build(BuildContext context) {
//     return Layout(child: Center(child: Text("Visits")));
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/views/layouts/layout.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/NoDataFound.dart';
import 'package:vikas_app/screeens/common/loader.dart';

/// TEMP MODELS (replace later)
class Visit {
  final String id;
  final String jeevandNum;
  final String name;
  final String phone;
  final String email;
  final String visitPurpose;
  final int noOfGuests;

  Visit({
    required this.id,
    required this.jeevandNum,
    required this.name,
    required this.phone,
    required this.email,
    required this.visitPurpose,
    required this.noOfGuests,
  });
}

// Sample data
List<Visit> sampleVisits = [
  Visit(
    id: '1',
    jeevandNum: 'JN001',
    name: 'Rajesh Kumar',
    phone: '9876543210',
    email: 'rajesh@example.com',
    visitPurpose: 'General Visit',
    noOfGuests: 2,
  ),
  Visit(
    id: '2',
    jeevandNum: 'JN002',
    name: 'Priya Singh',
    phone: '9876543211',
    email: 'priya@example.com',
    visitPurpose: 'Donation',
    noOfGuests: 1,
  ),
  Visit(
    id: '3',
    jeevandNum: 'JN003',
    name: 'Amit Patel',
    phone: '9876543212',
    email: 'amit@example.com',
    visitPurpose: 'Volunteering',
    noOfGuests: 3,
  ),
  Visit(
    id: '4',
    jeevandNum: 'JN004',
    name: 'Neha Gupta',
    phone: '9876543213',
    email: 'neha@example.com',
    visitPurpose: 'Event Participation',
    noOfGuests: 2,
  ),
  Visit(
    id: '5',
    jeevandNum: 'JN005',
    name: 'Vikram Reddy',
    phone: '9876543214',
    email: 'vikram@example.com',
    visitPurpose: 'General Visit',
    noOfGuests: 4,
  ),
];

class Visits extends StatefulWidget {
  const Visits({super.key});

  @override
  State<Visits> createState() => _VisitsState();
}

class _VisitsState extends State<Visits> {
  late List<Visit> visits;

  @override
  void initState() {
    super.initState();
    // Initialize visits list from sample data
    visits = List.from(sampleVisits);
    // TODO: dispatch FetchVisitsEvent(0)
  }

  /// Show delete confirmation dialog
  void _showDeleteDialog(Visit visit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Visit'),
          content: Text(
            'Are you sure you want to delete the visit record for ${visit.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                
                // Remove from list
                setState(() {
                  visits.removeWhere((v) => v.id == visit.id);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Visit record deleted for ${visit.name}'),
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
                        "Visits",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/add/visit');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Visit"),
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
                        columnSpacing: 20,
                        dataRowHeight: 60,
                        columns: const [
                          DataColumn(label: Text('Jeevandi Num')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Phone')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Visit Purpose')),
                          DataColumn(label: Text('No. of Guests')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: visits.map((visit) {
                          return DataRow(cells: [
                            DataCell(Text(visit.jeevandNum)),
                            DataCell(Text(visit.name)),
                            DataCell(Text(visit.phone)),
                            DataCell(Text(visit.email)),
                            DataCell(Text(visit.visitPurpose)),
                            DataCell(Text(visit.noOfGuests.toString())),
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
                                      Get.toNamed('/view/visit', arguments: {
                                        'id': visit.id,
                                        'jeevandNum': visit.jeevandNum,
                                        'name': visit.name,
                                        'phone': visit.phone,
                                        'email': visit.email,
                                        'visitPurpose': visit.visitPurpose,
                                        'noOfGuests': visit.noOfGuests,
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
                                    // onPressed: () {
                                    //   // TODO: Handle edit action
                                    //   if (context.mounted) {
                                    //     ScaffoldMessenger.of(context)
                                    //         .showSnackBar(
                                    //       SnackBar(
                                    //         content: Text(
                                    //             'Edit feature coming soon for ${visit.name}'),
                                    //       ),
                                    //     );
                                    //   }
                                    // },
                                     onPressed: () {
                          Navigator.pushNamed(context, '/add/visit');
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
                                      _showDeleteDialog(visit);
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