import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/visits/visit_bloc.dart';
import 'package:vikas_app/bloc_management/visits/visit_event.dart';
import 'package:vikas_app/bloc_management/visits/visit_state.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/models/request/visit_model.dart';
import 'package:vikas_app/screeens/models/response/visit_view.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class EditVisit extends StatefulWidget {
  final dynamic visitData; // Change to dynamic to accept both types

  const EditVisit({super.key, this.visitData});

  @override
  State<EditVisit> createState() => _EditVisitState();
}

class _EditVisitState extends State<EditVisit> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _jeevandNumController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _visitPurposeController = TextEditingController();
  final _commentsController = TextEditingController();
  final _noOfGuestsController = TextEditingController();
  final _statusController = TextEditingController();

  bool _isSubmitting = false;
  bool _isLoading = true;
  late VisitModel visit;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    try {
      if (widget.visitData != null) {
        _convertToVisitModel(widget.visitData);
        setState(() => _isLoading = false);
        return;
      }
      
      final args = Get.arguments;
      if (args != null) {
        _convertToVisitModel(args);
        setState(() => _isLoading = false);
        return;
      }
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No visit data found'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Get.back();
      });
    } catch (e) {
      debugPrint('Error initializing EditVisit: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.back();
      });
    }
  }

  void _convertToVisitModel(dynamic data) {
    if (data is VisitModel) {
      visit = data;
    } else if (data is VisitView) {
      visit = VisitModel(
        id: data.id,
        jeevandNum: data.jeevandNum,
        name: data.name,
        phone: data.phone,
        email: data.email,
        visitPurpose: data.visitPurpose,
        noOfGuests: data.noOfGuests,
        comments: '', 
        date: data.date,
        status: data.status,
      );
    } else if (data is Map) {
      visit = VisitModel.fromJson(data as Map<String, dynamic>);
    } else {
      throw Exception('Unsupported data type: ${data.runtimeType}');
    }
    
    _populateFields();
  }

  void _populateFields() {
    _jeevandNumController.text = visit.jeevandNum;
    _nameController.text = visit.name;
    _phoneController.text = visit.phone;
    _emailController.text = visit.email;
    _visitPurposeController.text = visit.visitPurpose;
    _noOfGuestsController.text = visit.noOfGuests.toString();
    _commentsController.text = visit.comments;
    _statusController.text = visit.status;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _jeevandNumController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _visitPurposeController.dispose();
    _commentsController.dispose();
    _noOfGuestsController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Scheduled':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return  Layout(
        child: Center(child: ScreenLoader()),
      );
    }

    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<VisitBloc, VisitState>(
          listener: (context, state) {
            if (state is VisitOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  Get.back();
                }
              });
            } else if (state is VisitError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
              setState(() => _isSubmitting = false);
            }
          },
          builder: (context, state) {
            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.orange.shade700,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Edit Visit',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Update the visit details for ${visit.name}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Status Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('Status'),
                            DropdownButtonFormField<String>(
                              value: _statusController.text.isNotEmpty ? _statusController.text : 'Scheduled',
                              decoration: _inputDecoration('Select status', icon: Icons.info),
                              items: ['Scheduled', 'Pending', 'Completed', 'Cancelled']
                                  .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(status),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(status),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _statusController.text = value);
                                }
                              },
                              validator: (v) => v == null || v.isEmpty ? 'Status is required' : null,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Row 1: Phone and Jeevandi Number
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _fieldLabel('Phone Number *'),
                                  TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: _inputDecoration('Phone number', icon: Icons.phone),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Phone number required';
                                      if (v.length != 10) return 'Enter valid 10 digit number';
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _fieldLabel('Jeevandi Number'),
                                  TextFormField(
                                    controller: _jeevandNumController,
                                    decoration: _inputDecoration('Jeevandi number', icon: Icons.confirmation_number),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Row 2: Name and Email
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _fieldLabel('Name *'),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: _inputDecoration('Full name', icon: Icons.person),
                                    validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
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
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Row 3: Visit Purpose and Guests
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _fieldLabel('Visit Purpose *'),
                                  TextFormField(
                                    controller: _visitPurposeController,
                                    decoration: _inputDecoration('Reason for visit', icon: Icons.flag),
                                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _fieldLabel('Number of Guests *'),
                                  TextFormField(
                                    controller: _noOfGuestsController,
                                    keyboardType: TextInputType.number,
                                    decoration: _inputDecoration('Number of guests', icon: Icons.group),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Required';
                                      if (int.tryParse(v) == null) return 'Invalid number';
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Comments
                        _fieldLabel('Comments'),
                        TextFormField(
                          controller: _commentsController,
                          maxLines: 3,
                          decoration: _inputDecoration('Additional comments'),
                        ),

                        const SizedBox(height: 30),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.close),
                              label: const Text('Cancel'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                  : const Icon(Icons.update),
                              label: Text(_isSubmitting ? 'Updating...' : 'Update Visit'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Colors.orange,
                              ),
                              onPressed: _isSubmitting ? null : _submitForm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final updatedVisit = VisitModel(
        id: visit.id,
        jeevandNum: _jeevandNumController.text,
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        visitPurpose: _visitPurposeController.text,
        noOfGuests: int.parse(_noOfGuestsController.text),
        comments: _commentsController.text,
        date: visit.date,
        status: _statusController.text,
      );

      context.read<VisitBloc>().add(UpdateVisit(updatedVisit));
    }
  }
}