import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ViewVisit extends StatefulWidget {
  final Map<String, dynamic>? visitData;

  const ViewVisit({super.key, this.visitData});

  @override
  State<ViewVisit> createState() => _ViewVisitState();
}

class _ViewVisitState extends State<ViewVisit> {
  late Map<String, dynamic> visit;

  @override
  void initState() {
    super.initState();
    // Get visit data from arguments or use provided data with defaults
    final args = Get.arguments;
    if (args != null && args is Map) {
      visit = args as Map<String, dynamic>;
    } else if (widget.visitData != null) {
      visit = widget.visitData!;
    } else {
      // Default empty visit structure
      visit = {
        'id': '',
        'jeevandNum': 'N/A',
        'name': 'Unknown',
        'phone': 'N/A',
        'email': 'N/A',
        'visitPurpose': 'N/A',
        'noOfGuests': 0,
        'comments': '',
      };
    }
  }

  /// Safe getter for visit properties
  String _getVisitValue(String key, [String defaultValue = 'N/A']) {
    try {
      final value = visit[key];
      if (value == null) return defaultValue;
      return value.toString();
    } catch (e) {
      return defaultValue;
    }
  }

  /// Build detail row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Delete confirmation dialog
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Visit'),
          content: Text(
            'Are you sure you want to delete the visit record for ${_getVisitValue('name', 'this member')}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Visit record deleted for ${_getVisitValue('name')}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
                Future.delayed(const Duration(seconds: 1), () {
                  Get.offNamed('/visits');
                });
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header with visitor name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Visit Details',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getVisitValue('name', 'Unknown'),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      // CircleAvatar(
                      //   radius: 40,
                      //   backgroundColor: Colors.blue.shade100,
                      //   child: Text(
                      //     _getVisitValue('name', 'U')
                      //         .substring(0, 1)
                      //         .toUpperCase(),
                      //     style: const TextStyle(
                      //       fontSize: 24,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.blue,
                      //     ),
                      //   ),
                      // ),
                      CircleAvatar(
  radius: 40,
  backgroundColor: Colors.blue.shade100,
  child: Text(
    (_getVisitValue('name').isNotEmpty
            ? _getVisitValue('name')[0]
            : 'U')
        .toUpperCase(),
    style: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.blue,
    ),
  ),
),
                    ],
                  ),

                  const Divider(height: 32),

                  /// Member Information Section
                  const Text(
                    'Member Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow('Jeevandi Number', _getVisitValue('jeevandNum')),
                  _buildDetailRow('Name', _getVisitValue('name')),
                  _buildDetailRow('Phone', _getVisitValue('phone')),
                  _buildDetailRow('Email', _getVisitValue('email')),

                  const Divider(height: 32),

                  /// Visit Information Section
                  const Text(
                    'Visit Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow('Visit Purpose', _getVisitValue('visitPurpose')),
                  _buildDetailRow(
                    'Number of Guests',
                    _getVisitValue('noOfGuests', '0'),
                  ),

                  const Divider(height: 32),

                  /// Additional Information Section
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Comments',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade50,
                          ),
                          child: Text(
                            _getVisitValue('comments', 'No comments'),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// Back Button
                      OutlinedButton.icon(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                          foregroundColor: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 16),

                      /// Edit Button
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Edit visit for ${visit['name']}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          // TODO: Navigate to edit visit page
                          // Get.toNamed('/edit/visit', arguments: visit);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          side: const BorderSide(
                            color: Colors.orange,
                            width: 1.5,
                          ),
                          foregroundColor: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),

                      /// Delete Button
                      ElevatedButton.icon(
                        onPressed: _showDeleteDialog,
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          elevation: 4,
                          shadowColor: Colors.red.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
