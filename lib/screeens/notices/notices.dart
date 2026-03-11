import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vikas_app/api_services/network_repos/auth_repository.dart';
import 'package:vikas_app/bloc_management/notices/notice_bloc.dart';
import 'package:vikas_app/bloc_management/notices/notice_event.dart';
import 'package:vikas_app/bloc_management/notices/notice_state.dart';
import 'package:vikas_app/screeens/models/enum/user_type.dart';
import 'package:vikas_app/screeens/models/request/notice_request.dart';          // for create
import 'package:vikas_app/screeens/models/response/notice_response.dart';
import 'package:vikas_app/screeens/models/response/user_view.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class Notices extends StatefulWidget {
  final NoticeResponse? noticeData;

  const Notices({super.key, this.noticeData});

  @override
  State<Notices> createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  final _formKey = GlobalKey<FormState>();

  /// Audience selection
  String _selectedSpecificOption = 'User Type';
  String? _selectedUserType; // Stores display name (e.g., "Admin", "All Users")
  List<String> _selectedUsers = []; // Will store user IDs when integrated
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  /// Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  File? _selectedFile;
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;

  bool _isSubmitting = false;
  bool _isLoading = true;


  //List<UserView> _allUsers = [];
  List<String> _allUsers = [];
  bool _isLoadingUsers = false;

  final List<String> _userTypeOptions = [
    'All Users',
    UserType.admin.displayName,
    UserType.karyakartha.displayName,
    UserType.officeStaff.displayName,
    UserType.superAdmin.displayName,
  ];



  @override
  void initState() {
    super.initState();
    _initializeData();
    _fetchUsers();
  }

  void _initializeData() {
    if (widget.noticeData != null) {
      _populateFields();
    }
    setState(() => _isLoading = false);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedTime != null) {
        _timeController.text = _selectedTime!.format(context);
      }
    });
  }

  void _fetchUsers() async {
  setState(() => _isLoadingUsers = true);
  final authRepo = AuthRepository();
  final result = await authRepo.getAllUsers(page: 0, size: 1000); 
  
  if (result.isSuccess && result.data != null) {
    setState(() {
      _allUsers = result.data!.content
          .map((user) => user.name ?? 'Unknown User')
          .where((name) => name.isNotEmpty) 
          .toList();
      _isLoadingUsers = false;
      
      print('Loaded ${_allUsers.length} users: $_allUsers');
    });
  } else {
    print('Failed to load users: ${result.error?.message}');
    setState(() => _isLoadingUsers = false);
  }
}

  void _populateFields() {
    final notice = widget.noticeData;
    if (notice == null) return; 
    
    _titleController.text = notice.title;
    _descriptionController.text = notice.description;

    // Map sendTo to UI
    if (notice.sendTo != null) {
      if (notice.sendTo == 'TO_ALL') {
  _selectedUserType = 'All Users';
}
else if (notice.sendTo == 'TO_ADMINS') {
  _selectedUserType = UserType.admin.displayName;
}
else if (notice.sendTo == 'TO_KARYAKARTHAS') {
  _selectedUserType = UserType.karyakartha.displayName;
}
else if (notice.sendTo == 'TO_OFFICESTAFF') {
  _selectedUserType = UserType.officeStaff.displayName;
}
else if (notice.sendTo == 'TO_SPECIFIC') {
  _selectedSpecificOption = 'User';
}
    }

    if (notice.sendTime != null) {
      _selectedDate = notice.sendTime;
      _selectedTime = TimeOfDay.fromDateTime(notice.sendTime!);
      _dateController.text = DateFormat('yyyy-MM-dd').format(notice.sendTime!);
      // Time formatting moved to addPostFrameCallback in _initializeData()
    }

    // TODO: Load existing image if any (requires handling base64/URL)
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

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
      _showError('Failed to select image: $e');
    }
  }

  /// Convert selected image to base64
  Future<String?> _imageToBase64() async {
    if (kIsWeb && _selectedFileBytes != null) {
      return base64Encode(_selectedFileBytes!);
    } else if (_selectedFile != null) {
      final bytes = await _selectedFile!.readAsBytes();
      return base64Encode(bytes);
    }
    return null;
  }

  /// Map selected display name to API sendTo value
 String _mapDisplayNameToSendTo(String? displayName) {
  if (displayName == null || displayName == 'All Users') return 'TO_ALL';
  if (displayName == UserType.admin.displayName) return 'TO_ADMINS';
  if (displayName == UserType.karyakartha.displayName) return 'TO_KARYAKARTHAS';
  if (displayName == UserType.officeStaff.displayName) return 'TO_OFFICESTAFF';
  return 'TO_ALL';
}

  /// Main submit method
  void _submitNotice() async {
  final formState = _formKey.currentState;
  if (formState == null || !formState.validate()) return;

  final isEditing = widget.noticeData != null;

  if (!isEditing) {
    if (_selectedDate == null) {
      _showError('Please select a date');
      return;
    }

    if (_selectedTime == null) {
      _showError('Please select a time');
      return;
    }
  }

  setState(() => _isSubmitting = true);

  final imageBase64 = await _imageToBase64();

  final sendDateTime = DateTime(
    _selectedDate!.year,
    _selectedDate!.month,
    _selectedDate!.day,
    _selectedTime!.hour,
    _selectedTime!.minute,
  );

  String sendTo;
  List<String>? specificUsers;

  if (_selectedSpecificOption == 'User Type') {
    sendTo = _mapDisplayNameToSendTo(_selectedUserType);
    specificUsers = [];
  } else {
    sendTo = "TO_SPECIFIC";
    specificUsers = _selectedUsers;
  }

  final request = NoticeRequest(
    title: _titleController.text,
    message: _descriptionController.text,
    audienceType: _selectedSpecificOption == 'User Type' ? 'USER_TYPE' : 'SPECIFIC_USERS',
    audienceValue: _selectedSpecificOption == 'User Type' ? sendTo : _selectedUsers.join(','),
    date: sendDateTime,
    time: _selectedTime!.format(context),
    attachment: _selectedFile,
  );

  if (isEditing) {
    context.read<NoticeBloc>().add(
      UpdateNoticeEvent(widget.noticeData!.id, request),
    );
  } else {
    context.read<NoticeBloc>().add(
      CreateNoticeEvent(request),
    );
  }
}

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _dateController.clear();
    _timeController.clear();
    setState(() {
      _selectedSpecificOption = 'User Type';
      _selectedUserType = null;
      _selectedUsers.clear();
      _selectedFile = null;
      _selectedFileBytes = null;
      _selectedFileName = null;
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  void _showUserSelectionDialog() {
    // Use fetched users if available, otherwise show loading or empty state
    List<String> allUsers = [];
    if (_allUsers.isNotEmpty) {
      allUsers = _allUsers.map((user) => user ?? 'Unknown User').toList();
    }

    List<String> tempSelectedUsers = List.from(_selectedUsers);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 700,
                  maxHeight: 400,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Select Users',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _isLoadingUsers
                            ? const Center(child: CircularProgressIndicator())
                            : allUsers.isEmpty
                                ? const Center(child: Text('No users available'))
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: allUsers.length,
                                    itemBuilder: (context, index) {
                                      final user = allUsers[index];
                                      final isSelected = tempSelectedUsers.contains(user);
                                      return CheckboxListTile(
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
                                        dense: true,
                                      );
                                    },
                                  ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
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
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noticeData != null;

    if (_isLoading) {
      return Layout(child: const Center(child: CircularProgressIndicator()));
    }

    return Layout(
      child: BlocConsumer<NoticeBloc, NoticeState>(
        listener: (context, state) {
          if (state.formStatus == NoticeFormStatus.success) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(
            //       isEditing
            //           ? 'Notice updated successfully'
            //           : 'Notice sent successfully',
            //     ),
            //     backgroundColor: Colors.green,
            //   ),
            // );
           Future.delayed(const Duration(milliseconds: 500), () {
  if (mounted) {
    Get.offNamed('/notices/list');
  }
});
          } else if (state.formStatus == NoticeFormStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.formErrorMessage ?? 'Error occurred'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() => _isSubmitting = false);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back button
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isEditing ? "Edit Notice" : "Add New Notice",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Audience selection – only show when creating
                  if (!isEditing) ...[
                    Row(
                      children: [
                        Radio<String>(
                          value: 'User Type',
                          groupValue: _selectedSpecificOption,
                          onChanged: (v) {
                            setState(() {
                              _selectedSpecificOption = v!;
                              _selectedUserType = null;
                              _selectedUsers.clear();
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
                              _selectedUserType = null;
                              _selectedUsers.clear();
                            });
                          },
                        ),
                        const Text('User'),
                      ],
                    ),

                    const SizedBox(height: 16),

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
                              items: _userTypeOptions,
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
                          SizedBox(
                            width: 700,
                            child: GestureDetector(
                              onTap: _showUserSelectionDialog,
                              child: Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
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
                                    border: Border.all(
                                      color: Colors.blue.shade200,
                                    ),
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
                  ], // end !isEditing

                  // Title field (always visible)
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

                  // Description field
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _descriptionController,
                    hint: 'Enter notice description',
                    maxLines: 4,
                  ),

                  const SizedBox(height: 20),

                  // Date & Time pickers – only show when creating
                  if (!isEditing) ...[
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
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 14,
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
                                  'Time',
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
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextFormField(
                                    controller: _timeController,
                                    readOnly: true,
                                    validator: (v) => v == null || v.isEmpty
                                        ? 'Please select a time'
                                        : null,
                                    decoration: InputDecoration(
                                      hintText: 'Select time',
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 14,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                          Icons.access_time,
                                          size: 20,
                                        ),
                                        onPressed: _selectTime,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _timeController.text.isEmpty
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Image attachment (always visible)
                  SizedBox(
                    width: 700,
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
                        InkWell(
                          onTap: _handleFileSelection,
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
                                            _selectedFile!.path.split('/').last
                                        : 'Choose image',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_selectedFile != null || _selectedFileBytes != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
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
                  ),

                  const SizedBox(height: 30),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      OutlinedButton(
                        onPressed: _clearForm,
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitNotice,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEditing ? Colors.orange : null,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(isEditing ? 'Update Notice' : 'Send Notice'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
}