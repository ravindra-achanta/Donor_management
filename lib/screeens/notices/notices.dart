import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/network_repos/auth_repository.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/bloc_management/notices/notice_bloc.dart';
import 'package:vikas_app/bloc_management/notices/notice_event.dart';
import 'package:vikas_app/bloc_management/notices/notice_state.dart';
import 'package:vikas_app/screeens/models/enum/notice_type.dart';
import 'package:vikas_app/screeens/models/request/notice_request.dart';
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

 
  String _selectedSpecificOption = 'User Type';
  NoticeType? _selectedAudienceType;
  List<UserView> _selectedUsers = [];
  List<UserView> _allUsers = [];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late List<NoticeType> _audienceTypes;

  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  File? _selectedFile;
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  String? _uploadedImageUrl;

  bool _isSubmitting = false;
  bool _isLoading = true;
  static const List<String> _allowedUserTypes = [
    'GURUJI',
    'SUPER_ADMIN',
    'KARYAKARTHA',
    'ADMIN',
    'OFFICE_STAFF',
  ];

  //Map<String, String> _userIdToName = {};
  bool _isLoadingUsers = false;

  @override
  void initState() {
    super.initState();
    _audienceTypes = NoticeType.values
        .where((type) => type != NoticeType.toSpecific)
        .toList();
    _initializeData();
    _fetchUsers();
  }

  void _initializeData() {
    if (widget.noticeData != null) {
      _populateFields();
    if (widget.noticeData!.image != null && widget.noticeData!.image!.isNotEmpty) {
      _uploadedImageUrl = widget.noticeData!.image;
      _selectedFileName = 'Current image';
    }
  }
  
    setState(() => _isLoading = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedTime != null) {
        _timeController.text = _selectedTime!.format(context);
      }
    });
  }

  Widget _buildAudienceDropdown({
    required String hint,
    required NoticeType? value,
    required List<NoticeType> items,
    required ValueChanged<NoticeType?> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<NoticeType>(
        value: items.contains(value) ? value : null,
        hint: Text(hint, style: const TextStyle(color: Colors.black54)),
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: Colors.white,
        onChanged: onChanged,
        items: items.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(
              type.displayName,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _fetchUsers() async {
    setState(() => _isLoadingUsers = true);
    final authRepo = AuthRepository();
    final result = await authRepo.getAllUsers(page: 0, size: 1000);

    if (result.isSuccess && result.data != null) {
      setState(() {
        _allUsers = result.data!.content;
        for (var user in _allUsers) {
          final type = user.userType ?? 'NO_TYPE';
          print('User: ${user.id}, type: $type');
        }
        _isLoadingUsers = false;
        print('Loaded ${_allUsers.length} users');
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

    if (notice.sendTo != null) {
      if (notice.sendTo == 'TO_SPECIFIC') {
        _selectedSpecificOption = 'User';
      } else {
        _selectedSpecificOption = 'User Type';
        try {
          _selectedAudienceType = NoticeType.fromString(notice.sendTo!);
        } catch (e) {
          _selectedAudienceType = NoticeType.toAll;
        }
      }
    }

    if (notice.sendTime != null) {
      _selectedDate = notice.sendDateTime;
      _selectedTime = TimeOfDay.fromDateTime(notice.sendDateTime!);
      _dateController.text = DateFormat('yyyy-MM-dd').format(notice.sendDateTime!);
    }

   
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  // void _handleFileSelection() async {
  //   try {
  //     final XFile? pickedFile = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 85,
  //       maxWidth: 1200,
  //     );

  //     if (pickedFile != null) {
  //       final bytes = await pickedFile.readAsBytes();
  //       setState(() {
  //         _selectedFileBytes = bytes;
  //         _selectedFileName = pickedFile.name;
  //         _selectedFile = null;
  //       });
  //     }
  //   } catch (e) {
  //     _showError('Failed to select image: $e');
  //   }
  // }

  final NetworkService _api = NetworkService.instance;
 void _handleFileSelection() async {
  try {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (pickedFile != null) {
      setState(() => _isSubmitting = true);
     final response =  await _api.fileUpload(ApiConstants.uploadimage,pickedFile );
       setState(() => _isSubmitting = false);
      if(response != null && response.isNotEmpty){
         setState(() => _uploadedImageUrl = response);
      }else{
        _showError('Image upload failed: Empty response');
      }
     
  }} catch (e) {
    _showError('Failed to select/upload image: $e');
    setState(() => _isSubmitting = false);
  }
}

  // Future<String?> _imageToBase64() async {
  //   if (kIsWeb && _selectedFileBytes != null) {
  //     return base64Encode(_selectedFileBytes!);
  //   } else if (_selectedFile != null) {
  //     final bytes = await _selectedFile!.readAsBytes();
  //     return base64Encode(bytes);
  //   }
  //   return null;
  // }

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
     final sendDateStr = _selectedDate != null
      ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
      : '';

 
 final sendTimeStr = _selectedTime != null
    ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00'
    : '00:00:00';

   

  

    String sendTo;
    List<Map<String, String>>? specificUsers;

    if (_selectedSpecificOption == 'User Type') {
      if (_selectedAudienceType == null) {
        _showError('Please select a user type');
        setState(() => _isSubmitting = false);
        return;
      }
      sendTo = _selectedAudienceType!.value;
      specificUsers = [];
    } else {
      sendTo = "TO_SPECIFIC";

      final validUsers = _selectedUsers.where((user) {
        return user.userType != null &&
            _allowedUserTypes.contains(user.userType);
      }).toList();

      if (validUsers.isEmpty) {
        _showError(
          'No users with a valid type selected. Allowed types: ${_allowedUserTypes.join(', ')}',
        );
        setState(() => _isSubmitting = false);
        return;
      }

      specificUsers = validUsers.map((user) {
        return {
          'id': user.id,
          'type': user.userType!,
        };
      }).toList();
    }

    final request = NoticeRequest(
      image:  _uploadedImageUrl,
      title: _titleController.text,
      description: _descriptionController.text,
      //sendDate: DateTime.parse(sendDateTime),
      sendDate: sendDateStr,
      sendTime: sendTimeStr,
      sendTo: sendTo,
      specificUsers: specificUsers,
    );

 
    print('Sending request: ${jsonEncode(request.toJson())}');

    if (isEditing) {
      context.read<NoticeBloc>().add(
        UpdateNoticeEvent(widget.noticeData!.id, request),
      );
    } else {
      context.read<NoticeBloc>().add(CreateNoticeEvent(request));
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
      _selectedAudienceType = null;
      _selectedUsers.clear();
      _selectedFile = null;
      _selectedFileBytes = null;
      _selectedFileName = null;
      _selectedDate = null;
      _selectedTime = null;
      _uploadedImageUrl = null;
    });
  }

  // void _showUserSelectionDialog() {
  //   List<UserView> tempSelected = List.from(_selectedUsers);

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setStateDialog) {
  //           return Dialog(
  //             insetPadding: const EdgeInsets.all(20),
  //             child: ConstrainedBox(
  //               constraints: const BoxConstraints(
  //                 maxWidth: 700,
  //                 maxHeight: 400,
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(16),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.stretch,
  //                   children: [
  //                     const Text(
  //                       'Select Users',
  //                       style: TextStyle(
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 12),
  //                     Expanded(
  //                       child: _isLoadingUsers
  //                           ? const Center(child: CircularProgressIndicator())
  //                           : _allUsers.isEmpty
  //                           ? const Center(child: Text('No users available'))
  //                           : ListView.builder(
  //                               shrinkWrap: true,
  //                               itemCount: _allUsers.length,
  //                               itemBuilder: (context, index) {
  //                                 final user = _allUsers[index];
  //                                 // final hasValidType =
  //                                 //     user.userType.isNotEmpty &&
  //                                 //     _allowedUserTypes.contains(
  //                                 //       user.userType,
  //                                 //     );
  //                                 // final isSelected = tempSelected.any(
  //                                 //   (u) => u.id == user.id,
  //                                 // );
  //                                 final hasValidType =
  //                                     user.userType != null &&
  //                                     _allowedUserTypes.contains(user.userType);
  //                                 final isSelected = tempSelected.any(
  //                                   (u) => u.id == user.id,
  //                                 );
  //                                 return CheckboxListTile(
  //                                   value: isSelected && hasValidType,
  //                                   title: Text(
  //                                     user.name ?? 'Unknown',
  //                                     style: TextStyle(
  //                                       fontSize: 14,
  //                                       color: hasValidType
  //                                           ? Colors.black
  //                                           : Colors.grey,
  //                                     ),
  //                                   ),
  //                                   subtitle: Text(
  //                                     hasValidType
  //                                         ? user.userType!
  //                                         : 'Invalid type',
  //                                     style: TextStyle(
  //                                       color: hasValidType
  //                                           ? Colors.grey
  //                                           : Colors.red,
  //                                     ),
  //                                   ),
  //                                   onChanged: hasValidType
  //                                       ? (checked) {
  //                                           setStateDialog(() {
  //                                             if (checked == true) {
  //                                               if (!tempSelected.any(
  //                                                 (u) => u.id == user.id,
  //                                               )) {
  //                                                 tempSelected.add(user);
  //                                               }
  //                                             } else {
  //                                               tempSelected.removeWhere(
  //                                                 (u) => u.id == user.id,
  //                                               );
  //                                             }
  //                                           });
  //                                         }
  //                                       : null,
  //                                   dense: true,
  //                                 );
  //                               },
  //                             ),
  //                     ),
  //                     const SizedBox(height: 16),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         TextButton(
  //                           onPressed: () => Navigator.pop(context),
  //                           child: const Text('Cancel'),
  //                         ),
  //                         const SizedBox(width: 8),
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             setState(() {
  //                               _selectedUsers = List.from(tempSelected);
  //                             });
  //                             Navigator.pop(context);
  //                           },
  //                           child: const Text('Done'),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

void _showUserSelectionDialog() {
  // Filter users to those with valid types
  final validUsers = _allUsers.where((user) {
    return user.userType != null && _allowedUserTypes.contains(user.userType);
  }).toList();

  // Group users by userType (already distinct by type)
  final Map<String, List<UserView>> groupedUsers = {};
  for (final user in validUsers) {
    final type = user.userType!;
    groupedUsers.putIfAbsent(type, () => []).add(user);
  }

  // Sort groups according to the order in _allowedUserTypes
  final List<String> groupKeys = [];
  for (final type in _allowedUserTypes) {
    if (groupedUsers.containsKey(type)) {
      groupKeys.add(type);
    }
  }

  // Keep a local copy of selected users (these are the actual UserView objects)
  List<UserView> tempSelected = List.from(_selectedUsers);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          // Helper to check if a specific user (by id and type) is selected
          bool isUserSelected(UserView user) {
            return tempSelected.any((selected) =>
                selected.id == user.id && selected.userType == user.userType);
          }

          // Helper to check if all users in a group are selected
          bool isGroupSelected(String groupKey) {
            final groupUsers = groupedUsers[groupKey] ?? [];
            if (groupUsers.isEmpty) return false;
            return groupUsers.every((user) => isUserSelected(user));
          }

          // Helper to check if any user in a group is selected (for tri-state)
          bool isGroupPartiallySelected(String groupKey) {
            final groupUsers = groupedUsers[groupKey] ?? [];
            if (groupUsers.isEmpty) return false;
            final selectedCount = groupUsers.where((user) => isUserSelected(user)).length;
            return selectedCount > 0 && selectedCount < groupUsers.length;
          }

          // Helper to toggle a group (select/deselect all users in that group)
          void toggleGroup(String groupKey, bool selected) {
            setStateDialog(() {
              final groupUsers = groupedUsers[groupKey] ?? [];
              for (final user in groupUsers) {
                if (selected) {
                  if (!isUserSelected(user)) {
                    tempSelected.add(user);
                  }
                } else {
                  tempSelected.removeWhere((selected) =>
                      selected.id == user.id && selected.userType == user.userType);
                }
              }
            });
          }

          // Helper to toggle a single user
          void toggleUser(UserView user, bool selected) {
            setStateDialog(() {
              if (selected) {
                if (!isUserSelected(user)) {
                  tempSelected.add(user);
                }
              } else {
                tempSelected.removeWhere((selected) =>
                    selected.id == user.id && selected.userType == user.userType);
              }
            });
          }

          return Dialog(
            insetPadding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700, maxHeight: 500),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Users',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${tempSelected.length} selected',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _isLoadingUsers
                          ? const Center(child: CircularProgressIndicator())
                          : groupedUsers.isEmpty
                              ? const Center(
                                  child: Text('No users with valid types found'),
                                )
                              : ListView.builder(
                                  itemCount: groupKeys.length,
                                  itemBuilder: (context, index) {
                                    final groupKey = groupKeys[index];
                                    final groupUsers = groupedUsers[groupKey]!;
                                    final groupSelected = isGroupSelected(groupKey);
                                    final groupPartial = isGroupPartiallySelected(groupKey);

                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ExpansionTile(
                                        initiallyExpanded: true,
                                        title: Row(
                                          children: [
                                            Checkbox(
                                              value: groupSelected,
                                              tristate: groupPartial,
                                              onChanged: (value) {
                                                toggleGroup(groupKey, value ?? false);
                                              },
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              groupKey,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${groupUsers.length} users',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        children: groupUsers.map((user) {
                                          final isSelected = isUserSelected(user);
                                          return CheckboxListTile(
                                            value: isSelected,
                                            title: Text(
                                              user.name ?? 'Unknown',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            subtitle: Text(
                                              user.userType ?? 'No type',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            onChanged: (value) {
                                              toggleUser(user, value ?? false);
                                            },
                                            dense: true,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                          );
                                        }).toList(),
                                      ),
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
                              _selectedUsers = List.from(tempSelected);
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

                  if (!isEditing) ...[
                    Row(
                      children: [
                        Radio<String>(
                          value: 'User Type',
                          groupValue: _selectedSpecificOption,
                          onChanged: (v) {
                            setState(() {
                              _selectedSpecificOption = v!;
                              _selectedAudienceType = null;
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
                              _selectedAudienceType = null;
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
                            child: _buildAudienceDropdown(
                              hint: 'Choose user type',
                              value: _selectedAudienceType,
                              items: _audienceTypes,
                              onChanged: (NoticeType? value) {
                                setState(() {
                                  _selectedAudienceType = value;
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
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
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
                                      Text(user.name ?? 'Unknown'),
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
                                  child:
                                      //
                                      Text(
                                        _selectedFileName ?? 'Choose image',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if (_uploadedImageUrl != null || _uploadedImageUrl?.isNotEmpty == true) ...[
                          const SizedBox(height: 12),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
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
                                  child: Image.network(
                                    _uploadedImageUrl!,
                                    fit: BoxFit.cover,
                                    frameBuilder:
                                        (
                                          context,
                                          child,
                                          frame,
                                          wasSynchronouslyLoaded,
                                        ) {
                                          if (wasSynchronouslyLoaded)
                                            return child;
                                          return AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            child: frame == null
                                                ? const Center(
                                                    child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                    ),
                                                  )
                                                : child,
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                       _uploadedImageUrl = null;
                                      _selectedFileBytes = null;
                                      _selectedFileName = null;
                                    });
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
