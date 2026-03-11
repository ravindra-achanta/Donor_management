
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/visits/visit_bloc.dart';
import 'package:vikas_app/bloc_management/visits/visit_event.dart' as visit_event;
import 'package:vikas_app/bloc_management/visits/visit_state.dart';
import 'package:vikas_app/screeens/models/request/visit_model.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class AddVisit extends StatefulWidget {
  final VisitModel? visitData;
  const AddVisit({super.key, this.visitData});

  @override
  State<AddVisit> createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = {
    'phone': TextEditingController(),
    'name': TextEditingController(),
    'email': TextEditingController(),
    'purpose': TextEditingController(),
    'comments': TextEditingController(),
    'guests': TextEditingController(),
  };

  bool _existVisitor = false;
  String? _visitId;
  bool get _isEditMode => _visitId != null && _visitId!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _checkForData();
  }

  void _checkForData() {
    if (Get.arguments != null && Get.arguments is VisitModel) {
      _populateData(Get.arguments as VisitModel);
    } else if (widget.visitData != null) {
      _populateData(widget.visitData!);
    }
  }

  void _populateData(VisitModel data) {
    _visitId = data.id;
    _controllers['name']!.text = data.visitorName;
    _controllers['phone']!.text = data.phoneNumber;
    _controllers['email']!.text = data.email;
    _controllers['purpose']!.text = data.visitPurpose;
    _controllers['comments']!.text = data.comments;
    _controllers['guests']!.text = data.noOfGuests.toString();
    _existVisitor = data.existVisitor;
  }

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisitBloc, VisitState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          Get.snackbar(
            'Success',
            state.successMessage!,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Get.back(result: true);
              context.read<VisitBloc>().add(const visit_event.LoadVisits(page: 0));
            }
          });
        } else if (state.errorMessage != null) {
          Get.snackbar(
            'Error',
            state.errorMessage!,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Layout(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    ..._buildFields(),
                    const SizedBox(height: 30),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (_isEditMode ? Colors.orange : Colors.blue).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _isEditMode ? Icons.edit : Icons.person_add,
            color: _isEditMode ? Colors.orange : Colors.blue,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          _isEditMode ? 'Edit Visit' : 'Add New Visit',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  List<Widget> _buildFields() => [
    _buildField('Phone Number', Icons.phone, 'phone', isRequired: true, isPhone: true),
    const SizedBox(height: 16),
    _buildField('Visitor Name', Icons.person, 'name', isRequired: true),
    const SizedBox(height: 16),
    _buildField('Email', Icons.email, 'email', isRequired: true, isEmail: true),
    const SizedBox(height: 16),
    _buildField('Visit Purpose', Icons.flag, 'purpose', isRequired: true),
    const SizedBox(height: 16),
    _buildField('Number of Guests', Icons.group, 'guests', isRequired: true, isNumber: true),
    const SizedBox(height: 16),
    _buildVisitorToggle(),
    const SizedBox(height: 16),
    _buildField('Comments', Icons.comment, 'comments', maxLines: 3),
  ];

  Widget _buildField(String label, IconData icon, String key, {
    bool isRequired = false,
    bool isPhone = false,
    bool isEmail = false,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, required: isRequired),
        const SizedBox(height: 6),
        TextFormField(
          controller: _controllers[key],
          keyboardType: isPhone ? TextInputType.phone : isEmail ? TextInputType.emailAddress : isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          maxLength: isPhone ? 10 : null,
          buildCounter: isPhone ? (context, {required currentLength, required isFocused, maxLength}) => null : null,
          decoration: InputDecoration(
            hintText: 'Enter ${label.toLowerCase()}',
            prefixIcon: Icon(icon, color: Colors.grey.shade600),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (v) {
            if (isRequired && (v == null || v.isEmpty)) return '$label is required';
            if (isPhone && v != null && v.length != 10) return 'Phone number must be 10 digits';
            if (isPhone && v != null && !RegExp(r'^[0-9]+$').hasMatch(v)) return 'Enter valid phone number';
            if (isEmail && v != null && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Enter valid email';
            if (isNumber && v != null) {
              final num = int.tryParse(v);
              if (num == null) return 'Enter valid number';
              if (num < 0) return 'Number cannot be negative';
              if (num > 20) return 'Maximum 20 guests allowed';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildVisitorToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade50,
      ),
      child: Row(
        children: [
          Icon(_existVisitor ? Icons.check_circle : Icons.person_outline, 
               color: _existVisitor ? Colors.green : Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Existing Visitor', style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _existVisitor ? Colors.green.shade700 : Colors.grey.shade700,
                )),
                Text(_existVisitor ? 'Visitor has visited before' : 'New visitor',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Switch(value: _existVisitor, onChanged: (v) => setState(() => _existVisitor = v), activeColor: Colors.green),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {required bool required}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
        children: required ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.red))] : [],
      ),
    );
  }

  Widget _buildActionButtons() {
    return BlocBuilder<VisitBloc, VisitState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.close),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: state.isSubmitting ? null : () => Get.back(),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              icon: state.isSubmitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save),
              label: Text(state.isSubmitting ? 'Saving...' : 'Save Visit'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: _isEditMode ? Colors.orange : Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: state.isSubmitting ? null : _submitForm,
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<VisitBloc>().add(
        _isEditMode
            ? visit_event.UpdateVisit(VisitModel(
                id: _visitId!,
                visitorName: _controllers['name']!.text.trim(),
                phoneNumber: _controllers['phone']!.text.trim(),
                email: _controllers['email']!.text.trim(),
                visitPurpose: _controllers['purpose']!.text.trim(),
                comments: _controllers['comments']!.text.trim(),
                noOfGuests: int.parse(_controllers['guests']!.text.trim()),
                existVisitor: _existVisitor,
              ))
            : visit_event.AddVisit(VisitModel(
                id: '',
                visitorName: _controllers['name']!.text.trim(),
                phoneNumber: _controllers['phone']!.text.trim(),
                email: _controllers['email']!.text.trim(),
                visitPurpose: _controllers['purpose']!.text.trim(),
                comments: _controllers['comments']!.text.trim(),
                noOfGuests: int.parse(_controllers['guests']!.text.trim()),
                existVisitor: _existVisitor,
              )),
      );
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:vikas_app/bloc_management/visits/visit_bloc.dart';
// import 'package:vikas_app/bloc_management/visits/visit_event.dart' as visit_event;
// import 'package:vikas_app/bloc_management/visits/visit_state.dart';
// import 'package:vikas_app/screeens/models/request/visit_model.dart';
// import 'package:vikas_app/views/layouts/layout.dart';

// class AddVisit extends StatefulWidget {
//   final VisitModel? visitData;
  
//   const AddVisit({super.key, this.visitData});

//   @override
//   State<AddVisit> createState() => _AddVisitState();
// }

// class _AddVisitState extends State<AddVisit> {
//   final _formKey = GlobalKey<FormState>();
  
//   final _phoneController = TextEditingController();
//   final _visitorNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _visitPurposeController = TextEditingController();
//   final _commentsController = TextEditingController();
//   final _noOfGuestsController = TextEditingController();

//   bool _existVisitor = false;
//   String? _visitId;
  
//   bool get _isEditMode => _visitId != null && _visitId!.isNotEmpty;

//   @override
//   void initState() {
//     super.initState();
//     _checkForData();
//   }

//   void _checkForData() {
//     if (Get.arguments != null && Get.arguments is VisitModel) {
//       _populateData(Get.arguments as VisitModel);
//     } else if (widget.visitData != null) {
//       _populateData(widget.visitData!);
//     }
//   }

//   void _populateData(VisitModel visitData) {
//     _visitId = visitData.id;
//     _visitorNameController.text = visitData.visitorName;
//     _phoneController.text = visitData.phoneNumber;
//     _emailController.text = visitData.email;
//     _visitPurposeController.text = visitData.visitPurpose;
//     _commentsController.text = visitData.comments;
//     _noOfGuestsController.text = visitData.noOfGuests.toString();
//     _existVisitor = visitData.existVisitor;
//   }

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _visitorNameController.dispose();
//     _emailController.dispose();
//     _visitPurposeController.dispose();
//     _commentsController.dispose();
//     _noOfGuestsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<VisitBloc, VisitState>(
//       listener: (context, state) {
//         if (state.successMessage != null) {
//           _showSnackBar(message: state.successMessage!, isSuccess: true);
//           Future.delayed(const Duration(milliseconds: 500), () {
//             if (mounted) {
//               Get.back(result: true);
//               context.read<VisitBloc>().add(const visit_event.LoadVisits(page: 0));
//             }
//           });
//         } else if (state.errorMessage != null) {
//           _showSnackBar(message: 'Error: ${state.errorMessage}', isSuccess: false);
//         }
//       },
//       child: Layout(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Card(
//             elevation: 6,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildHeader(),
//                     const SizedBox(height: 24),
//                     _buildPhoneField(),
//                     const SizedBox(height: 16),
//                     _buildVisitorNameField(),
//                     const SizedBox(height: 16),
//                     _buildEmailField(),
//                     const SizedBox(height: 16),
//                     _buildVisitPurposeField(),
//                     const SizedBox(height: 16),
//                     _buildGuestsField(),
//                     const SizedBox(height: 16),
//                     _buildExistVisitorField(),
//                     const SizedBox(height: 16),
//                     _buildCommentsField(),
//                     const SizedBox(height: 30),
//                     _buildActionButtons(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: _isEditMode ? Colors.orange.shade50 : Colors.blue.shade50,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             _isEditMode ? Icons.edit : Icons.person_add,
//             color: _isEditMode ? Colors.orange : Colors.blue,
//             size: 24,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Text(
//           _isEditMode ? 'Edit Visit' : 'Add New Visit',
//           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   Widget _buildPhoneField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildLabel('Phone Number', required: true),
//         TextFormField(
//           controller: _phoneController,
//           keyboardType: TextInputType.phone,
//           decoration: _buildInputDecoration('Enter 10-digit phone number', Icons.phone),
//           maxLength: 10,
//           buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
//           validator: _validatePhone,
//         ),
//       ],
//     );
//   }

//   Widget _buildVisitorNameField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildLabel('Visitor Name', required: true),
//         TextFormField(
//           controller: _visitorNameController,
//           decoration: _buildInputDecoration('Enter visitor full name', Icons.person),
//           validator: (v) => v?.isEmpty ?? true ? 'Visitor name is required' : null,
//         ),
//       ],
//     );
//   }

//   Widget _buildEmailField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildLabel('Email', required: true),
//         TextFormField(
//           controller: _emailController,
//           keyboardType: TextInputType.emailAddress,
//           decoration: _buildInputDecoration('Enter email address', Icons.email),
//           validator: _validateEmail,
//         ),
//       ],
//     );
//   }

//   Widget _buildVisitPurposeField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildLabel('Visit Purpose', required: true),
//         TextFormField(
//           controller: _visitPurposeController,
//           decoration: _buildInputDecoration('Reason for visit', Icons.flag),
//           validator: (v) => v?.isEmpty ?? true ? 'Visit purpose is required' : null,
//         ),
//       ],
//     );
//   }

//   Widget _buildGuestsField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildLabel('Number of Guests', required: true),
//         TextFormField(
//           controller: _noOfGuestsController,
//           keyboardType: TextInputType.number,
//           decoration: _buildInputDecoration('Enter number of guests', Icons.group),
//           validator: _validateGuests,
//         ),
//       ],
//     );
//   }

//   Widget _buildExistVisitorField() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.grey.shade50,
//       ),
//       child: Row(
//         children: [
//           Icon(_existVisitor ? Icons.check_circle : Icons.person_outline, 
//                color: _existVisitor ? Colors.green : Colors.grey),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Existing Visitor',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: _existVisitor ? Colors.green.shade700 : Colors.grey.shade700,
//                   ),
//                 ),
//                 Text(
//                   _existVisitor ? 'Visitor has visited before' : 'New visitor',
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//           ),
//           Switch(
//             value: _existVisitor,
//             onChanged: (v) => setState(() => _existVisitor = v),
//             activeColor: Colors.green,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCommentsField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildLabel('Comments', required: false),
//         TextFormField(
//           controller: _commentsController,
//           maxLines: 3,
//           decoration: _buildInputDecoration('Additional comments (optional)', Icons.comment),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons() {
//     return BlocBuilder<VisitBloc, VisitState>(
//       builder: (context, state) {
//         final isSubmitting = state.isSubmitting;
        
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             OutlinedButton.icon(
//               icon: const Icon(Icons.close),
//               label: const Text('Cancel'),
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               onPressed: isSubmitting ? null : () => Get.back(),
//             ),
//             const SizedBox(width: 16),
//             ElevatedButton.icon(
//               icon: isSubmitting
//                   ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                   : const Icon(Icons.save),
//               label: Text(isSubmitting ? 'Saving...' : 'Save Visit'),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 backgroundColor: _isEditMode ? Colors.orange : Colors.blue,
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: isSubmitting ? null : _submitForm,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildLabel(String text, {required bool required}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6, left: 4),
//       child: RichText(
//         text: TextSpan(
//           text: text,
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
//           children: required ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.red))] : [],
//         ),
//       ),
//     );
//   }

//   InputDecoration _buildInputDecoration(String hint, IconData icon) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
//       prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 20),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//       focusedBorder: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//         borderSide: BorderSide(color: Colors.blue, width: 2),
//       ),
//       errorBorder: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//         borderSide: BorderSide(color: Colors.red),
//       ),
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//     );
//   }

//   String? _validatePhone(String? v) {
//     if (v == null || v.isEmpty) return 'Phone number is required';
//     if (v.length != 10) return 'Phone number must be 10 digits';
//     if (!RegExp(r'^[0-9]+$').hasMatch(v)) return 'Enter valid phone number';
//     return null;
//   }

//   String? _validateEmail(String? v) {
//     if (v == null || v.isEmpty) return 'Email is required';
//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Enter valid email';
//     return null;
//   }

//   String? _validateGuests(String? v) {
//     if (v == null || v.isEmpty) return 'Number of guests is required';
//     final guests = int.tryParse(v);
//     if (guests == null) return 'Enter valid number';
//     if (guests < 0) return 'Number of guests cannot be negative';
//     if (guests > 20) return 'Maximum 20 guests allowed';
//     return null;
//   }

//   void _showSnackBar({required String message, required bool isSuccess}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isSuccess ? Colors.green : Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       final visit = VisitModel(
//         id: _isEditMode ? _visitId! : '',
//         visitorName: _visitorNameController.text.trim(),
//         phoneNumber: _phoneController.text.trim(),
//         email: _emailController.text.trim(),
//         visitPurpose: _visitPurposeController.text.trim(),
//         comments: _commentsController.text.trim(),
//         noOfGuests: int.parse(_noOfGuestsController.text.trim()),
//         existVisitor: _existVisitor,
//       );

//       if (_isEditMode) {
//         context.read<VisitBloc>().add(visit_event.UpdateVisit(visit));
//       } else {
//         context.read<VisitBloc>().add(visit_event.AddVisit(visit));
//       }
//     }
//   }
// }

