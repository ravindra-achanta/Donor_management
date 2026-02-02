// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vikas_app/features/karyakarthas/bloc/karyakartha_bloc.dart';
// import 'package:vikas_app/features/karyakarthas/bloc/karyakartha_event.dart';
// import 'package:vikas_app/features/karyakarthas/data/models/karyakartha.dart';
// import 'package:universal_html/js_util.dart';


// class KaryakarthaEditPage extends StatefulWidget {
//   final Karyakartha karyakartha;

//   const KaryakarthaEditPage({super.key, required this.karyakartha});

//   @override
//   State<KaryakarthaEditPage> createState() => _KaryakarthaEditPageState();
// }

// class _KaryakarthaEditPageState extends State<KaryakarthaEditPage> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _nameController;
//   late TextEditingController _mobileController;
//   late TextEditingController _emailController;
//   late TextEditingController _addressController;
//   late TextEditingController _dobController;
//   String _role = 'Karyakarta';
//   String _status = 'Active';

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.karyakartha.name);
//     _mobileController = TextEditingController(text: widget.karyakartha.mobile);
//     _emailController = TextEditingController(text: widget.karyakartha.email);
//     _addressController = TextEditingController(text: widget.karyakartha.address);
//     _dobController = TextEditingController(text: widget.karyakartha.dob);
//     _role = widget.karyakartha.role;
//     _status = widget.karyakartha.status;
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _addressController.dispose();
//     _dobController.dispose();
//     super.dispose();
//   }

//   void _saveChanges() {
//     if (_formKey.currentState!.validate()) {
//       final updated = widget.karyakartha.copyWith(
//         status: _status,
//       ).copyWith(
//         name: _nameController.text,
//         mobile: _mobileController.text,
//         email: _emailController.text,
//         address: _addressController.text,
//         dob: _dobController.text,
//         role: _role,
//       );

//       context.read<KaryakarthasBloc>().add(UpdateKaryakartha(updated));
//       Navigator.pop(context);
//     }
//   }

//   Future<void> _pickDate() async {
//     DateTime? date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.tryParse(_dobController.text) ?? DateTime(1990, 1, 1),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );

//     if (date != null) {
//       _dobController.text = "${date.year.toString().padLeft(4,'0')}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('UPDATE KARYAKARTA: ${widget.karyakartha.name.toUpperCase()}'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('[CLOSE]', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const Text('KARYAKARTA DETAILS', style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
              
//               // ID & Name
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       initialValue: widget.karyakartha.id,
//                       decoration: const InputDecoration(labelText: 'K-ID'),
//                       readOnly: true,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: TextFormField(
//                       controller: _nameController,
//                       decoration: const InputDecoration(labelText: 'FULL NAME'),
//                       validator: (v) => v!.isEmpty ? 'Required' : null,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Mobile & Email
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _mobileController,
//                       decoration: const InputDecoration(labelText: 'MOBILE NUMBER'),
//                       validator: (v) => v!.isEmpty ? 'Required' : null,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: TextFormField(
//                       controller: _emailController,
//                       decoration: const InputDecoration(labelText: 'EMAIL'),
//                       validator: (v) => v!.isEmpty ? 'Required' : null,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Role & DOB
//               Row(
//                 children: [
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       value: _role,
//                       items: const [
//                         DropdownMenuItem(value: 'Karyakarta', child: Text('Karyakarta')),
//                         DropdownMenuItem(value: 'Volunteer', child: Text('Volunteer')),
//                       ],
//                       onChanged: (v) => setState(() => _role = v!),
//                       decoration: const InputDecoration(labelText: 'ROLE'),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: TextFormField(
//                       controller: _dobController,
//                       decoration: const InputDecoration(labelText: 'DATE OF BIRTH'),
//                       readOnly: true,
//                       onTap: _pickDate,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Address
//               TextFormField(
//                 controller: _addressController,
//                 maxLines: 3,
//                 decoration: const InputDecoration(labelText: 'ADDRESS'),
//                 validator: (v) => v!.isEmpty ? 'Required' : null,
//               ),
//               const SizedBox(height: 16),

//               // Status
//               DropdownButtonFormField<String>(
//                 value: _status,
//                 items: const [
//                   DropdownMenuItem(value: 'Active', child: Text('Active')),
//                   DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
//                 ],
//                 onChanged: (v) => setState(() => _status = v!),
//                 decoration: const InputDecoration(labelText: 'STATUS'),
//               ),
//               const SizedBox(height: 32),

//               // Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _saveChanges,
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
//                       child: const Text('SAVE CHANGES'),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('CANCEL'),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
