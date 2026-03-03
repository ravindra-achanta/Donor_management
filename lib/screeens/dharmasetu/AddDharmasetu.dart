import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class AddDharmasetu extends StatefulWidget {
  const AddDharmasetu({super.key});

  @override
  State<AddDharmasetu> createState() => _AddDharmaSetuState();
}

class _AddDharmaSetuState extends State<AddDharmasetu> {
  final _formKey = GlobalKey<FormState>();

  final _uidController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _feedbackController = TextEditingController();
  final _dateController = TextEditingController();
  final _referredByController = TextEditingController();

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

  // ---------------- SUBMIT ----------------

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dharmasetu added for ${_nameController.text}')),
      );
      Get.offNamed('/dharmasetu');
    }
  }

  // ---------------- BUILD ----------------

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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Dharmasetu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

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

                    if (_selectedType == 'Community') _communityFields(),
                    if (_selectedType == 'Home') _homeFields(),
                    if (_selectedType == 'Virtual') _virtualFields(),

                    const SizedBox(height: 16),

                    _textField('Feedback', _feedbackController, maxLines: 3),

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

  // ---------------- TYPE SECTIONS ----------------

  Widget _communityFields() => Column(
    children: [
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
      _twoFieldRow(
        _textField('Owner Name', _homeOwnerController, required: true),
        _textField('Address', _homeAddressController, required: true),
      ),
    ],
  );

  Widget _virtualFields() => Column(
    children: [
      const SizedBox(height: 16),
      _twoFieldRow(
        _textField('Virtual Link', _virtualLinkController, required: true),
        const SizedBox(),
      ),
    ],
  );

  // ---------------- HELPERS ----------------

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
      fillColor: Colors.white, // 👈 makes dropdown visible
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
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
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

  Widget _dateField() => _textField('Date', _dateController, required: true);

  Widget _actionButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () => Get.back(),
        icon: const Icon(Icons.close),
        label: const Text('Cancel'),
      ),
      const SizedBox(width: 16),
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: _submitForm,
        icon: const Icon(Icons.check_circle),
        label: const Text('Save Dharmasetu'),
      ),
    ],
  );
}
