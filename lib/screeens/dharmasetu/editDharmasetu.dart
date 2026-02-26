import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class EditDharmasetu extends StatefulWidget {
  const EditDharmasetu({super.key}); // Keep const here is fine

  @override
  State<EditDharmasetu> createState() => _EditDharmaSetuState();
}

class _EditDharmaSetuState extends State<EditDharmasetu> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> dharma;

  // Main controllers
  final _uidController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _feedbackController = TextEditingController();
  final _dateController = TextEditingController();
  final _referredByController = TextEditingController();

  // Type-specific controllers
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

  @override
  void initState() {
    super.initState();
    // Get data from arguments
    final args = Get.arguments ?? {};
    dharma = args is Map<String, dynamic> ? Map.from(args) : {};

    // Initialize controllers with existing data
    _uidController.text = dharma['uid']?.toString() ?? '';
    _nameController.text = dharma['name']?.toString() ?? '';
    _phoneController.text = dharma['phone']?.toString() ?? '';
    _feedbackController.text = dharma['feedback']?.toString() ?? '';
    _dateController.text = dharma['date']?.toString() ?? '';
    _referredByController.text = dharma['referredBy']?.toString() ?? '';

    _selectedType = dharma['type']?.toString() ?? 'Community';
    _selectedStatus = dharma['status']?.toString() ?? 'Active';

    // Initialize type-specific fields
    _communityNameController.text = dharma['communityName']?.toString() ?? '';
    _communityLocationController.text =
        dharma['communityLocation']?.toString() ?? '';
    _communityOwnerController.text = dharma['communityOwner']?.toString() ?? '';

    _homeOwnerController.text = dharma['homeOwner']?.toString() ?? '';
    _homeAddressController.text = dharma['homeAddress']?.toString() ?? '';

    _virtualLinkController.text = dharma['virtualLink']?.toString() ?? '';
  }

  @override
  void dispose() {
    _uidController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _feedbackController.dispose();
    _dateController.dispose();
    _referredByController.dispose();
    _communityNameController.dispose();
    _communityLocationController.dispose();
    _communityOwnerController.dispose();
    _homeOwnerController.dispose();
    _homeAddressController.dispose();
    _virtualLinkController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedDharma = {
        ...dharma,
        'uid': _uidController.text,
        'type': _selectedType,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'feedback': _feedbackController.text,
        'date': _dateController.text,
        'referredBy': _referredByController.text,
        'status': _selectedStatus,
        // Type-specific fields
        if (_selectedType == 'Community') ...{
          'communityName': _communityNameController.text,
          'communityLocation': _communityLocationController.text,
          'communityOwner': _communityOwnerController.text,
        },
        if (_selectedType == 'Home') ...{
          'homeOwner': _homeOwnerController.text,
          'homeAddress': _homeAddressController.text,
        },
        if (_selectedType == 'Virtual') ...{
          'virtualLink': _virtualLinkController.text,
        },
      };

      Get.snackbar(
        'Success',
        'Dharmasetu updated for ${_nameController.text}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back(result: updatedDharma);
    }
  }

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
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    bool required = false,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      decoration: _inputDecoration(required ? '$label *' : label),
      validator: required
          ? (v) => v == null || v.trim().isEmpty ? 'Please enter $label' : null
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
    readOnly: true,
    onTap: () async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          _dateController.text =
              "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
        });
      }
    },
  );

  Widget _communityFields() => Column(
    children: [
      const SizedBox(height: 16),
      Text(
        'Community Details',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
      const SizedBox(height: 16),
      _twoFieldRow(
        _textField('Community Name', _communityNameController, required: true),
        _textField('Location', _communityLocationController, required: true),
      ),
      _twoFieldRow(
        _textField('Owner', _communityOwnerController, required: true),
        const SizedBox(),
      ),
    ],
  );

  Widget _homeFields() => Column(
    children: [
      const SizedBox(height: 16),
      Text(
        'Home Details',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
      const SizedBox(height: 16),
      _twoFieldRow(
        _textField('Owner Name', _homeOwnerController, required: true),
        _textField('Address', _homeAddressController, required: true),
      ),
    ],
  );

  Widget _virtualFields() => Column(
    children: [
      const SizedBox(height: 16),
      Text(
        'Virtual Details',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
      const SizedBox(height: 16),
      _twoFieldRow(
        _textField('Virtual Link', _virtualLinkController, required: true),
        const SizedBox(),
      ),
    ],
  );

  Widget _actionButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        onPressed: () => Get.back(),
        icon: const Icon(Icons.close, size: 18),
        label: const Text('Cancel'),
      ),
      const SizedBox(width: 16),
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.brown.shade600,
          foregroundColor: Colors.white,
        ),
        onPressed: _submitForm,
        icon: const Icon(Icons.save_outlined, size: 18),
        label: const Text('Update'),
      ),
    ],
  );

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        color: Colors.orange.shade600,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Edit Dharmasetu',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Update the details below',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Basic Information Section
                        const Text(
                          'Basic Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _twoFieldRow(
                          _textField(
                            'Dharmasetu UID',
                            _uidController,
                            required: true,
                          ),
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

                        _twoFieldRow(_statusDropdown(), const SizedBox()),

                        // Type-specific fields
                        if (_selectedType == 'Community') _communityFields(),
                        if (_selectedType == 'Home') _homeFields(),
                        if (_selectedType == 'Virtual') _virtualFields(),

                        const SizedBox(height: 16),

                        const Text(
                          'Feedback',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
