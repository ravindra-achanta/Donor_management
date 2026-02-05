// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vikas_app/views/layouts/layout.dart';

// class AddDharmasetu extends StatefulWidget {
//   const AddDharmasetu({super.key});

//   @override
//   State<AddDharmasetu> createState() => _AddDharmaSetuState();
// }

// class _AddDharmaSetuState extends State<AddDharmasetu> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers
//   final _uidController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _feedbackController = TextEditingController();
//   final _dateController = TextEditingController();
//   final _referredByController = TextEditingController();

//   // Dropdown values
//   String? _selectedType;
//   String? _selectedStatus;

//   final List<String> dharmaTypes = ['Community', 'Home', 'Virtual'];
//   final List<String> statuses = ['Active', 'Pending', 'Completed'];

//   @override
//   void dispose() {
//     _uidController.dispose();
//     _nameController.dispose();
//     _feedbackController.dispose();
//     _dateController.dispose();
//     _referredByController.dispose();
//     super.dispose();
//   }

//   /// Submit form
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       final newDharmasetu = {
//         'uid': _uidController.text,
//         'type': _selectedType,
//         'name': _nameController.text,
//         'feedback': _feedbackController.text,
//         'date': _dateController.text,
//         'referredBy': _referredByController.text,
//         'status': _selectedStatus,
//       };

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Dharmasetu added for ${_nameController.text}'),
//           duration: const Duration(seconds: 2),
//         ),
//       );

//       // Clear form
//       _formKey.currentState!.reset();
//       _uidController.clear();
//       _nameController.clear();
//       _feedbackController.clear();
//       _dateController.clear();
//       _referredByController.clear();
//       setState(() {
//         _selectedType = null;
//         _selectedStatus = null;
//       });

//       print('New Dharmasetu: $newDharmasetu');
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
//                     'Add Dharmasetu',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 24),

//                   /// Form
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         /// UID and Type Row
//                         Row(
//                           children: [
//                             /// UID
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   right: 8,
//                                   bottom: 16,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Dharmasetu UID',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: _uidController,
//                                       decoration: InputDecoration(
//                                         hintText: 'e.g., DM001',
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             8,
//                                           ),
//                                         ),
//                                       ),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter UID';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                             /// Type
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   left: 8,
//                                   bottom: 16,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Type',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     DropdownButtonFormField<String>(
//                                       value: _selectedType,
//                                       decoration: InputDecoration(
//                                         filled: true,
//                                         fillColor:
//                                             Colors.white, // ✅ white background
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             8,
//                                           ),
//                                         ),
//                                         contentPadding:
//                                             const EdgeInsets.symmetric(
//                                               horizontal: 12,
//                                               vertical: 14,
//                                             ),
//                                       ),
//                                       dropdownColor:
//                                           Colors.white, // ✅ dropdown menu bg
//                                       items: dharmaTypes.map((type) {
//                                         return DropdownMenuItem(
//                                           value: type,
//                                           child: Text(type),
//                                         );
//                                       }).toList(),
//                                       onChanged: (value) {
//                                         setState(() {
//                                           _selectedType = value;
//                                         });
//                                       },
//                                       validator: (value) {
//                                         if (value == null) {
//                                           return 'Please select type';
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

//                         /// Name and Referred By Row
//                         Row(
//                           children: [
//                             /// Name
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   right: 8,
//                                   bottom: 16,
//                                 ),
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
//                                         hintText: 'Enter dharmasetu name',
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             8,
//                                           ),
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

//                             /// Referred By
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   left: 8,
//                                   bottom: 16,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Referred By',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: _referredByController,
//                                       decoration: InputDecoration(
//                                         hintText: 'Enter member name',
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             8,
//                                           ),
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
//                           ],
//                         ),

//                         /// Date and Status Row
//                         Row(
//                           children: [
//                             /// Date
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   right: 8,
//                                   bottom: 16,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Date',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: _dateController,
//                                       decoration: InputDecoration(
//                                         hintText: 'YYYY-MM-DD',
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             8,
//                                           ),
//                                         ),
//                                         suffixIcon: const Icon(
//                                           Icons.calendar_today,
//                                         ),
//                                       ),
//                                       onTap: () async {
//                                         FocusScope.of(
//                                           context,
//                                         ).requestFocus(FocusNode());
//                                         final date = await showDatePicker(
//                                           context: context,
//                                           initialDate: DateTime.now(),
//                                           firstDate: DateTime(2020),
//                                           lastDate: DateTime.now(),
//                                         );
//                                         if (date != null) {
//                                           _dateController.text = date
//                                               .toString()
//                                               .split(' ')[0];
//                                         }
//                                       },
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter date';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                             /// Status
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   left: 8,
//                                   bottom: 16,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Status',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     // DropdownButtonFormField<String>(
//                                     //   value: _selectedStatus,
//                                     //   decoration: InputDecoration(
//                                     //     border: OutlineInputBorder(
//                                     //       borderRadius: BorderRadius.circular(
//                                     //         8,
//                                     //       ),
//                                     //     ),
//                                     //   ),
//                                     //   items: statuses.map((status) {
//                                     //     return DropdownMenuItem(
//                                     //       value: status,
//                                     //       child: Text(status),
//                                     //     );
//                                     //   }).toList(),
//                                     //   onChanged: (value) {
//                                     //     setState(() {
//                                     //       _selectedStatus = value;
//                                     //     });
//                                     //   },
//                                     //   validator: (value) {
//                                     //     if (value == null) {
//                                     //       return 'Please select status';
//                                     //     }
//                                     //     return null;
//                                     //   },
//                                     // ),
//                                     DropdownButtonFormField<String>(
//   value: _selectedStatus,
//   decoration: InputDecoration(
//     filled: true,
//     fillColor: Colors.white, // ✅ white background
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//     ),
//     contentPadding: const EdgeInsets.symmetric(
//       horizontal: 12,
//       vertical: 14,
//     ),
//   ),
//   dropdownColor: Colors.white, // ✅ dropdown menu bg
//   items: statuses.map((status) {
//     return DropdownMenuItem(
//       value: status,
//       child: Text(status),
//     );
//   }).toList(),
//   onChanged: (value) {
//     setState(() {
//       _selectedStatus = value;
//     });
//   },
//   validator: (value) {
//     if (value == null) {
//       return 'Please select status';
//     }
//     return null;
//   },
// ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         /// Feedback
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 24),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Feedback',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               TextFormField(
//                                 controller: _feedbackController,
//                                 decoration: InputDecoration(
//                                   hintText: 'Enter feedback (optional)',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 maxLines: 3,
//                               ),
//                             ],
//                           ),
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
//                                 _uidController.clear();
//                                 _nameController.clear();
//                                 _feedbackController.clear();
//                                 _dateController.clear();
//                                 _referredByController.clear();
//                                 setState(() {
//                                   _selectedType = null;
//                                   _selectedStatus = null;
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
//                                   Future.delayed(
//                                     const Duration(seconds: 1),
//                                     () {
//                                       Get.offNamed('/dharmasetu');
//                                     },
//                                   );
//                                 }
//                               },
//                               icon: const Icon(Icons.check_circle),
//                               label: const Text('Save Dharmasetu'),
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class AddDharmasetu extends StatefulWidget {
  const AddDharmasetu({super.key});

  @override
  State<AddDharmasetu> createState() => _AddDharmaSetuState();
}

class _AddDharmaSetuState extends State<AddDharmasetu> {
  final _formKey = GlobalKey<FormState>();

  final _uidController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _feedbackController = TextEditingController();
  final _dateController = TextEditingController();
  final _referredByController = TextEditingController();

  final _communityNameController = TextEditingController();
  final _communityLocationController = TextEditingController();
  final _communityOwnerController = TextEditingController();

  final _homeOwnerController = TextEditingController();
  final _homeAddressController = TextEditingController();

  final _virtualLinkController = TextEditingController();

  String? _selectedType;
  String? _selectedStatus;

  final List<String> dharmaTypes = ['Community', 'Home', 'Virtual'];
  final List<String> statuses = ['Active', 'Pending', 'Completed'];

  // ---------------- SUBMIT ----------------

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dharmasetu added for ${_nameController.text}'),
        ),
      );
      Get.offNamed('/dharmasetu');
    }
  }

  // ---------------- BUILD ----------------

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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Dharmasetu',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    _twoFieldRow(
                      _textField('Dharmasetu UID', _uidController, required: true),
                      _typeDropdown(),
                    ),

                    _twoFieldRow(
                      _textField(
                        'Phone Number',
                        _phoneController,
                        required: true,
                        keyboard: TextInputType.phone,
                      ),
                      _textField('Name', _nameController, required: true),
                    ),

                    _twoFieldRow(
                      _textField(
                        'Referred By',
                        _referredByController,
                        required: true,
                      ),
                      _dateField(),
                    ),

                    _twoFieldRow(
                      _statusDropdown(),
                      const SizedBox(),
                    ),

                    if (_selectedType == 'Community') _communityFields(),
                    if (_selectedType == 'Home') _homeFields(),
                    if (_selectedType == 'Virtual') _virtualFields(),

                    const SizedBox(height: 16),

                    _textField(
                      'Feedback',
                      _feedbackController,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 30),

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

  // ---------------- TYPE SECTIONS ----------------

  Widget _communityFields() => Column(
        children: [
          const SizedBox(height: 16),
          _twoFieldRow(
            _textField(
              'Community Name',
              _communityNameController,
              required: true,
            ),
            _textField(
              'Location',
              _communityLocationController,
              required: true,
            ),
          ),
          _twoFieldRow(
            _textField(
              'Owner',
              _communityOwnerController,
              required: true,
            ),
            const SizedBox(),
          ),
        ],
      );

  Widget _homeFields() => Column(
        children: [
          const SizedBox(height: 16),
          _twoFieldRow(
            _textField(
              'Owner Name',
              _homeOwnerController,
              required: true,
            ),
            _textField(
              'Address',
              _homeAddressController,
              required: true,
            ),
          ),
        ],
      );

  Widget _virtualFields() => Column(
        children: [
          const SizedBox(height: 16),
          _twoFieldRow(
            _textField(
              'Virtual Link',
              _virtualLinkController,
              required: true,
            ),
            const SizedBox(),
          ),
        ],
      );

  // ---------------- HELPERS ----------------

  Widget _twoFieldRow(Widget left, Widget right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: 16),
          Expanded(child: right),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white, // 👈 makes dropdown visible
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    bool required = false,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: _inputDecoration(required ? '$label *' : label),
      validator: required
          ? (v) =>
              v == null || v.trim().isEmpty ? 'Please enter $label' : null
          : null,
    );
  }

  Widget _typeDropdown() => DropdownButtonFormField<String>(
        value: _selectedType,
        decoration: _inputDecoration('Type *'),
        dropdownColor: Colors.white,
        items: dharmaTypes
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => setState(() => _selectedType = v),
        validator: (v) => v == null ? 'Please select Type' : null,
      );

  Widget _statusDropdown() => DropdownButtonFormField<String>(
        value: _selectedStatus,
        decoration: _inputDecoration('Status *'),
        dropdownColor: Colors.white,
        items: statuses
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => setState(() => _selectedStatus = v),
        validator: (v) => v == null ? 'Please select Status' : null,
      );

  Widget _dateField() => _textField(
        'Date',
        _dateController,
        required: true,
      );

  Widget _actionButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
            label: const Text('Cancel'),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _submitForm,
            icon: const Icon(Icons.check_circle),
            label: const Text('Save Dharmasetu'),
          ),
        ],
      );
}