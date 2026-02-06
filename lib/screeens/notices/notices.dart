import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class Notices extends StatefulWidget {
  const Notices({super.key});

  @override
  State<Notices> createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  final _formKey = GlobalKey<FormState>();

  /// Audience selection - Now only two options
  String _selectedSpecificOption = 'User Type'; // Default to User Type
  String? _selectedUserType;
  String? _selectedUserName;
  List<String> _selectedUsers = [];
  DateTime? _selectedDate;

  /// Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  File? _selectedFile;
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;

  final List<String> _userTypes = ['All Users', 'Admin', 'Karyakatha', 'Staff'];
  final Map<String, List<String>> _usersByType = {
    'all': ['All Users'],
    'Admin': ['Reddy Srinu', 'Suresh Kumar', 'Anitha Rao'],
    'Karyakatha': ['Ramesh', 'Lakshmi', 'Narayan', 'Padma'],
    'Staff': ['Prakash', 'Sunitha', 'Mahesh', 'Kavya'],
  };

  void _handleFileSelection() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedFile = File(pickedFile.path);
        });

        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _selectedFileBytes = bytes;
            _selectedFileName = pickedFile.name;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitNotice() {
    if (_formKey.currentState!.validate()) {
      if (_formKey.currentState!.validate()) {
        if (_selectedDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a date'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        String audienceType = '';
        String audienceValue = '';

        if (_selectedSpecificOption == 'User Type') {
          audienceType = 'User Type';
          audienceValue = _selectedUserType ?? 'Not Selected';
        } else {
          audienceType = 'Specific Users';
          audienceValue = _selectedUsers.isEmpty
              ? 'No users selected'
              : _selectedUsers.join(', ');
        }

        debugPrint('Audience Type: $audienceType');
        debugPrint('Audience Value: $audienceValue');
        debugPrint('Title: ${_titleController.text}');
        debugPrint('Message: ${_messageController.text}');
        debugPrint('File: ${_selectedFile?.path}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notice sent successfully'),
            backgroundColor: Colors.green,
          ),
        );

        _clearForm();
      }
    }
  }

  /// Reset form
  void _clearForm() {
    _titleController.clear();
    _messageController.clear();
    _dateController.clear();
    setState(() {
      _selectedSpecificOption = 'User Type'; // Reset to default
      _selectedUserType = null;
      _selectedUserName = null;
      _selectedUsers.clear();
      _selectedFile = null;
      _selectedFileBytes = null;
      _selectedFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  IconButton(
              //   icon: const Icon(Icons.arrow_back, size: 22),
              //   padding: EdgeInsets.zero,
              //   constraints: const BoxConstraints(),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),
              // //const SizedBox(width: 6),
              // const Text(

              //   'Add New Notice',
              //   style: TextStyle(
              //     fontSize: 28,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.brown,
              //   ),
              // ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 22),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Add New Notice",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Radio<String>(
                    value: 'User Type',
                    groupValue: _selectedSpecificOption,
                    onChanged: (v) {
                      setState(() {
                        _selectedSpecificOption = v!;
                        _selectedUserType = null; // Clear user type selection
                        _selectedUsers.clear(); // Clear selected users
                      });
                    },
                  ),
                  const Text('User Type'),
                  const SizedBox(width: 24),
                  Radio<String>(
                    value: 'User',
                    groupValue: _selectedSpecificOption,
                    onChanged: (v) {
                      setState(() {
                        _selectedSpecificOption = v!;
                        _selectedUserType = null; // Clear user type filter
                        _selectedUsers.clear(); // Clear selected users
                      });
                    },
                  ),
                  const Text('User'),
                ],
              ),

              const SizedBox(height: 16),

              /// Show User Type dropdown when User Type is selected
              if (_selectedSpecificOption == 'User Type')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select User Type',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 700,
                      child: _buildDropdown(
                        hint: 'Choose user type',
                        value: _selectedUserType,
                        items: _userTypes,
                        onChanged: (value) {
                          setState(() {
                            _selectedUserType = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),

              if (_selectedSpecificOption == 'User')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Users',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 6),

                    // User selection field
                    SizedBox(
                      width: 700,
                      child: GestureDetector(
                        onTap: () {
                          _showUserSelectionDialog();
                        },
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedUsers.isEmpty
                                      ? 'Select users'
                                      : '${_selectedUsers.length} user(s) selected',
                                  style: TextStyle(
                                    color: _selectedUsers.isEmpty
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Display selected users below (like chips)
                    if (_selectedUsers.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedUsers.map((user) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(user),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedUsers.remove(user);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),

              const SizedBox(height: 24),

              // Title field
              const Text(
                'Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _titleController,
                hint: 'Enter notice title',
              ),

              const SizedBox(height: 20),

              // Message field
              const Text(
                'Message Content',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _messageController,
                hint: 'Enter your message',
                maxLines: 4,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: 700,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Please select a date'
                                  : null,
                              decoration: InputDecoration(
                                hintText: 'Select date',
                                filled: true,
                                fillColor: Colors.transparent,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14, // Added vertical padding
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                  ),
                                  onPressed: _selectDate,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                color: _dateController.text.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Attach Image (Optional)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Column(
                            children: [
                              InkWell(
                                onTap: _handleFileSelection,
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.attach_file,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _selectedFile != null ||
                                                  _selectedFileName != null
                                              ? _selectedFileName ??
                                                    _selectedFile!.path
                                                        .split('/')
                                                        .last
                                              : 'Choose image',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Show image preview if selected
                              if (_selectedFile != null ||
                                  _selectedFileBytes != null) ...[
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: kIsWeb && _selectedFileBytes != null
                                        ? Image.memory(
                                            _selectedFileBytes!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[200],
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.error_outline,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          )
                                        : _selectedFile != null
                                        ? Image.file(
                                            _selectedFile!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[200],
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.error_outline,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          )
                                        : Container(),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  OutlinedButton(
                    onPressed: _clearForm,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitNotice,
                    child: const Text('Send Notice'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable dropdown
  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: items.contains(value) ? value : null,
        hint: Text(hint, style: const TextStyle(color: Colors.black54)),
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: Colors.white,
        onChanged: onChanged,
        items: items.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return SizedBox(
      width: 700,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _showUserSelectionDialog() {
    // Get ALL users from ALL types
    List<String> allUsers = [];
    _usersByType.forEach((key, value) {
      allUsers.addAll(value);
    });

    List<String> tempSelectedUsers = List.from(_selectedUsers);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 700, maxHeight: 400),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      const Text(
                        'Select Users',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Search bar
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search users...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                        ),
                        onChanged: (value) {
                          // Implement search filter if needed
                        },
                      ),
                      const SizedBox(height: 12),

                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: allUsers.length,
                          itemBuilder: (context, index) {
                            final user = allUsers[index];
                            final isSelected = tempSelectedUsers.contains(user);
                            return Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: CheckboxListTile(
                                value: isSelected,
                                title: Text(
                                  user,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                onChanged: (checked) {
                                  setStateDialog(() {
                                    if (checked == true) {
                                      if (!tempSelectedUsers.contains(user)) {
                                        tempSelectedUsers.add(user);
                                      }
                                    } else {
                                      tempSelectedUsers.remove(user);
                                    }
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 0,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedUsers = List.from(tempSelectedUsers);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Done'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
        _dateController.selection = TextSelection.fromPosition(
          TextPosition(offset: _dateController.text.length),
        );
      });
    }
  }
}
