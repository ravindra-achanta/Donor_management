
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
          // Get.snackbar(
          //   'Success',
          //   state.successMessage!,
          //   backgroundColor: Colors.green,
          //   colorText: Colors.white,
          //   snackPosition: SnackPosition.BOTTOM,
          // );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Get.back(result: true);
              context.read<VisitBloc>().add(const visit_event.LoadVisits(page: 0));
              Get.offNamed('/visits');
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

