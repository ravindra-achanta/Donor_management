import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vikas_app/bloc_management/Activity/activity_bloc.dart';
import 'package:vikas_app/bloc_management/Activity/activity_event.dart';
import 'package:vikas_app/bloc_management/Activity/activity_state.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
import 'package:vikas_app/screeens/common/referred_by_dropdown.dart';
import 'package:vikas_app/screeens/models/request/activity_request.dart%20%20%E2%9C%85%20Cractivity_request.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({super.key});

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jeevandiNoCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  final TextEditingController _otherCallStatusCtrl = TextEditingController();
  final TextEditingController _searchJeevanaadiCtrl = TextEditingController();

  String? _selectedCallStatus;
  DateTime? _selectedDate;
  bool _isOtherSelected = false;

  final List<String> _callStatusOptions = [
    "Profile Update",
    "Verification",
    "Follow-up",
    "Information Collection",
    "Other",
  ];

  @override
  void dispose() {
    _jeevandiNoCtrl.dispose();
    _descriptionCtrl.dispose();
    _otherCallStatusCtrl.dispose();
    _searchJeevanaadiCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    String finalCallStatus = _selectedCallStatus!;
    if (_isOtherSelected) {
      finalCallStatus = _otherCallStatusCtrl.text.trim();
      if (finalCallStatus.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter call status'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final request = ActivityRequest(
      jeevandiNo: int.parse(_jeevandiNoCtrl.text.trim()),
      callStatus: finalCallStatus,
      description: _descriptionCtrl.text.trim(),
      date: _selectedDate != null
          ? DateFormat(
              "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            ).format(_selectedDate!.toUtc())
          : DateTime.now().toUtc().toIso8601String(),
    );

    context.read<ActivityBloc>().add(CreateActivityEvent(request: request));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen for Jeevanaadi profile fetch (if needed – not required for this screen)
        BlocListener<JeevanaadiBloc, JeevanaadiState>(
          listener: (context, state) {
            // We don't need to auto-fill anything here; ReferredByDropdown handles search.
          },
        ),
        BlocListener<ActivityBloc, ActivityState>(
          listener: (context, state) {
            if (state.status == ActivityStatus.created) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.creationMessage ?? 'Activity created successfully',
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.toNamed('/activity-list');
              });
            }
            if (state.status == ActivityStatus.error &&
                state.isCreating == false) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Failed to create activity',
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        ),
      ],
      child: Layout(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Get.toNamed('/activity-list'),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Create Activity Log',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      //const Divider(thickness: 2),

                      // Jeevanaadi Member Search (ReferredByDropdown)
                      _buildJeevanaadiSearchField(),
                      const SizedBox(height: 16),

                      const SizedBox(height: 16),

                      // Call Status Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCallStatus,
                        decoration: InputDecoration(
                          labelText: 'Call Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        dropdownColor: Colors.white,
                        items: _callStatusOptions.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(
                              status,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCallStatus = value;
                            _isOtherSelected = value == "Other";
                            if (!_isOtherSelected) {
                              _otherCallStatusCtrl.clear();
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a call status';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Other Call Status (conditional)
                      if (_isOtherSelected)
                        Column(
                          children: [
                            TextFormField(
                              controller: _otherCallStatusCtrl,
                              decoration: InputDecoration(
                                labelText: 'Specify Call Status',
                                hintText: 'Enter custom call status',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              validator: (value) {
                                if (_isOtherSelected &&
                                    (value == null || value.isEmpty)) {
                                  return 'Please specify call status';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),

                      // Description
                      TextFormField(
                        controller: _descriptionCtrl,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date Picker
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'Select date'
                                    : DateFormat(
                                        'dd-MMM-yyyy',
                                      ).format(_selectedDate!),
                                style: TextStyle(
                                  color: _selectedDate == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              const Icon(Icons.calendar_today, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      BlocBuilder<ActivityBloc, ActivityState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: state.isCreating
                                    ? null
                                    : () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: state.isCreating
                                    ? null
                                    : () => _submit(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8D6E63),
                                  foregroundColor: Colors.white,
                                ),
                                child: state.isCreating
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Create Activity'),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Jeevanaadi search dropdown using ReferredByDropdown widget
  Widget _buildJeevanaadiSearchField() {
    return ReferredByDropdown(
      controller: _searchJeevanaadiCtrl,
      onSelected: (Map<String, dynamic>? value) {
        if (value == null) return;
        // When a member is selected from dropdown, auto-fill the number field
        if (value['isManual'] == true) {
          // Manual entry: user can type directly in the number field
          _jeevandiNoCtrl.text = '';
        } else {
          final jeevanaadiNo = value['jeevanaadiNo'] ?? value['id'];
          if (jeevanaadiNo != null && jeevanaadiNo.toString().isNotEmpty) {
            _jeevandiNoCtrl.text = jeevanaadiNo.toString();
          }
        }
      },
    );
  }
}
