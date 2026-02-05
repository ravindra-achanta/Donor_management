// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vikas_app/views/layouts/layout.dart';

// // Sample member database for search
// List<Map<String, String>> memberDatabase = [
//   {
//     'jeevandNum': 'JN001',
//     'name': 'Rajesh Kumar',
//     'phone': '9876543210',
//     'email': 'rajesh@example.com',
//   },
//   {
//     'jeevandNum': 'JN002',
//     'name': 'Priya Singh',
//     'phone': '9876543211',
//     'email': 'priya@example.com',
//   },
//   {
//     'jeevandNum': 'JN003',
//     'name': 'Amit Patel',
//     'phone': '9876543212',
//     'email': 'amit@example.com',
//   },
//   {
//     'jeevandNum': 'JN004',
//     'name': 'Neha Gupta',
//     'phone': '9876543213',
//     'email': 'neha@example.com',
//   },
//   {
//     'jeevandNum': 'JN005',
//     'name': 'Vikram Reddy',
//     'phone': '9876543214',
//     'email': 'vikram@example.com',
//   },
// ];

// class AddVisit extends StatefulWidget {
//   const AddVisit({super.key});

//   @override
//   State<AddVisit> createState() => _AddVisitState();
// }

// class _AddVisitState extends State<AddVisit> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers
//   final _jeevandNumController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _visitPurposeController = TextEditingController();
//   final _commentsController = TextEditingController();
//   final _noOfGuestsController = TextEditingController();

//   // Track if member was found
//   bool _memberFound = false;

//   @override
//   void dispose() {
//     _jeevandNumController.dispose();
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _visitPurposeController.dispose();
//     _commentsController.dispose();
//     _noOfGuestsController.dispose();
//     super.dispose();
//   }

//   /// Search for member by Jeevandi Number
//   void _searchMember(String jeevandNum) {
//     if (jeevandNum.isEmpty) {
//       setState(() {
//         _memberFound = false;
//         _nameController.clear();
//         _phoneController.clear();
//         _emailController.clear();
//       });
//       return;
//     }

//     // Search in database
//     final member = memberDatabase.firstWhere(
//       (m) => m['jeevandNum'] == jeevandNum.toUpperCase(),
//       orElse: () => {},
//     );

//     if (member.isNotEmpty) {
//       setState(() {
//         _memberFound = true;
//         _nameController.text = member['name'] ?? '';
//         _phoneController.text = member['phone'] ?? '';
//         _emailController.text = member['email'] ?? '';
//       });
//     } else {
//       setState(() {
//         _memberFound = false;
//         _nameController.clear();
//         _phoneController.clear();
//         _emailController.clear();
//       });
//     }
//   }

//   /// Submit form
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       final newVisit = {
//         'jeevandNum': _jeevandNumController.text,
//         'name': _nameController.text,
//         'phone': _phoneController.text,
//         'email': _emailController.text,
//         'visitPurpose': _visitPurposeController.text,
//         'comments': _commentsController.text,
//         'noOfGuests': _noOfGuestsController.text,
//       };

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Visit added for ${_nameController.text}'),
//           duration: const Duration(seconds: 2),
//         ),
//       );

//       // Clear form
//       _formKey.currentState!.reset();
//       _jeevandNumController.clear();
//       _nameController.clear();
//       _phoneController.clear();
//       _emailController.clear();
//       _visitPurposeController.clear();
//       _commentsController.clear();
//       _noOfGuestsController.clear();
//       setState(() {
//         _memberFound = false;
//       });

//       print('New Visit: $newVisit');
//     }
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
//                   /// Header
//                   const Text(
//                     'Add Visit',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   /// Form
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         /// Jeevandi Number Search
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Jeevandi Number',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               TextFormField(
//                                 controller: _jeevandNumController,
//                                 decoration: InputDecoration(
//                                   hintText: 'Enter or search Jeevandi Number (e.g., JN001)',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   suffixIcon: _jeevandNumController.text
//                                           .isNotEmpty
//                                       ? IconButton(
//                                           icon: const Icon(Icons.close),
//                                           onPressed: () {
//                                             _jeevandNumController.clear();
//                                             _searchMember('');
//                                           },
//                                         )
//                                       : null,
//                                 ),
//                                 onChanged: (value) {
//                                   setState(() {});
//                                   if (value.isNotEmpty) {
//                                     _searchMember(value);
//                                   }
//                                 },
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter Jeevandi Number';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               if (!_memberFound &&
//                                   _jeevandNumController.text.isNotEmpty)
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8),
//                                   child: Text(
//                                     'Member not found. Please enter details manually.',
//                                     style: TextStyle(
//                                       color: Colors.orange,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ),
//                               if (_memberFound)
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8),
//                                   child: Text(
//                                     'Member found! Details auto-populated.',
//                                     style: TextStyle(
//                                       color: Colors.green,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),

//                         /// Name and Phone Row
//                         Row(
//                           children: [
//                             /// Name
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(right: 8, bottom: 16),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Name',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: _nameController,
//                                       decoration: InputDecoration(
//                                         hintText: 'Enter name',
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                       ),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter name';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             /// Phone
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 8, bottom: 16),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Phone',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: _phoneController,
//                                       decoration: InputDecoration(
//                                         hintText: 'Enter phone number',
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                       ),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter phone number';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         /// Email and Visit Purpose Row
//                         Row(
//                           children: [
//                             /// Email
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(right: 8, bottom: 16),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Email',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: _emailController,
//                                       decoration: InputDecoration(
//                                         hintText: 'Enter email address',
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                       ),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter email';
//                                         }
//                                         if (!value.contains('@')) {
//                                           return 'Please enter a valid email';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             /// Visit Purpose
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 8, bottom: 16),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Visit Purpose',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: _visitPurposeController,
//                                       decoration: InputDecoration(
//                                         hintText:
//                                             'e.g., General Visit, Donation, Volunteering, Event Participation',
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                       ),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter visit purpose';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         /// Comments and No. of Guests Row
//                         Row(
//                           children: [
//                             /// Comments
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(right: 8, bottom: 16),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Comments',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: _commentsController,
//                                       decoration: InputDecoration(
//                                         hintText:
//                                             'Enter any additional comments (optional)',
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                       ),
//                                       maxLines: 3,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             /// Number of Guests
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 8, bottom: 16),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Number of Guests',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: _noOfGuestsController,
//                                       decoration: InputDecoration(
//                                         hintText: 'Enter number of guests',
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                       ),
//                                       keyboardType: TextInputType.number,
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter number of guests';
//                                         }
//                                         if (int.tryParse(value) == null) {
//                                           return 'Please enter a valid number';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         /// Action Buttons
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             /// Cancel Button
//                             OutlinedButton.icon(
//                               onPressed: () {
//                                 Get.back();
//                               },
//                               icon: const Icon(Icons.close),
//                               label: const Text('Cancel'),
//                               style: OutlinedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 32,
//                                   vertical: 16,
//                                 ),
//                                 side: const BorderSide(
//                                   color: Colors.red,
//                                   width: 1.5,
//                                 ),
//                                 foregroundColor: Colors.red,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             /// Clear Button
//                             OutlinedButton.icon(
//                               onPressed: () {
//                                 _formKey.currentState!.reset();
//                                 _jeevandNumController.clear();
//                                 _nameController.clear();
//                                 _phoneController.clear();
//                                 _emailController.clear();
//                                 _visitPurposeController.clear();
//                                 _commentsController.clear();
//                                 _noOfGuestsController.clear();
//                                 setState(() {
//                                   _memberFound = false;
//                                 });
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Form cleared'),
//                                     duration: Duration(seconds: 1),
//                                   ),
//                                 );
//                               },
//                               icon: const Icon(Icons.refresh),
//                               label: const Text('Clear'),
//                               style: OutlinedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 32,
//                                   vertical: 16,
//                                 ),
//                                 side: const BorderSide(
//                                   color: Colors.orange,
//                                   width: 1.5,
//                                 ),
//                                 foregroundColor: Colors.orange,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             /// Save Button
//                             ElevatedButton.icon(
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   _submitForm();
//                                   Future.delayed(const Duration(seconds: 1), () {
//                                     Get.offNamed('/visits');
//                                   });
//                                 }
//                               },
//                               icon: const Icon(Icons.check_circle),
//                               label: const Text('Save Visit'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 32,
//                                   vertical: 16,
//                                 ),
//                                 elevation: 4,
//                                 shadowColor: Colors.green.withOpacity(0.5),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
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
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vikas_app/views/layouts/layout.dart';

// /// Sample member database (search by PHONE)
// List<Map<String, String>> memberDatabase = [
//   {
//     'phone': '9876543210',
//     'jeevandNum': 'JN001',
//     'name': 'Rajesh Kumar',
//     'email': 'rajesh@example.com',
//   },
//   {
//     'phone': '9876543211',
//     'jeevandNum': 'JN002',
//     'name': 'Priya Singh',
//     'email': 'priya@example.com',
//   },
//   {
//     'phone': '9876543212',
//     'jeevandNum': 'JN003',
//     'name': 'Amit Patel',
//     'email': 'amit@example.com',
//   },
// ];

// class AddVisit extends StatefulWidget {
//   const AddVisit({super.key});

//   @override
//   State<AddVisit> createState() => _AddVisitState();
// }

// class _AddVisitState extends State<AddVisit> {
//   final _formKey = GlobalKey<FormState>();

//   final _phoneController = TextEditingController();
//   final _jeevandNumController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _visitPurposeController = TextEditingController();
//   final _commentsController = TextEditingController();
//   final _noOfGuestsController = TextEditingController();

//   bool _memberFound = false;

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _jeevandNumController.dispose();
//     _nameController.dispose();
//     _emailController.dispose();
//     _visitPurposeController.dispose();
//     _commentsController.dispose();
//     _noOfGuestsController.dispose();
//     super.dispose();
//   }

//   /// 🔍 Search member by phone number
//   void _searchMemberByPhone(String phone) {
//     if (phone.isEmpty) {
//       setState(() {
//         _memberFound = false;
//         _jeevandNumController.clear();
//         _nameController.clear();
//         _emailController.clear();
//       });
//       return;
//     }

//     final member = memberDatabase.firstWhere(
//       (m) => m['phone'] == phone,
//       orElse: () => {},
//     );

//     if (member.isNotEmpty) {
//       setState(() {
//         _memberFound = true;
//         _jeevandNumController.text = member['jeevandNum'] ?? '';
//         _nameController.text = member['name'] ?? '';
//         _emailController.text = member['email'] ?? '';
//       });
//     } else {
//       setState(() {
//         _memberFound = false;
//         _jeevandNumController.clear();
//         _nameController.clear();
//         _emailController.clear();
//       });
//     }
//   }

//   /// ✅ Submit
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       final visitData = {
//         'phone': _phoneController.text,
//         'jeevandNum': _jeevandNumController.text,
//         'name': _nameController.text,
//         'email': _emailController.text,
//         'visitPurpose': _visitPurposeController.text,
//         'comments': _commentsController.text,
//         'noOfGuests': _noOfGuestsController.text,
//       };

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Visit added for ${_nameController.text}')),
//       );

//       _formKey.currentState!.reset();
//       _phoneController.clear();
//       _jeevandNumController.clear();
//       _nameController.clear();
//       _emailController.clear();
//       _visitPurposeController.clear();
//       _commentsController.clear();
//       _noOfGuestsController.clear();

//       setState(() => _memberFound = false);

//       debugPrint('Visit Data: $visitData');
//     }
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
//                   const Text(
//                     'Add Visit',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 24),

//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         /// PHONE NUMBER (SEARCH)
//                         _fieldLabel('Phone Number *'),
//                         TextFormField(
//                           controller: _phoneController,
//                           keyboardType: TextInputType.phone,
//                           decoration: _inputDecoration(
//                             'Enter phone number to search',
//                             clear: () {
//                               _phoneController.clear();
//                               _searchMemberByPhone('');
//                             },
//                             showClear: _phoneController.text.isNotEmpty,
//                           ),
//                           onChanged: (value) {
//                             setState(() {});
//                             if (value.length == 10) {
//                               _searchMemberByPhone(value);
//                             }
//                           },
//                           validator: (v) {
//                             if (v == null || v.isEmpty) {
//                               return 'Phone number is required';
//                             }
//                             if (v.length != 10) {
//                               return 'Enter valid 10 digit number';
//                             }
//                             return null;
//                           },
//                         ),

//                         if (_phoneController.text.isNotEmpty)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 6),
//                             child: Text(
//                               _memberFound
//                                   ? 'Member found! Details auto-filled.'
//                                   : 'Member not found. Please enter details.',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: _memberFound
//                                     ? Colors.green
//                                     : Colors.orange,
//                               ),
//                             ),
//                           ),

//                         const SizedBox(height: 16),

//                         /// JEEVANDI NUMBER (OPTIONAL)
//                         _fieldLabel('Jeevandi Number (Optional)'),
//                         TextFormField(
//                           controller: _jeevandNumController,
//                           decoration:
//                               _inputDecoration('Enter Jeevandi Number'),
//                         ),

//                         const SizedBox(height: 16),

//                         /// NAME
//                         _fieldLabel('Name *'),
//                         TextFormField(
//                           controller: _nameController,
//                           decoration: _inputDecoration('Enter name'),
//                           validator: (v) =>
//                               v == null || v.isEmpty ? 'Name required' : null,
//                         ),

//                         const SizedBox(height: 16),

//                         /// EMAIL
//                         _fieldLabel('Email *'),
//                         TextFormField(
//                           controller: _emailController,
//                           decoration: _inputDecoration('Enter email'),
//                           validator: (v) {
//                             if (v == null || v.isEmpty) {
//                               return 'Email required';
//                             }
//                             if (!v.contains('@')) {
//                               return 'Invalid email';
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 16),

//                         /// VISIT PURPOSE
//                         _fieldLabel('Visit Purpose *'),
//                         TextFormField(
//                           controller: _visitPurposeController,
//                           decoration:
//                               _inputDecoration('Enter visit purpose'),
//                           validator: (v) =>
//                               v == null || v.isEmpty ? 'Required' : null,
//                         ),

//                         const SizedBox(height: 16),

//                         /// COMMENTS
//                         _fieldLabel('Comments'),
//                         TextFormField(
//                           controller: _commentsController,
//                           maxLines: 3,
//                           decoration:
//                               _inputDecoration('Additional comments'),
//                         ),

//                         const SizedBox(height: 16),

//                         /// GUESTS
//                         _fieldLabel('Number of Guests *'),
//                         TextFormField(
//                           controller: _noOfGuestsController,
//                           keyboardType: TextInputType.number,
//                           decoration:
//                               _inputDecoration('Enter number of guests'),
//                           validator: (v) {
//                             if (v == null || v.isEmpty) {
//                               return 'Required';
//                             }
//                             if (int.tryParse(v) == null) {
//                               return 'Enter valid number';
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 30),

//                         /// BUTTONS
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             OutlinedButton(
//                               onPressed: () => Get.back(),
//                               child: const Text('Cancel'),
//                             ),
//                             const SizedBox(width: 16),
//                             ElevatedButton(
//                               onPressed: _submitForm,
//                               child: const Text('Save Visit'),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Helpers
//   Widget _fieldLabel(String text) => Padding(
//         padding: const EdgeInsets.only(bottom: 6),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             text,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//             ),
//           ),
//         ),
//       );

//   InputDecoration _inputDecoration(
//     String hint, {
//     bool showClear = false,
//     VoidCallback? clear,
//   }) {
//     return InputDecoration(
//       hintText: hint,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       suffixIcon: showClear
//           ? IconButton(
//               icon: const Icon(Icons.close),
//               onPressed: clear,
//             )
//           : null,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class AddVisit extends StatefulWidget {
  const AddVisit({super.key});

  @override
  State<AddVisit> createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _jeevandNumController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _visitPurposeController = TextEditingController();
  final _commentsController = TextEditingController();
  final _noOfGuestsController = TextEditingController();

  bool _memberFound = false;

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Visit',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    /// ROW 1
                    _twoFieldRow(
                      _phoneField(),
                      _jeevandiField(),
                    ),

                    if (_phoneController.text.isNotEmpty)
                      _memberStatus(),

                    const SizedBox(height: 16),

                    /// ROW 2
                    _twoFieldRow(
                      _nameField(),
                      _emailField(),
                    ),

                    const SizedBox(height: 16),

                    /// ROW 3
                    _twoFieldRow(
                      _visitPurposeField(),
                      _guestsField(),
                    ),

                    const SizedBox(height: 16),

                    /// COMMENTS (FULL WIDTH)
                    _fieldLabel('Comments'),
                    TextFormField(
                      controller: _commentsController,
                      maxLines: 3,
                      decoration:
                          _inputDecoration('Additional comments'),
                    ),

                    const SizedBox(height: 30),

                    /// ACTION BUTTONS
                    _actionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- ROW LAYOUT ----------------

  Widget _twoFieldRow(Widget left, Widget right) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  // ---------------- FIELDS ----------------

  Widget _phoneField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Phone Number *'),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration(
              'Search by phone number',
              icon: Icons.phone,
            ),
            onChanged: (value) {
              setState(() {});
              if (value.length == 10) _searchMemberByPhone(value);
            },
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'Phone number required';
              }
              if (v.length != 10) {
                return 'Enter valid 10 digit number';
              }
              return null;
            },
          ),
        ],
      );

  Widget _jeevandiField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Jeevandi Number'),
          TextFormField(
            controller: _jeevandNumController,
            decoration:
                _inputDecoration('Optional', icon: Icons.confirmation_number),
          ),
        ],
      );

  Widget _nameField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Name *'),
          TextFormField(
            controller: _nameController,
            decoration: _inputDecoration('Full name', icon: Icons.person),
            validator: (v) =>
                v == null || v.isEmpty ? 'Name is required' : null,
          ),
        ],
      );

  Widget _emailField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Email *'),
          TextFormField(
            controller: _emailController,
            decoration: _inputDecoration('Email address', icon: Icons.email),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email required';
              if (!v.contains('@')) return 'Invalid email';
              return null;
            },
          ),
        ],
      );

  Widget _visitPurposeField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Visit Purpose *'),
          TextFormField(
            controller: _visitPurposeController,
            decoration:
                _inputDecoration('Reason for visit', icon: Icons.flag),
            validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
          ),
        ],
      );

  Widget _guestsField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Number of Guests *'),
          TextFormField(
            controller: _noOfGuestsController,
            keyboardType: TextInputType.number,
            decoration:
                _inputDecoration('0', icon: Icons.group),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              if (int.tryParse(v) == null) return 'Invalid number';
              return null;
            },
          ),
        ],
      );

  // ---------------- MEMBER STATUS ----------------

  Widget _memberStatus() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _memberFound
              ? Colors.green.shade50
              : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              _memberFound ? Icons.check_circle : Icons.info,
              color: _memberFound ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _memberFound
                    ? 'Member found. Details auto-filled.'
                    : 'Member not found. Please fill details manually.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BUTTONS ----------------

  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.close),
          label: const Text('Cancel'),
          style: OutlinedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => Get.back(),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text('Save Visit'),
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _submitForm,
        ),
      ],
    );
  }

  // ---------------- HELPERS ----------------

  Widget _fieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );

  InputDecoration _inputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  // ---------------- LOGIC ----------------

  void _searchMemberByPhone(String phone) {
    setState(() => _memberFound = phone.length == 10);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Visit added successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}