import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:vikas_app/bloc_management/visits/visit_bloc.dart';
import 'package:vikas_app/bloc_management/visits/visit_event.dart'
    as visit_event;
import 'package:vikas_app/bloc_management/visits/visit_state.dart';

import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';

import 'package:vikas_app/screeens/common/referred_by_dropdown.dart';
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
    'jeevanaadiId': TextEditingController(),
    'jeevanaadiNo': TextEditingController(),
    'phone': TextEditingController(),
    'name': TextEditingController(),
    'email': TextEditingController(),
    'comments': TextEditingController(),
    'guests': TextEditingController(),
  };

  final _searchController = TextEditingController();

  bool _isExistingTab = true;
  bool _isUserSelected = false;
  bool _isFetchedUser = false;

  String? _selectedPurpose;

  /// ✅ EDIT MODE
  String? _visitId;
  bool get _isEditMode => _visitId != null && _visitId!.isNotEmpty;

  final List<String> _purposeOptions = [
    'Homam',
    'Attend Homam (In-Person)',
    'Annaprasana',
    'Auspicious Day',
    'First Time Visit',
    'Other',
  ];

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
    _controllers['comments']!.text = data.comments;
    _controllers['guests']!.text = data.noOfGuests.toString();

    _selectedPurpose = data.visitPurpose;

    if (data.jeevanaadiId != null && data.jeevanaadiId!.isNotEmpty) {
      _isExistingTab = true;
      _isUserSelected = true;

      _controllers['jeevanaadiId']!.text = data.jeevanaadiId!;

      _searchController.text = data.visitorName;
    } else {
      _isExistingTab = false;
      _isUserSelected = true;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// ✅ Autofill from Jeevanaadi
        BlocListener<JeevanaadiBloc, JeevanaadiState>(
          listener: (context, state) {
            if (state.jeevanaadiProfileFull != null) {
              final profile = state.jeevanaadiProfileFull!;

              setState(() {
                _controllers['jeevanaadiId']!.text = profile.basicDetails.id
                    .toString();

                _controllers['jeevanaadiNo']!.text =
                    profile.basicDetails.jeevanadiNo ?? '';

                _controllers['name']!.text = profile.profileDetails.fullName;

                _controllers['email']!.text = profile.basicDetails.email;

                _controllers['phone']!.text =
                    profile.profileDetails.phoneNumber ?? '';
                _isFetchedUser = true;
              });
            }
          },
        ),

        /// ✅ Submit response
        BlocListener<VisitBloc, VisitState>(
          listener: (context, state) {
            if (state.successMessage != null) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  Get.back(result: true);
                  context.read<VisitBloc>().add(
                    const visit_event.LoadVisits(page: 0),
                  );
                  Get.offNamed('/visits');
                }
              });
            } else if (state.errorMessage != null) {
              Get.snackbar(
                'Error',
                state.errorMessage!,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
        ),
      ],
      child: Layout(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          _isEditMode ? Icons.edit : Icons.add,
                          color: _isEditMode ? Colors.orange : Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _isEditMode ? "Edit Visit" : "Add Visit",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildTabSelector(),
                    const SizedBox(height: 20),

                    _isExistingTab ? _buildExistingTab() : _buildManualTab(),

                    const SizedBox(height: 16),

                    _buildPurposeField(),

                    const SizedBox(height: 16),

                    _buildField(
                      'Number of Guests',
                      Icons.group,
                      'guests',
                      isRequired: true,
                      isNumber: true,
                    ),

                    const SizedBox(height: 16),

                    _buildField(
                      'Comments',
                      Icons.comment,
                      'comments',
                      maxLines: 3,
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              _isEditMode ? "Update Visit" : "Save Visit",
                            ),
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
      ),
    );
  }

  /// TAB SWITCH
  Widget _buildTabSelector() {
    return Row(
      children: [
        Expanded(child: _tabItem("Existing Jeevanaadi", true)),
        Expanded(child: _tabItem("Manual Entry", false)),
      ],
    );
  }

  Widget _tabItem(String text, bool isExisting) {
    final isSelected = _isExistingTab == isExisting;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExistingTab = isExisting;

          if (!_isEditMode) {
            _isUserSelected = false;
            _searchController.clear();
            _controllers.forEach((k, v) => v.clear());
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: isSelected ? Colors.blue : Colors.grey.shade200,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// EXISTING TAB
  Widget _buildExistingTab() {
    return Column(
      children: [
        ReferredByDropdown(
          controller: _searchController,
          onSelected: (value) {
            if (value == null) return;

            setState(() => _isUserSelected = true);

            if (value['isManual'] == true) {
              setState(() {
                _controllers['name']!.text = value['userName'] ?? '';
                _controllers['email']!.clear();
                _controllers['phone']!.clear();
              });
              return;
            }

            context.read<JeevanaadiBloc>().add(
              FetchJeevanaadiProfileFullEvent(value['id'].toString()),
            );
          },
        ),

        const SizedBox(height: 10),

        if (_isUserSelected || _isEditMode) ...[
          _buildField(
            'Visitor Name',
            Icons.person,
            'name',
            readOnly: _isFetchedUser,
          ),
          const SizedBox(height: 16),
          _buildField('Email', Icons.email, 'email', readOnly: _isFetchedUser),
          const SizedBox(height: 16),
          _buildField(
            'Phone Number',
            Icons.phone,
            'phone',
            readOnly: _isFetchedUser,
          ),
        ],
      ],
    );
  }

  /// MANUAL TAB
  Widget _buildManualTab() {
    return Column(
      children: [
        _buildField('Visitor Name', Icons.person, 'name', isRequired: true),
        const SizedBox(height: 16),
        _buildField('Phone Number', Icons.phone, 'phone', isRequired: true),
        const SizedBox(height: 16),
        _buildField('Email', Icons.email, 'email', isRequired: true),
      ],
    );
  }

  Widget _buildField(
    String label,
    IconData icon,
    String key, {
    bool isRequired = false,
    bool isNumber = false,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: _controllers[key],
      readOnly: readOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (v) {
        if (readOnly) return null;
        if (isRequired && (v == null || v.isEmpty)) {
          return '$label required';
        }
        return null;
      },
    );
  }

  /// PURPOSE FIELD (FIXED)
  Widget _buildPurposeField() {
    return DropdownButtonFormField<String>(
      value: _selectedPurpose,
      isExpanded: true,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),

      decoration: InputDecoration(
        labelText: 'Purpose of Visit',
        prefixIcon: const Icon(Icons.category),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),

      items: _purposeOptions.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(e, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),

      onChanged: (value) {
        setState(() => _selectedPurpose = value);
      },

      validator: (value) => value == null ? "Purpose is required" : null,
    );
  }

  /// SUBMIT
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final visit = VisitModel(
        id: _isEditMode ? _visitId! : '',
        jeevanaadiId: _isExistingTab
            ? _controllers['jeevanaadiId']!.text
            : null,
        visitorName: _controllers['name']!.text,
        createdByName: '', // This will be set in the backend based on the logged-in user
        phoneNumber: _controllers['phone']!.text,
        email: _controllers['email']!.text,
        visitPurpose: _selectedPurpose ?? '',
        comments: _controllers['comments']!.text,
        noOfGuests: int.tryParse(_controllers['guests']!.text) ?? 0,
      );

      context.read<VisitBloc>().add(
        _isEditMode
            ? visit_event.UpdateVisit(visit)
            : visit_event.AddVisit(visit),
      );
    }
  }
}
