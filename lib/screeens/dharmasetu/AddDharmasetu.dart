import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/api_services/network_repos/darmasetu_repository.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_bloc.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_event.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_state.dart';
import 'package:vikas_app/screeens/common/referred_by_dropdown.dart';
import 'package:vikas_app/screeens/models/request/dharmasetu_model.dart';
import 'package:vikas_app/views/layouts/layout.dart';

// Define the enums here or import from a separate file
enum DharmasetuType { COMMUNITY, HOME, ONLINE }

enum DharmasetuStatus { WIP, CANCELLED, COMPLETED }

class AddDharmasetu extends StatefulWidget {
  final DharmasetuModel? dharmasetu;

  const AddDharmasetu({super.key, this.dharmasetu});

  @override
  State<AddDharmasetu> createState() => _AddDharmaSetuState();
}

class _AddDharmaSetuState extends State<AddDharmasetu> {
  final _formKey = GlobalKey<FormState>();
  late bool isEdit;
  late DharmasetuModel? model;

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
  Map<String, dynamic>? _selectedReferredBy;

  bool _isSubmitting = false;
  bool _isLoading = false;
  final _dharmaRepository = DharmasetuRepository();

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

    // Get arguments for edit mode
    final args = Get.arguments;
    isEdit = args is Map && args['isEdit'] == true;
    model = args is Map ? args['model'] : args;

    final d = widget.dharmasetu ?? model;

    // If edit mode, fetch fresh data from server
    if (isEdit && d != null && (d.id?.isNotEmpty ?? false)) {
      _loadFreshData(d.id!);
    } else if (d != null) {
      // Populate form with existing data
      _populateForm(d);
    } else {
      // Set default values for new entry
      _selectedType = DharmasetuType.COMMUNITY;
      _selectedStatus = DharmasetuStatus.WIP;
    }
  }

  Future<void> _loadFreshData(String dharmasetuId) async {
    setState(() => _isLoading = true);
    try {
      final result = await _dharmaRepository.getDharmasetuById(dharmasetuId);

      if (result.isSuccess && result.data != null) {
        final freshModel = DharmasetuModel.fromView(result.data!);
        setState(() {
          model = freshModel;
          _populateForm(freshModel);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data: ${result.error?.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _populateForm(DharmasetuModel d) {
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
        id:
            widget.dharmasetu?.id ??
            model?.id ??
            '', // Use model ID if widget ID not available
        dharmasetuId:
            widget.dharmasetu?.dharmasetuId ??
            model?.dharmasetuId ??
            '', // Use model ID if widget ID not available
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

      if (widget.dharmasetu != null || isEdit) {
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
    final isUpdate = widget.dharmasetu != null || isEdit;

    return BlocListener<DharmasetuBloc, DharmasetuState>(
      listener: (context, state) {
        setState(() => _isSubmitting = state.isSubmitting);

        if (state.successMessage != null) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(state.successMessage!),
          //     backgroundColor: Colors.green,
          //   ),
          // );
          Get.offNamed('/dharmasetu');
        }

        if (state.errorMessage != null) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(state.errorMessage!),
          //     backgroundColor: Colors.red,
          //   ),
          // );
          setState(() => _isSubmitting = false);
        }
      },
      child: Layout(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Card(
                  elevation: 4,
                  shadowColor: Colors.blueGrey.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                Text(
                                  isUpdate
                                      ? 'Update Dharmasetu'
                                      : 'Add Dharmasetu',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Type Selection
                            _typeDropdown(isUpdate),
                            const SizedBox(height: 24),

                            // Dynamic fields based on type
                            _buildTypeSpecificFields(),

                            const SizedBox(height: 24),

                            // Date and Referred By
                            _twoFieldRow(
                              _dateField(),
                              _buildReferredByField(), // <-- new widget
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
            _textField('City', _cityController, required: true),
            _textField('State', _stateController, required: true),
          ),
          const SizedBox(height: 16),
          _twoFieldRow(
            _textField('Country', _countryController, required: true),
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
          'Type *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<DharmasetuType>(
            segments: DharmasetuType.values.map((type) {
              return ButtonSegment<DharmasetuType>(
                value: type,
                label: Text(type.name),
                icon: Icon(_getTypeIcon(type)),
              );
            }).toList(),
            selected: _selectedType != null ? {_selectedType!} : {},
            onSelectionChanged: _isSubmitting || isUpdate
                ? null
                : (Set<DharmasetuType> newSelection) {
                    setState(() {
                      _selectedType = newSelection.first;
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
            style: SegmentedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              selectedForegroundColor: Colors.white,
              selectedBackgroundColor: _getTypeColor(_selectedType),
              backgroundColor: Colors.grey[100],
              side: BorderSide.none,
            ),
          ),
        ),
        if (isUpdate) const SizedBox(height: 8),
        if (isUpdate)
          Text(
            'Type cannot be changed during update',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  IconData _getTypeIcon(DharmasetuType type) {
    switch (type) {
      case DharmasetuType.COMMUNITY:
        return Icons.group;
      case DharmasetuType.HOME:
        return Icons.home;
      case DharmasetuType.ONLINE:
        return Icons.videocam;
    }
  }

  Color _getTypeColor(DharmasetuType? type) {
    switch (type) {
      case DharmasetuType.COMMUNITY:
        return Colors.orange;
      case DharmasetuType.HOME:
        return Colors.teal;
      case DharmasetuType.ONLINE:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  Widget _statusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: DharmasetuStatus.values.map((status) {
            return FilterChip(
              label: Text(status.name),
              selected: _selectedStatus == status,
              onSelected: _isSubmitting
                  ? null
                  : (selected) {
                      setState(() => _selectedStatus = status);
                    },
              selectedColor: _getStatusColor(status).withOpacity(0.3),
              checkmarkColor: _getStatusColor(status),
              backgroundColor: Colors.grey[100],
              side: BorderSide(color: _getStatusColor(status).withOpacity(0.5)),
              labelStyle: TextStyle(
                fontWeight: _selectedStatus == status
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
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
    validator: (v) =>
        v == null || v.trim().isEmpty ? 'Please enter Date' : null,
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
        String formattedDate =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        setState(() {
          _dateController.text = formattedDate;
        });
      }
    },
  );

  //
  Widget _actionButtons(bool isUpdate) => Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(color: Colors.grey.shade400),
          ),
          onPressed: _isSubmitting ? null : () => Get.back(),
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: isUpdate
                  ? [Colors.orange, Colors.deepOrange]
                  : [Colors.blue, Colors.lightBlue],
            ),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color.fromARGB(0, 240, 104, 104),
              shadowColor: Colors.transparent,
            ),
            onPressed: _isSubmitting ? null : _submitForm,
            child: _isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isUpdate ? Icons.update : Icons.check_circle,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isUpdate ? 'Update' : 'Save',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                           color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    ),
  );

  Widget _buildReferredByField() {
    return ReferredByDropdown(
      controller: _referredByController,
      initialValue: _selectedReferredBy,
      onSelected: (value) {
        setState(() {
          _selectedReferredBy = value;
          _referredByController.text = value?['userName'] ?? '';
        });
      },
    );
  }
}
