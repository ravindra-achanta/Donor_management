// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vikas_app/views/layouts/layout.dart';

// class ViewDharmasetu extends StatefulWidget {
//   final Map<String, dynamic>? dharmaData;

//   const ViewDharmasetu({super.key, this.dharmaData});

//   @override
//   State<ViewDharmasetu> createState() => _ViewDharmaSetuState();
// }

// class _ViewDharmaSetuState extends State<ViewDharmasetu> {
//   late Map<String, dynamic> dharma;

//   @override
//   void initState() {
//     super.initState();
//     // Get dharma data from arguments or use provided data with defaults
//     final args = Get.arguments;
//     if (args != null && args is Map) {
//       dharma = args as Map<String, dynamic>;
//     } else if (widget.dharmaData != null) {
//       dharma = widget.dharmaData!;
//     } else {
//       // Default empty dharma structure
//       dharma = {
//         'id': '',
//         'uid': 'N/A',
//         'type': 'N/A',
//         'name': 'Unknown',
//         'feedback': '',
//         'date': 'N/A',
//         'referredBy': 'N/A',
//         'status': 'N/A',
//       };
//     }
//   }

//   /// Safe getter for dharma properties
//   String _getDharmaValue(String key, [String defaultValue = 'N/A']) {
//     try {
//       final value = dharma[key];
//       if (value == null) return defaultValue;
//       return value.toString();
//     } catch (e) {
//       return defaultValue;
//     }
//   }

//   /// Get type badge color
//   Color _getTypeColor(String type) {
//     switch (type.toLowerCase()) {
//       case 'community':
//         return Colors.purple;
//       case 'home':
//         return Colors.indigo;
//       case 'virtual':
//         return Colors.teal;
//       default:
//         return Colors.grey;
//     }
//   }

//   /// Get status badge color
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'active':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'completed':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }

//   /// Build detail row
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build badge
//   Widget _buildBadge(String label, String value, Color color) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 6,
//               ),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: color),
//               ),
//               child: Text(
//                 value,
//                 style: TextStyle(
//                   color: color,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Delete confirmation dialog
//   void _showDeleteDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete Dharmasetu'),
//           content: Text(
//             'Are you sure you want to delete the dharmasetu record for ${_getDharmaValue('name', 'this record')}?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Dharmasetu record deleted for ${_getDharmaValue('name')}'),
//                     backgroundColor: Colors.red,
//                     duration: const Duration(seconds: 2),
//                   ),
//                 );
//                 Future.delayed(const Duration(seconds: 1), () {
//                   Get.offNamed('/dharmasetu');
//                 });
//               },
//               style: TextButton.styleFrom(foregroundColor: Colors.red),
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Layout(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Header with dharmasetu name
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Dharmasetu Details',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             _getDharmaValue('name', 'Unknown'),
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.deepPurple.shade100,
//                         child: Text(
//                           _getDharmaValue('name', 'U')
//                               .substring(0, 1)
//                               .toUpperCase(),
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.deepPurple,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const Divider(height: 32),

//                   /// Basic Information Section
//                   const Text(
//                     'Basic Information',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   _buildDetailRow('UID', _getDharmaValue('uid')),
//                   _buildBadge('Type', _getDharmaValue('type'), _getTypeColor(_getDharmaValue('type'))),
//                   _buildDetailRow('Name', _getDharmaValue('name')),
//                   _buildDetailRow('Date', _getDharmaValue('date')),
//                   _buildDetailRow('Referred By', _getDharmaValue('referredBy')),

//                   const Divider(height: 32),

//                   /// Status Section
//                   const Text(
//                     'Status',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   _buildBadge('Status', _getDharmaValue('status'), _getStatusColor(_getDharmaValue('status'))),

//                   const Divider(height: 32),

//                   /// Feedback Section
//                   const Text(
//                     'Feedback',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(8),
//                             color: Colors.grey.shade50,
//                           ),
//                           child: Text(
//                             _getDharmaValue('feedback', 'No feedback provided'),
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 32),

//                   /// Action Buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       /// Back Button
//                       OutlinedButton.icon(
//                         onPressed: () {
//                           Get.back();
//                         },
//                         icon: const Icon(Icons.arrow_back),
//                         label: const Text('Back'),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 32,
//                             vertical: 16,
//                           ),
//                           side: const BorderSide(
//                             color: Colors.grey,
//                             width: 1.5,
//                           ),
//                           foregroundColor: Colors.grey.shade700,
//                         ),
//                       ),
//                       const SizedBox(width: 16),

//                       /// Edit Button
//                       OutlinedButton.icon(
//                         onPressed: () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 'Edit dharmasetu for ${_getDharmaValue('name')}',
//                               ),
//                               duration: const Duration(seconds: 2),
//                             ),
//                           );
//                           // TODO: Navigate to edit dharmasetu page
//                           // Get.toNamed('/edit/dharmasetu', arguments: dharma);
//                         },
//                         icon: const Icon(Icons.edit),
//                         label: const Text('Edit'),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 32,
//                             vertical: 16,
//                           ),
//                           side: const BorderSide(
//                             color: Colors.orange,
//                             width: 1.5,
//                           ),
//                           foregroundColor: Colors.orange,
//                         ),
//                       ),
//                       const SizedBox(width: 16),

//                       /// Delete Button
//                       ElevatedButton.icon(
//                         onPressed: _showDeleteDialog,
//                         icon: const Icon(Icons.delete),
//                         label: const Text('Delete'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 32,
//                             vertical: 16,
//                           ),
//                           elevation: 4,
//                           shadowColor: Colors.red.withOpacity(0.5),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ViewDharmasetu extends StatefulWidget {
  final Map<String, dynamic>? dharmaData;

  const ViewDharmasetu({super.key, this.dharmaData});

  @override
  State<ViewDharmasetu> createState() => _ViewDharmaSetuState();
}

class _ViewDharmaSetuState extends State<ViewDharmasetu> {
  late Map<String, dynamic> dharma;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args is Map) {
      dharma = args as Map<String, dynamic>;
    } else if (widget.dharmaData != null) {
      dharma = widget.dharmaData!;
    } else {
      dharma = {
        'uid': 'N/A',
        'type': 'N/A',
        'name': 'Unknown',
        'feedback': '',
        'date': 'N/A',
        'referredBy': 'N/A',
        'status': 'N/A',
      };
    }
  }

  String _get(String key, [String fallback = 'N/A']) =>
      dharma[key]?.toString() ?? fallback;

  Color _typeColor(String type) {
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

  Color _statusColor(String status) {
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

  // ---------------- UI HELPERS ----------------

  Widget _section(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// HEADER
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 247, 248, 156),
                      const Color.fromARGB(255, 161, 146, 78),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: Text(
                        _get('name').substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _get('name'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dharmasetu Details',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// BASIC INFO
              _section(
                'Basic Information',
                Column(
                  children: [
                    _row('UID', _get('uid')),
                    _badge('Type', _get('type'), _typeColor(_get('type'))),
                    _row('Name', _get('name')),
                    _row('Date', _get('date')),
                    _row('Referred By', _get('referredBy')),
                  ],
                ),
              ),

              /// STATUS
              _section(
                'Status',
                _badge(
                  'Current Status',
                  _get('status'),
                  _statusColor(_get('status')),
                ),
              ),

              /// FEEDBACK
              _section(
                'Feedback',
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    _get('feedback', 'No feedback provided'),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),

              /// ACTION BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Edit
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}