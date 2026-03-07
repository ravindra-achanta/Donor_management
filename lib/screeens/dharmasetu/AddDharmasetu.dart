import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_bloc.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_event.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_state.dart';
import 'package:vikas_app/screeens/models/request/dharmasetu_model.dart';
import 'package:vikas_app/views/layouts/layout.dart';

// Define the enums here or import from a separate file
enum DharmasetuType {
  COMMUNITY,
  HOME,
  ONLINE
}

enum DharmasetuStatus {
  WIP,
  CANCELLED,
  COMPLETED
}

class AddDharmasetu extends StatefulWidget {
  final DharmasetuModel? dharmasetu;

  const AddDharmasetu({
    super.key,
    this.dharmasetu,
  });

  @override
  State<AddDharmasetu> createState() => _AddDharmaSetuState();
}

class _AddDharmaSetuState extends State<AddDharmasetu> {
  final _formKey = GlobalKey<FormState>();

  // Common fields matching DharmasetuModel
  final _communityNameController = TextEditingController();
  final _pointOfContactController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _meetingLinkController = TextEditingController();
  final _feedbackController = TextEditingController();
  final _dateController = TextEditingController();
  final _referredByController = TextEditingController();

  DharmasetuType? _selectedType;
  DharmasetuStatus? _selectedStatus;

  bool _isSubmitting = false;

  // Helper method to convert string to enum
  DharmasetuType? _getTypeFromString(String? type) {
    if (type == null) return null;
    try {
      return DharmasetuType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => DharmasetuType.COMMUNITY,
      );
    } catch (e) {
      return DharmasetuType.COMMUNITY;
    }
  }

  DharmasetuStatus? _getStatusFromString(String? status) {
    if (status == null) return null;
    try {
      return DharmasetuStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => DharmasetuStatus.WIP,
      );
    } catch (e) {
      return DharmasetuStatus.WIP;
    }
  }

  @override
  void initState() {
    super.initState();
    
    if (widget.dharmasetu != null) {
      // Populate form for update
      final d = widget.dharmasetu!;
      
      // Set type
      _selectedType = _getTypeFromString(d.type);
      
      // Set status
      _selectedStatus = _getStatusFromString(d.dharmasetuStatus);
      
      // Populate all fields
      _communityNameController.text = d.communityName ?? '';
      _pointOfContactController.text = d.pointOfContact ?? '';
      _addressController.text = d.address ?? '';
      _cityController.text = d.city ?? '';
      _stateController.text = d.state ?? '';
      _countryController.text = d.country ?? '';
      _pincodeController.text = d.pincode ?? '';
      _meetingLinkController.text = d.meetingLink ?? '';
      _feedbackController.text = d.feedback ?? '';
      _dateController.text = d.date ?? '';
      _referredByController.text = d.referredBy ?? '';
    } else {
      // Set default values for new entry
      _selectedType = DharmasetuType.COMMUNITY;
      _selectedStatus = DharmasetuStatus.WIP;
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _communityNameController.dispose();
    _pointOfContactController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    _meetingLinkController.dispose();
    _feedbackController.dispose();
    _dateController.dispose();
    _referredByController.dispose();
    super.dispose();
  }

  // ---------------- SUBMIT ----------------
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Create the model with all fields
      final dharmasetu = DharmasetuModel(
        id: widget.dharmasetu?.id ?? '', // Keep existing ID for update
        dharmasetuId: widget.dharmasetu?.dharmasetuId ?? '', // Keep existing ID for update
        type: _selectedType!.name,
        communityName: _communityNameController.text.isNotEmpty 
            ? _communityNameController.text.trim() 
            : null,
        pointOfContact: _pointOfContactController.text.isNotEmpty 
            ? _pointOfContactController.text.trim() 
            : null,
        address: _addressController.text.isNotEmpty 
            ? _addressController.text.trim() 
            : null,
        city: _cityController.text.isNotEmpty 
            ? _cityController.text.trim() 
            : null,
        state: _stateController.text.isNotEmpty 
            ? _stateController.text.trim() 
            : null,
        country: _countryController.text.isNotEmpty 
            ? _countryController.text.trim() 
            : null,
        pincode: _pincodeController.text.isNotEmpty 
            ? _pincodeController.text.trim() 
            : null,
        meetingLink: _meetingLinkController.text.isNotEmpty 
            ? _meetingLinkController.text.trim() 
            : null,
        feedback: _feedbackController.text.trim(),
        date: _dateController.text.trim(),
        referredBy: _referredByController.text.trim(),
        dharmasetuStatus: _selectedStatus!.name,
      );

      print('Submitting Dharmasetu: ${dharmasetu.toJson()}');
      
      if (widget.dharmasetu != null) {
        // Update existing
        context.read<DharmasetuBloc>().add(UpdateDharmasetuEvent(dharmasetu));
      } else {
        // Add new
        context.read<DharmasetuBloc>().add(AddDharmasetuEvent(dharmasetu));
      }
    }
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.dharmasetu != null;
    
    return BlocListener<DharmasetuBloc, DharmasetuState>(
      listener: (context, state) {
        setState(() => _isSubmitting = state.isSubmitting);

        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
          Get.offNamed('/dharmasetu');
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isSubmitting = false);
        }
      },
      child: Layout(
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
                      Text(
                        isUpdate ? 'Update Dharmasetu' : 'Add Dharmasetu',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isUpdate) ...[
                        const SizedBox(height: 8),
                        Text(
                          'ID: ${widget.dharmasetu?.dharmasetuId ?? widget.dharmasetu?.id}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Type Selection
                      _typeDropdown(isUpdate),
                      const SizedBox(height: 24),

                      // Dynamic fields based on type
                      _buildTypeSpecificFields(),

                      const SizedBox(height: 24),

                      // Common fields for all types
                      const Text(
                        'Common Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date and Referred By
                      _twoFieldRow(
                        _dateField(),
                        _textField(
                          'Referred By',
                          _referredByController,
                          required: true,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Feedback field (full width)
                      _textField(
                        'Feedback', 
                        _feedbackController, 
                        maxLines: 3,
                        required: true,
                      ),

                      const SizedBox(height: 16),

                      // Status Selection
                      _statusDropdown(),

                      const SizedBox(height: 30),

                      // Action buttons
                      _actionButtons(isUpdate),
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

  // Build fields based on selected type
  Widget _buildTypeSpecificFields() {
    if (_selectedType == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_getTypeTitle()} Details',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        if (_selectedType == DharmasetuType.COMMUNITY) ...[
          // COMMUNITY fields
          _textField(
            'Community Name',
            _communityNameController,
            required: true,
          ),
          const SizedBox(height: 16),
          _textField(
            'Point of Contact',
            _pointOfContactController,
            required: true,
            keyboard: TextInputType.phone,
          ),
        ] else if (_selectedType == DharmasetuType.HOME) ...[
          // HOME fields with Point of Contact
          _twoFieldRow(
            _textField(
              'Address',
              _addressController,
              required: true,
              maxLines: 2,
            ),
            _textField(
              'Point of Contact',
              _pointOfContactController,
              required: true,
              keyboard: TextInputType.phone,
            ),
          ),
          const SizedBox(height: 16),
          _twoFieldRow(
            _textField(
              'City',
              _cityController,
              required: true,
            ),
            _textField(
              'State',
              _stateController,
              required: true,
            ),
          ),
          const SizedBox(height: 16),
          _twoFieldRow(
            _textField(
              'Country',
              _countryController,
              required: true,
            ),
            _textField(
              'Pincode',
              _pincodeController,
              required: true,
              keyboard: TextInputType.number,
            ),
          ),
        ] else if (_selectedType == DharmasetuType.ONLINE) ...[
          // ONLINE fields
          _textField(
            'Meeting Link',
            _meetingLinkController,
            required: true,
            keyboard: TextInputType.url,
          ),
        ],
      ],
    );
  }

  String _getTypeTitle() {
    switch (_selectedType) {
      case DharmasetuType.COMMUNITY:
        return 'Community';
      case DharmasetuType.HOME:
        return 'Home';
      case DharmasetuType.ONLINE:
        return 'Online';
      default:
        return '';
    }
  }

  // ---------------- HELPERS ----------------
  Widget _twoFieldRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, {bool required = false}) {
    return InputDecoration(
      labelText: required ? '$label *' : label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    bool required = false,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        enabled: !_isSubmitting,
        decoration: _inputDecoration(label, required: required),
        validator: required
            ? (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _typeDropdown(bool isUpdate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Type *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: DharmasetuType.values.map((type) {
            return ChoiceChip(
              label: Text(type.name),
              selected: _selectedType == type,
              onSelected: _isSubmitting || isUpdate
                  ? null // Disable type change during update
                  : (selected) {
                      setState(() {
                        _selectedType = type;
                        // Clear type-specific fields when type changes
                        _communityNameController.clear();
                        _pointOfContactController.clear();
                        _addressController.clear();
                        _cityController.clear();
                        _stateController.clear();
                        _countryController.clear();
                        _pincodeController.clear();
                        _meetingLinkController.clear();
                      });
                    },
              selectedColor: _getTypeColor(type),
            );
          }).toList(),
        ),
        if (isUpdate)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Type cannot be changed during update',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Color _getTypeColor(DharmasetuType type) {
    switch (type) {
      case DharmasetuType.COMMUNITY:
        return Colors.orange.shade100;
      case DharmasetuType.HOME:
        return Colors.teal.shade100;
      case DharmasetuType.ONLINE:
        return Colors.purple.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Widget _statusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: DharmasetuStatus.values.map((status) {
            return ChoiceChip(
              label: Text(status.name),
              selected: _selectedStatus == status,
              onSelected: _isSubmitting 
                  ? null 
                  : (selected) => setState(() => _selectedStatus = status),
              selectedColor: _getStatusColor(status),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getStatusColor(DharmasetuStatus status) {
    switch (status) {
      case DharmasetuStatus.WIP:
        return Colors.blue.shade100;
      case DharmasetuStatus.COMPLETED:
        return Colors.green.shade100;
      case DharmasetuStatus.CANCELLED:
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Widget _dateField() => TextFormField(
    controller: _dateController,
    enabled: !_isSubmitting,
    decoration: _inputDecoration('Date (YYYY-MM-DD)', required: true),
    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter Date' : null,
    readOnly: true,
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateController.text.isNotEmpty 
            ? DateTime.parse(_dateController.text)
            : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) {
        String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        setState(() {
          _dateController.text = formattedDate;
        });
      }
    },
  );

  Widget _actionButtons(bool isUpdate) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: _isSubmitting ? null : () => Get.back(),
        icon: const Icon(Icons.close),
        label: const Text('Cancel'),
      ),
      const SizedBox(width: 16),
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: isUpdate ? Colors.orange : null,
        ),
        onPressed: _isSubmitting ? null : _submitForm,
        icon: _isSubmitting 
            ? const SizedBox(
                width: 20, 
                height: 20, 
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
              )
            : Icon(isUpdate ? Icons.update : Icons.check_circle),
        label: Text(
          _isSubmitting 
              ? (isUpdate ? 'Updating...' : 'Saving...')
              : (isUpdate ? 'Update Dharmasetu' : 'Save Dharmasetu')
        ),
      ),
    ],
  );
}