import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/visits/visit_bloc.dart';
import 'package:vikas_app/bloc_management/visits/visit_event.dart';
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

  final _phoneController = TextEditingController();
  final _jeevandNumController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _visitPurposeController = TextEditingController();
  final _commentsController = TextEditingController();
  final _noOfGuestsController = TextEditingController();

  bool _memberFound = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _jeevandNumController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _visitPurposeController.dispose();
    _commentsController.dispose();
    _noOfGuestsController.dispose();
    super.dispose();
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
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
                      'Add Visit',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// ROW 1
                    _twoFieldRow(_phoneField(), _jeevandiField()),

                    if (_phoneController.text.isNotEmpty) _memberStatus(),

                    const SizedBox(height: 16),

                    /// ROW 2
                    _twoFieldRow(_nameField(), _emailField()),

                    const SizedBox(height: 16),

                    /// ROW 3
                    _twoFieldRow(_visitPurposeField(), _guestsField()),

                    const SizedBox(height: 16),

                    _fieldLabel('Comments'),
                    TextFormField(
                      controller: _commentsController,
                      maxLines: 3,
                      decoration: _inputDecoration('Additional comments'),
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
        decoration: _inputDecoration(
          'Optional',
          icon: Icons.confirmation_number,
        ),
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
        validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
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
        decoration: _inputDecoration('Reason for visit', icon: Icons.flag),
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
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
        decoration: _inputDecoration('0', icon: Icons.group),
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
          color: _memberFound ? Colors.green.shade50 : Colors.orange.shade50,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _isSubmitting ? null : () => Get.back(),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          icon: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.save),
          label: Text(_isSubmitting ? 'Saving...' : 'Save Visit'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _isSubmitting ? null : _submitForm,
        ),
      ],
    );
  }

  // ---------------- HELPERS ----------------

  Widget _fieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
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
      setState(() => _isSubmitting = true);

      final newVisit = VisitModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        jeevandNum: _jeevandNumController.text,
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        visitPurpose: _visitPurposeController.text,
        noOfGuests: int.parse(_noOfGuestsController.text),
        comments: _commentsController.text,
        date: DateTime.now().toString().split(' ')[0], // YYYY-MM-DD
        status: 'Scheduled',
      );

      // context.read<VisitBloc>().add(AddVisit(newVisit));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Visit added successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Get.back();
        }
      });
    }
  }
}
