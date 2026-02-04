import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController pincodeCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController areaCtrl = TextEditingController();
  final TextEditingController stateCtrl = TextEditingController();
  final TextEditingController countryCtrl = TextEditingController();

  final List<Map<String, String>> userTypes = [
    {"label": "SUPER ADMIN", "value": "SUPER_ADMIN"},
    {"label": "ADMIN", "value": "ADMIN"},
    {"label": "KARYAKARTHA", "value": "KARYAKARTHA"},
    {"label": "OFFICE STAFF", "value": "OFFICE_STAFF"},
  ];

  String userType = "SUPER_ADMIN";

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 700;

    Widget rowFields(Widget first, Widget second) {
      return isWideScreen
          ? Row(
              children: [
                Expanded(child: first),
                const SizedBox(width: 16),
                Expanded(child: second),
              ],
            )
          : Column(children: [first, second]);
    }

    return Layout(
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
                    const Text(
                      "Register New User",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1),
                    const SizedBox(height: 16),

                    const Text(
                      "Personal Information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    rowFields(
                      _input(nameCtrl, "Full Name", lettersOnly: true),
                      _input(
                        emailCtrl,
                        "Email",
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    rowFields(
                      _input(
                        mobileCtrl,
                        "Mobile Number",
                        keyboardType: TextInputType.phone,
                        numbersOnly: true,
                      ),
                      _dropdown(userType, "User Type", userTypes),
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      "Address Information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    rowFields(
                      _input(
                        pincodeCtrl,
                        "Pincode",
                        keyboardType: TextInputType.number,
                        numbersOnly: true,
                      ),
                      _input(cityCtrl, "City", lettersOnly: true),
                    ),
                    rowFields(
                      _input(areaCtrl, "Area", lettersOnly: true),
                      _input(stateCtrl, "State", lettersOnly: true),
                    ),
                    rowFields(
                      _input(countryCtrl, "Country", lettersOnly: true),
                      const SizedBox(),
                    ),

                    const SizedBox(height: 22),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: MediaQuery.of(context).size.width > 600
                            ? 430
                            : double.infinity,
                        child: isWideScreen
                            ? Row(
                                children: [
                                  _cancelButton(),
                                  const SizedBox(width: 16),
                                  _registerButton(),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _registerButton(),
                                  const SizedBox(height: 12),
                                  _cancelButton(),
                                ],
                              ),
                      ),
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

  Widget _input(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool lettersOnly = false,
    bool numbersOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: [
          if (lettersOnly)
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          if (numbersOnly) FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty)
            return '$label is required';
          if (lettersOnly && !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
            return '$label must contain letters only';
          }
          if (numbersOnly && !RegExp(r'^\d+$').hasMatch(value.trim())) {
            return '$label must contain numbers only';
          }
          if (label == "Mobile Number" && value.trim().length != 10) {
            return 'Mobile Number must be 10 digits';
          }
          if (label == "Pincode" && value.trim().length != 6) {
            return 'Pincode must be 6 digits';
          }
          if (label == "Email" &&
              !RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value.trim())) {
            return 'Enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget _dropdown(
    String value,
    String label,
    List<Map<String, String>> items,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black),
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item["value"],
                child: Text(item["label"]!),
              ),
            )
            .toList(),
        onChanged: (val) => setState(() => userType = val!),
        validator: (val) =>
            val == null || val.isEmpty ? 'Please select $label' : null,
      ),
    );
  }

  Widget _registerButton() {
    return Expanded(
      child: SizedBox(
        height: 45, 
        child: ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8D6E63),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 3,
          ),
          child: const Text(
            "Register",
            style: TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cancelButton() {
    return Expanded(
      child: SizedBox(
        height: 45,
        child: ElevatedButton(
          onPressed: _cancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), 
              side: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
            elevation: 1,
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "name": nameCtrl.text.trim(),
      "email": emailCtrl.text.trim(),
      "mobileNumber": mobileCtrl.text.trim(),
      "userType": userType,
      "pincode": pincodeCtrl.text.trim(),
      "city": cityCtrl.text.trim(),
      "area": areaCtrl.text.trim(),
      "state": stateCtrl.text.trim(),
      "country": countryCtrl.text.trim(),
    };

    debugPrint(payload.toString());
  }

  void _cancel() {
    _formKey.currentState?.reset();
    // Or navigate back to previous screen
    // Navigator.pop(context);
  }
}
