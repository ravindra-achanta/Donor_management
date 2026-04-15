import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/bloc_management/profile/profile_bloc.dart';
import 'package:vikas_app/bloc_management/profile/profile_event.dart';
import 'package:vikas_app/bloc_management/profile/profile_state.dart';
import 'package:vikas_app/bloc_management/users/user_bloc.dart';
import 'package:vikas_app/bloc_management/users/user_event.dart';
import 'package:vikas_app/bloc_management/users/user_state.dart';
import 'package:vikas_app/screeens/common/backButton.dart';
import 'package:vikas_app/screeens/models/enum/RegistrationType.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/views/layouts/layout.dart';
import 'package:vikas_app/bloc_management/authentication/auth_bloc.dart';
import 'package:vikas_app/bloc_management/authentication/auth_event.dart';
import 'package:vikas_app/bloc_management/authentication/auth_state.dart';
import 'package:vikas_app/api_services/network_repos/auth_repository.dart';
import 'package:vikas_app/screeens/models/request/identity_request.dart';
import 'package:vikas_app/screeens/models/response/role_response.dart';

// ===== Constants =====
class _RegistrationPageConstants {
  static const double borderRadius = 12.0;
  static const double contentPaddingHorizontal = 16.0;
  static const double contentPaddingVertical = 14.0;
  static const double buttonHeight = 45.0;
  static const double buttonBorderRadius = 8.0;
  static const double inputBottomPadding = 18.0;
  static const double dividerThickness = 1.0;
  static const double cardElevation = 5.0;
  static const double cardPadding = 32.0;
  static const double formHorizontalPadding = 24.0;
  static const double formVerticalPadding = 16.0;
  static const double progressIndicatorSize = 20.0;
  static const double progressIndicatorStrokeWidth = 2.0;
  static const double focusedBorderWidth = 1.5;
  static const double iconSize = 18.0;

  static const int mobilePhoneDigits = 10;
  static const int pincodeDigits = 6;
  static const int minDateYear = 2000;
  static const int maxDateYear = 2050;

  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration profileFetchDelay = Duration(milliseconds: 500);
  static const Duration popNavigationDelay = Duration(seconds: 2);

  static const Color primaryButtonColor = Color(0xFF8D6E63);
  static const Color inputFillColor = Color(0xffF7F9FC);
  static const Color focusedBorderColor = Colors.blue;
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;

  static const String successMessage = "User created successfully";
  static const String errorNoUserData =
      'Error: User data not loaded. Please try again.';
  static const String errorSelectRole = 'Please select at least one role';
  static const String dialogSelectRoles = "Select Role(s)";
  static const String buttonDone = "Done";
  static const String buttonRetry = "Retry";
  static const String loadingRoles = 'Loading roles...';
  static const String failedLoadRoles = 'Failed to load roles: ';
  static const String labelStartDate = "Start Date";
  static const String labelRole = "Role";
  static const String hintSelectStartDate = "Select Start Date";
  static const String hintSelectRole = "Select Role(s)";
  static const String hintEnter = "Enter ";
  static const String personalInfo = "Personal Information";
  static const String addressInfo = "Address Information";
  static const String buttonRegister = "Register";
  static const String buttonUpdate = "Update";
  static const String buttonCancel = "Cancel";

  static const String fieldFirstName = "First Name";
  static const String fieldLastName = "Last Name";
  static const String fieldEmail = "Email";
  static const String fieldMobile = "Mobile Number";
  static const String fieldArea = "Area";
  static const String fieldCity = "City";
  static const String fieldState = "State";
  static const String fieldCountry = "Country";
  static const String fieldPincode = "Pincode";

  static const String validationRequired = ' is required';
  static const String validationLettersOnly = ' must contain letters only';
  static const String validationNumbersOnly = ' must contain numbers only';
  static const String validationMobileDigits =
      'Mobile Number must be 10 digits';
  static const String validationPincodeDigits = 'Pincode must be 6 digits';
  static const String validationEmail = 'Enter a valid email';
  static const String validationStartDateRequired = "Start Date is required";

  static const String karyakarthaRole = "KARYAKARTHA";
  static const String rolePattern = r'^[a-zA-Z\s]+$';
  static const String numberPattern = r'^\d+$';
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}

class RegistrationPage extends StatefulWidget {
  final String title;
  final RegistrationType type;
  final User? user;
  final bool isEdit;
  final String? userId;
  final bool fromProfile;
  final bool isSuperAdmin;

  const RegistrationPage({
    super.key,
    required this.title,
    required this.type,
    required this.user,
    this.fromProfile = false,
    this.isEdit = false,
    this.userId,
    this.isSuperAdmin = false,
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController pincodeCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController areaCtrl = TextEditingController();
  final TextEditingController stateCtrl = TextEditingController();
  final TextEditingController countryCtrl = TextEditingController();
  final TextEditingController startDateCtrl = TextEditingController();

  List<Role> selectedRoles = [];
  User? fetchedUser;
  bool isLoadingUser = false;
  bool _isUserLoaded = false;
  bool get _isSuperAdmin => Vikasdb().getString("USER_TYPE") == "SUPER_ADMIN";

  @override
  void initState() {
    super.initState();

    // Check if current user is SUPER_ADMIN using Vikasdb

    if (!widget.fromProfile) {
      context.read<AuthBloc>().add(FetchRolesEventByType());
    }

    if (widget.isEdit && widget.userId != null) {
      isLoadingUser = true;
      Future.delayed(_RegistrationPageConstants.profileFetchDelay, () {
        context.read<UserBloc>().add(
          FetchUsersProfileEvent(userId: widget.userId!),
        );
      });
    } else {
      startDateCtrl.text = _formatDate(DateTime.now());
    }
  }

  void _populateFormFromUser(User user) {
    final nameParts = user.name.split(" ");
    firstNameCtrl.text = nameParts.isNotEmpty ? nameParts.first : "";
    lastNameCtrl.text = nameParts.length > 1
        ? nameParts.sublist(1).join(" ")
        : "";
    emailCtrl.text = user.email ?? "";
    mobileCtrl.text = user.mobileNumber ?? "";
    pincodeCtrl.text = user.pincode ?? "";
    cityCtrl.text = user.city ?? "";
    areaCtrl.text = user.area ?? "";
    stateCtrl.text = user.state ?? "";
    countryCtrl.text = user.country ?? "";
    startDateCtrl.text = user.startedDate ?? _formatDate(DateTime.now());

    selectedRoles.addAll(
      (user.userTypes ?? user.roles ?? []).map(
        (roleName) => Role(id: roleName, roleName: roleName, status: "ACTIVE"),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    pincodeCtrl.dispose();
    cityCtrl.dispose();
    areaCtrl.dispose();
    stateCtrl.dispose();
    countryCtrl.dispose();
    startDateCtrl.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      selectedRoles.clear();
      startDateCtrl.text = _formatDate(DateTime.now());
      fetchedUser = null;
      _isUserLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository: AuthRepository())),
        BlocProvider.value(value: context.read<UserBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.isUserCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.creationMessage ??
                          _RegistrationPageConstants.successMessage,
                    ),
                    backgroundColor: _RegistrationPageConstants.successColor,
                    duration: _RegistrationPageConstants.snackBarDuration,
                  ),
                );
                Future.delayed(
                  _RegistrationPageConstants.profileFetchDelay,
                  () {
                    _clearForm();
                    context.read<AuthBloc>().add(CheckAuthStatusEvent());
                    if (widget.type == RegistrationType.karyakartha) {
                      Get.toNamed('/karyakarthas');
                    } else {
                      Get.toNamed('/users');
                    }
                  },
                );
              }
              if (state.isError && state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: _RegistrationPageConstants.errorColor,
                    duration: _RegistrationPageConstants.snackBarDuration,
                  ),
                );
              }
            },
          ),

          BlocListener<UserBloc, UserState?>(
            listener: (context, state) {
              if (state?.profileLoading == true) {
                setState(() => isLoadingUser = true);
              } else if (state?.profileLoading == false &&
                  state?.user != null &&
                  !_isUserLoaded) {
                setState(() {
                  fetchedUser = state!.user;
                  isLoadingUser = false;
                  _isUserLoaded = true;
                  _populateFormFromUser(fetchedUser!);
                });

                final authState = context.read<AuthBloc>().state;
                if (!widget.fromProfile &&
                    !authState.isLoadingRoles &&
                    authState.typeBasedRoles.isNotEmpty) {
                  _populateRolesFromUser(
                    fetchedUser!,
                    authState.typeBasedRoles,
                  );
                }
              } else if (state?.profileErrorMsg != null && !_isUserLoaded) {
                setState(() => isLoadingUser = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state!.profileErrorMsg!),
                    backgroundColor: _RegistrationPageConstants.errorColor,
                  ),
                );
                Future.delayed(
                  _RegistrationPageConstants.popNavigationDelay,
                  () => Navigator.pop(context),
                );
              }
            },
          ),

          // BlocListener<ProfileBloc, ProfileState?>(
          //   listener: (context, state) {
          //     if (state?.errorMessage != null) {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text(state!.errorMessage!),
          //           backgroundColor: _RegistrationPageConstants.errorColor,
          //           duration: const Duration(seconds: 3),
          //         ),
          //       );
          //     }
          //   },
          // ),
          BlocListener<ProfileBloc, ProfileState?>(
            listener: (context, state) {
              // Show error when update fails
              if (state?.status == ProfileStatus.error &&
                  state?.profileErrorMsg != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state!.profileErrorMsg!),
                    backgroundColor: _RegistrationPageConstants.errorColor,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
              // Show success and navigate when update succeeds
              else if (state?.status == ProfileStatus.updated &&
                  state?.successMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state!.successMessage!),
                    backgroundColor: _RegistrationPageConstants.successColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
                Future.delayed(const Duration(milliseconds: 800), () {
                  if (mounted) {
                    widget.fromProfile
                        ? Get.toNamed('/profile')
                        : widget.type == RegistrationType.user
                        ? Get.toNamed('/users')
                        : Get.toNamed('/karyakarthas');
                  }
                });
              }
            },
          ),
        ],
        child: _RegistrationFormContent(
          title: widget.title,
          type: widget.type,
          formKey: _formKey,
          firstNameCtrl: firstNameCtrl,
          lastNameCtrl: lastNameCtrl,
          emailCtrl: emailCtrl,
          mobileCtrl: mobileCtrl,
          pincodeCtrl: pincodeCtrl,
          cityCtrl: cityCtrl,
          areaCtrl: areaCtrl,
          stateCtrl: stateCtrl,
          countryCtrl: countryCtrl,
          startDateCtrl: startDateCtrl,
          selectedRoles: selectedRoles,
          onRolesUpdated: (List<Role> updatedList) {
            setState(() {
              selectedRoles = updatedList;
            });
          },
          onClearForm: _clearForm,
          user: widget.user,
          fetchedUser: fetchedUser,
          isEdit: widget.isEdit,
          isLoadingUser: isLoadingUser,
          fromProfile: widget.fromProfile,
          isSuperAdmin: _isSuperAdmin,
        ),
      ),
    );
  }

  void _populateRolesFromUser(User user, List<Role> availableRoles) {
    final userRoleNames = user.userTypes ?? user.roles ?? [];

    if (userRoleNames.isEmpty || availableRoles.isEmpty) {
      return;
    }

    final matchedRoles = availableRoles.where((role) {
      return userRoleNames.any(
        (name) => name.toUpperCase() == role.roleName.toUpperCase(),
      );
    }).toList();

    if (matchedRoles.isNotEmpty) {
      setState(() => selectedRoles = matchedRoles);
    }
  }
}

class _RegistrationFormContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String title;
  final User? user;
  final User? fetchedUser;
  final bool isEdit;
  final bool isLoadingUser;
  final bool fromProfile;
  final bool isSuperAdmin;

  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController mobileCtrl;
  final TextEditingController pincodeCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController areaCtrl;
  final TextEditingController stateCtrl;
  final TextEditingController countryCtrl;
  final TextEditingController startDateCtrl;
  final List<Role> selectedRoles;
  final Function(List<Role>) onRolesUpdated;
  final VoidCallback onClearForm;
  final dynamic type;

  const _RegistrationFormContent({
    required this.title,
    required this.type,
    required this.user,
    required this.fetchedUser,
    required this.isEdit,
    required this.isLoadingUser,
    required this.formKey,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.emailCtrl,
    required this.mobileCtrl,
    required this.pincodeCtrl,
    required this.cityCtrl,
    required this.areaCtrl,
    required this.stateCtrl,
    required this.countryCtrl,
    required this.startDateCtrl,
    required this.selectedRoles,
    required this.onRolesUpdated,
    required this.onClearForm,
    required this.fromProfile,
    required this.isSuperAdmin,
  });

  @override
  State<_RegistrationFormContent> createState() =>
      _RegistrationFormContentState();
}

class _RegistrationFormContentState extends State<_RegistrationFormContent> {
  late TextEditingController roleController;

  @override
  void initState() {
    super.initState();
    roleController = TextEditingController();
    if (!widget.fromProfile) {
      context.read<AuthBloc>().add(FetchRolesEventByType());
    }
  }

  @override
  void dispose() {
    roleController.dispose();
    super.dispose();
  }

  void _updateRoleField() {
    roleController.text = widget.selectedRoles.isNotEmpty
        ? widget.selectedRoles.map((e) => e.displayName).join(", ")
        : "";
  }

  List<String> _getCurrentDisplayRoles() {
    if (widget.selectedRoles.isNotEmpty) {
      return widget.selectedRoles.map((e) => e.displayName).toList();
    } else if (widget.isEdit && widget.fetchedUser != null) {
      final fetchedRoles =
          widget.fetchedUser!.userTypes ?? widget.fetchedUser!.roles ?? [];
      return fetchedRoles.cast<String>().toList();
    }
    return [];
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool lettersOnly = false,
    bool numbersOnly = false,
    bool isLoading = false,
    IconData? icon,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: _RegistrationPageConstants.inputBottomPadding,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled && !isLoading && !widget.isLoadingUser,
        inputFormatters: [
          if (lettersOnly)
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          if (numbersOnly) FilteringTextInputFormatter.digitsOnly,
        ],
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: _buildInputDecoration(
          label: label,
          icon: icon,
          enabled: enabled,
        ),
        validator: (value) =>
            _validateInput(value, label, lettersOnly, numbersOnly),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    IconData? icon,
    required bool enabled,
  }) {
    final borderSide = BorderSide(color: Colors.grey.shade300);

    return InputDecoration(
      labelText: label,
      hintText: "${_RegistrationPageConstants.hintEnter}$label",
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade600) : null,
      filled: true,
      fillColor: !enabled
          ? Colors.grey[200]
          : _RegistrationPageConstants.inputFillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: _RegistrationPageConstants.contentPaddingHorizontal,
        vertical: _RegistrationPageConstants.contentPaddingVertical,
      ),
      border: _buildOutlineInputBorder(borderSide),
      enabledBorder: _buildOutlineInputBorder(borderSide),
      focusedBorder: _buildOutlineInputBorder(
        const BorderSide(
          color: _RegistrationPageConstants.focusedBorderColor,
          width: _RegistrationPageConstants.focusedBorderWidth,
        ),
      ),
      errorBorder: _buildOutlineInputBorder(
        const BorderSide(color: _RegistrationPageConstants.errorColor),
      ),
      focusedErrorBorder: _buildOutlineInputBorder(
        const BorderSide(
          color: _RegistrationPageConstants.errorColor,
          width: _RegistrationPageConstants.focusedBorderWidth,
        ),
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder(BorderSide borderSide) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        _RegistrationPageConstants.borderRadius,
      ),
      borderSide: borderSide,
    );
  }

  String? _validateInput(
    String? value,
    String label,
    bool lettersOnly,
    bool numbersOnly,
  ) {
    if (widget.isEdit) return null;

    // Required field validation
    if (_isRequiredField(label)) {
      if (value == null || value.trim().isEmpty) {
        return '$label${_RegistrationPageConstants.validationRequired}';
      }
    }

    // Letters only validation
    if (lettersOnly &&
        value != null &&
        value.trim().isNotEmpty &&
        !RegExp(
          _RegistrationPageConstants.rolePattern,
        ).hasMatch(value.trim())) {
      return '$label${_RegistrationPageConstants.validationLettersOnly}';
    }

    // Numbers only validation
    if (numbersOnly &&
        value != null &&
        value.trim().isNotEmpty &&
        !RegExp(
          _RegistrationPageConstants.numberPattern,
        ).hasMatch(value.trim())) {
      return '$label${_RegistrationPageConstants.validationNumbersOnly}';
    }

    // Mobile number validation
    if (label == _RegistrationPageConstants.fieldMobile &&
        value != null &&
        value.trim().length != _RegistrationPageConstants.mobilePhoneDigits) {
      return _RegistrationPageConstants.validationMobileDigits;
    }

    // Pincode validation
    if (label == _RegistrationPageConstants.fieldPincode &&
        value != null &&
        value.trim().isNotEmpty &&
        value.trim().length != _RegistrationPageConstants.pincodeDigits) {
      return _RegistrationPageConstants.validationPincodeDigits;
    }

    // Email validation
    if (label == _RegistrationPageConstants.fieldEmail &&
        value != null &&
        value.trim().isNotEmpty &&
        !RegExp(
          _RegistrationPageConstants.emailPattern,
        ).hasMatch(value.trim())) {
      return _RegistrationPageConstants.validationEmail;
    }

    return null;
  }

  bool _isRequiredField(String label) {
    return label == _RegistrationPageConstants.fieldFirstName ||
        label == _RegistrationPageConstants.fieldLastName ||
        label == _RegistrationPageConstants.fieldMobile;
  }

  Widget _registerButton(BuildContext context, bool isLoading) {
    return Expanded(
      child: SizedBox(
        height: _RegistrationPageConstants.buttonHeight,
        child: ElevatedButton(
          onPressed: isLoading || widget.isLoadingUser
              ? null
              : () => _submit(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: _RegistrationPageConstants.primaryButtonColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                _RegistrationPageConstants.buttonBorderRadius,
              ),
            ),
            elevation: 3,
          ),
          child: isLoading || widget.isLoadingUser
              ? const SizedBox(
                  height: _RegistrationPageConstants.progressIndicatorSize,
                  width: _RegistrationPageConstants.progressIndicatorSize,
                  child: CircularProgressIndicator(
                    strokeWidth:
                        _RegistrationPageConstants.progressIndicatorStrokeWidth,
                    color: Colors.white,
                  ),
                )
              : Text(
                  widget.isEdit
                      ? _RegistrationPageConstants.buttonUpdate
                      : _RegistrationPageConstants.buttonRegister,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _cancelButton(BuildContext context, bool isLoading) {
    return Expanded(
      child: SizedBox(
        height: _RegistrationPageConstants.buttonHeight,
        child: ElevatedButton(
          onPressed: isLoading || widget.isLoadingUser
              ? null
              : () => _cancel(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                _RegistrationPageConstants.buttonBorderRadius,
              ),
              side: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
            elevation: 1,
          ),
          child: const Text(
            _RegistrationPageConstants.buttonCancel,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!widget.formKey.currentState!.validate()) return;

    if (widget.isEdit) {
      final userToUpdate = widget.fetchedUser ?? widget.user;
      if (userToUpdate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(_RegistrationPageConstants.errorNoUserData),
            backgroundColor: _RegistrationPageConstants.errorColor,
          ),
        );
        return;
      }

      final updatedRoles = widget.fromProfile
          ? (userToUpdate.userTypes ?? userToUpdate.roles)
          : (widget.selectedRoles.isNotEmpty
                ? widget.selectedRoles.map((role) => role.id).toList()
                : userToUpdate.roles);

      final updatedUser = User(
        id: userToUpdate.id,
        name:
            "${widget.firstNameCtrl.text.trim()} ${widget.lastNameCtrl.text.trim()}",
        email: widget.emailCtrl.text.trim(),
        mobileNumber: widget.mobileCtrl.text.trim(),
        status: userToUpdate.status ?? "",
        roles: updatedRoles,
        pincode: widget.pincodeCtrl.text.trim(),
        city: widget.cityCtrl.text.trim(),
        area: widget.areaCtrl.text.trim(),
        state: widget.stateCtrl.text.trim(),
        country: widget.countryCtrl.text.trim(),
      );
      if (widget.fromProfile) {
        context.read<ProfileBloc>().add(
          UpdateProfileInfo(id: userToUpdate.id, user: updatedUser),
        );
      } else {
        context.read<ProfileBloc>().add(
          UpdateProfile(id: userToUpdate.id, user: updatedUser),
        );
      }
      // Navigation will happen in ProfileBloc listener after successful update
    } else {
      if (widget.selectedRoles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(_RegistrationPageConstants.errorSelectRole),
            backgroundColor: _RegistrationPageConstants.warningColor,
          ),
        );
        return;
      }

      // final List<int> roleIds = widget.selectedRoles
      //     .map((role) => int.parse(role.id))
      //     .toList();
      final List<int> roleIds = widget.selectedRoles.isNotEmpty
          ? widget.selectedRoles.map((role) => int.parse(role.id)).toList()
          : [];

      final request = IdentityRequest(
        name:
            "${widget.firstNameCtrl.text.trim()} ${widget.lastNameCtrl.text.trim()}",
        email: widget.emailCtrl.text.trim(),
        mobileNumber: widget.mobileCtrl.text.trim(),
        roles: roleIds,
        startedDate: widget.startDateCtrl.text.trim(),
        pincode: widget.pincodeCtrl.text.trim(),
        city: widget.cityCtrl.text.trim(),
        area: widget.areaCtrl.text.trim(),
        state: widget.stateCtrl.text.trim(),
        country: widget.countryCtrl.text.trim(),
      );

      context.read<AuthBloc>().add(CreateUserEvent(request: request));
    }
  }

  void _cancel(BuildContext context) {
    widget.onClearForm();
    Navigator.pop(context);
  }

  Widget _startDateField(bool isLoading, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: _RegistrationPageConstants.inputBottomPadding,
      ),
      child: TextFormField(
        controller: widget.startDateCtrl,
        readOnly: true,
        enabled: !isLoading && !widget.isLoadingUser,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: _RegistrationPageConstants.labelStartDate,
          hintText: _RegistrationPageConstants.hintSelectStartDate,
          prefixIcon: const Icon(Icons.event, color: Colors.grey),
          filled: true,
          fillColor: _RegistrationPageConstants.inputFillColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: _RegistrationPageConstants.contentPaddingHorizontal,
            vertical: _RegistrationPageConstants.contentPaddingVertical,
          ),
          border: _buildOutlineInputBorder(
            BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: _buildOutlineInputBorder(
            BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: _buildOutlineInputBorder(
            const BorderSide(
              color: _RegistrationPageConstants.focusedBorderColor,
              width: _RegistrationPageConstants.focusedBorderWidth,
            ),
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(
                _RegistrationPageConstants.buttonBorderRadius,
              ),
            ),
            child: const Icon(
              Icons.calendar_today,
              size: _RegistrationPageConstants.iconSize,
            ),
          ),
        ),
        onTap: isLoading || widget.isLoadingUser
            ? null
            : () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(_RegistrationPageConstants.minDateYear),
                  lastDate: DateTime(_RegistrationPageConstants.maxDateYear),
                );
                if (pickedDate != null) {
                  widget.startDateCtrl.text = _formatDate(pickedDate);
                }
              },
        validator: (value) => value == null || value.isEmpty
            ? _RegistrationPageConstants.validationStartDateRequired
            : null,
      ),
    );
  }

  Widget _multiSelectRoleField(
    bool isLoading,
    BuildContext context,
    List<Role> allRoles,
  ) {
    final isKaryakartha = widget.type == RegistrationType.karyakartha;
    final displayRoles = _getCurrentDisplayRoles();

    // Update controller whenever this rebuilds
    _updateRoleField();

    return Padding(
      padding: const EdgeInsets.only(
        bottom: _RegistrationPageConstants.inputBottomPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap:
                (isLoading ||
                    isKaryakartha ||
                    widget.isLoadingUser ||
                    widget.fromProfile)
                ? null
                : () => _showRoleSelectionSheet(context, allRoles),
            child: AbsorbPointer(
              child: TextFormField(
                readOnly: true,
                enabled:
                    !isLoading && !widget.isLoadingUser && !widget.fromProfile,
                controller: roleController,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: _RegistrationPageConstants.labelRole,
                  hintText: _RegistrationPageConstants.hintSelectRole,
                  prefixIcon: const Icon(Icons.badge, color: Colors.grey),
                  filled: true,
                  fillColor: (isKaryakartha || widget.fromProfile)
                      ? Colors.grey[200]
                      : _RegistrationPageConstants.inputFillColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal:
                        _RegistrationPageConstants.contentPaddingHorizontal,
                    vertical: _RegistrationPageConstants.contentPaddingVertical,
                  ),
                  border: _buildOutlineInputBorder(
                    BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: _buildOutlineInputBorder(
                    BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: _buildOutlineInputBorder(
                    const BorderSide(
                      color: _RegistrationPageConstants.focusedBorderColor,
                      width: _RegistrationPageConstants.focusedBorderWidth,
                    ),
                  ),
                  suffixIcon: (isKaryakartha || widget.fromProfile)
                      ? const Icon(
                          Icons.lock,
                          size: _RegistrationPageConstants.iconSize,
                        )
                      : const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ),
          ),
          // Display roles as chips if more than 2 roles
          if (displayRoles.length > 2)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: displayRoles
                    .map(
                      (role) => Chip(
                        label: Text(role),
                        backgroundColor: Colors.blue[50],
                        labelStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  // Future<void> _showRoleSelectionSheet(
  //   BuildContext context,
  //   List<Role> allRoles,
  // ) async {
  //   final bool enforceSequential = !widget.isEdit && widget.isSuperAdmin;
  //   await showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setModalState) {
  //           return DraggableScrollableSheet(
  //             initialChildSize: 0.35,
  //             minChildSize: 0.25,
  //             maxChildSize: 0.6,
  //             expand: false,
  //             builder: (_, controller) {
  //               return Container(
  //                 padding: const EdgeInsets.all(20),
  //                 decoration: const BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.vertical(
  //                     top: Radius.circular(20),
  //                   ),
  //                 ),
  //                 child: ListView(
  //                   controller: controller,
  //                   children: [
  //                     const Center(
  //                       child: Text(
  //                         _RegistrationPageConstants.dialogSelectRoles,
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 16),
  //                     ...allRoles.map((role) {
  //                       final isSelected = widget.selectedRoles.any(
  //                         (r) => r.id == role.id,
  //                       );
  //                       return CheckboxListTile(
  //                         dense: true,
  //                         title: Text(role.displayName),
  //                         value: isSelected,
  //                         onChanged: (val) {
  //                           setModalState(() {
  //                             final updatedList = List<Role>.from(
  //                               widget.selectedRoles,
  //                             );
  //                             if (val == true) {
  //                               updatedList.add(role);
  //                             } else {
  //                               updatedList.removeWhere((r) => r.id == role.id);
  //                             }
  //                             widget.onRolesUpdated(updatedList);
  //                           });
  //                         },
  //                       );
  //                     }).toList(),
  //                     const SizedBox(height: 10),
  //                     ElevatedButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       child: const Text(
  //                         _RegistrationPageConstants.buttonDone,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  Future<void> _showRoleSelectionSheet(
    BuildContext context,
    List<Role> allRoles,
  ) async {
    final bool enforceSequential = widget.isSuperAdmin && !widget.isEdit;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            bool isAdminSelected() => widget.selectedRoles.any(
              (role) => role.displayName.toUpperCase() == "ADMIN",
            );

            List<Role> displayedRoles;
            if (enforceSequential && !isAdminSelected()) {
              // Show only Admin role
              displayedRoles = allRoles
                  .where((role) => role.displayName.toUpperCase() == "ADMIN")
                  .toList();
            } else {
              displayedRoles = allRoles;
            }

            return DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.25,
              maxChildSize: 0.6,
              expand: false,
              builder: (_, controller) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: ListView(
                    controller: controller,
                    children: [
                      const Center(
                        child: Text(
                          _RegistrationPageConstants.dialogSelectRoles,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...displayedRoles.map((role) {
                        final isAdminRole =
                            role.displayName.toUpperCase() == "ADMIN";
                        final isSelected = widget.selectedRoles.any(
                          (r) => r.id == role.id,
                        );

                        bool isEnabled = true;

                        return CheckboxListTile(
                          dense: true,
                          title: Text(role.displayName),
                          value: isSelected,
                          enabled: isEnabled,
                          // onChanged: (val) {
                          //   setModalState(() {
                          //     final updatedList = List<Role>.from(
                          //       widget.selectedRoles,
                          //     );
                          //     if (val == true) {
                          //       updatedList.add(role);
                          //     } else {
                          //       updatedList.removeWhere((r) => r.id == role.id);

                          //       if (enforceSequential && isAdminRole) {
                          //         updatedList.removeWhere(
                          //           (r) =>
                          //               r.displayName.toUpperCase() != "ADMIN",
                          //         );
                          //       }
                          //     }
                          //     widget.onRolesUpdated(updatedList);
                          //   });
                          // },
                          onChanged: (val) {
                            setModalState(() {
                              final updatedList = List<Role>.from(
                                widget.selectedRoles,
                              );
                              if (val == true) {
                                // Check if role already exists before adding
                                if (!updatedList.any((r) => r.id == role.id)) {
                                  updatedList.add(role);
                                }
                              } else {
                                updatedList.removeWhere((r) => r.id == role.id);

                                if (enforceSequential && isAdminRole) {
                                  updatedList.removeWhere(
                                    (r) =>
                                        r.displayName.toUpperCase() != "ADMIN",
                                  );
                                }
                              }
                              widget.onRolesUpdated(updatedList);
                            });
                          },
                        );
                      }).toList(),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          _RegistrationPageConstants.buttonDone,
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     if (widget.selectedRoles.isEmpty) {
                      //       // Show error message
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(
                      //           content: Text(
                      //             _RegistrationPageConstants.errorSelectRole,
                      //           ),
                      //           backgroundColor:
                      //               _RegistrationPageConstants.warningColor,
                      //           duration: Duration(seconds: 2),
                      //         ),
                      //       );
                      //     } else {
                      //       // Close dialog if at least one role is selected
                      //       Navigator.pop(context);
                      //     }
                      //   },
                      //   child: const Text(
                      //     _RegistrationPageConstants.buttonDone,
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isWideScreen = MediaQuery.of(context).size.width > 700;
        final isLoading = state.isCreatingUser || state.isLoadingRoles;
        final roles = state.typeBasedRoles;

        // Auto-select karyakartha role
        if (widget.type == RegistrationType.karyakartha &&
            roles.isNotEmpty &&
            widget.selectedRoles.isEmpty) {
          final karyakarthaRole = roles.firstWhere(
            (r) =>
                r.displayName.toUpperCase() ==
                _RegistrationPageConstants.karyakarthaRole,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onRolesUpdated([karyakarthaRole]);
          });
        }

        if (state.isLoadingRoles && roles.isEmpty) {
          return Layout(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(_RegistrationPageConstants.loadingRoles),
                ],
              ),
            ),
          );
        }

        if (!state.isLoadingRoles &&
            roles.isEmpty &&
            state.errorMessage != null) {
          return Layout(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_RegistrationPageConstants.failedLoadRoles}${state.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _RegistrationPageConstants.errorColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<AuthBloc>().add(FetchRolesEvent()),
                      child: const Text(_RegistrationPageConstants.buttonRetry),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return _buildRegistrationForm(context, isWideScreen, isLoading, roles);
      },
    );
  }

  Widget _buildRegistrationForm(
    BuildContext context,
    bool isWideScreen,
    bool isLoading,
    List<Role> roles,
  ) {
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
          padding: const EdgeInsets.symmetric(
            horizontal: _RegistrationPageConstants.formHorizontalPadding,
            vertical: _RegistrationPageConstants.formVerticalPadding,
          ),
          child: Card(
            elevation: _RegistrationPageConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                _RegistrationPageConstants.borderRadius,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(
                _RegistrationPageConstants.cardPadding,
              ),
              child: Form(
                key: widget.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Backbutton().buildBackButton(context, ""),
                    const SizedBox(width: 10),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: _RegistrationPageConstants.dividerThickness,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      _RegistrationPageConstants.personalInfo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    rowFields(
                      _input(
                        widget.firstNameCtrl,
                        _RegistrationPageConstants.fieldFirstName,
                        lettersOnly: true,
                        isLoading: isLoading,
                      ),
                      _input(
                        widget.lastNameCtrl,
                        _RegistrationPageConstants.fieldLastName,
                        lettersOnly: true,
                        isLoading: isLoading,
                      ),
                    ),
                    rowFields(
                      _input(
                        widget.emailCtrl,
                        _RegistrationPageConstants.fieldEmail,
                        keyboardType: TextInputType.emailAddress,
                        isLoading: isLoading,
                      ),
                      _input(
                        widget.mobileCtrl,
                        _RegistrationPageConstants.fieldMobile,
                        keyboardType: TextInputType.phone,
                        numbersOnly: true,
                        isLoading: isLoading,
                        enabled: !widget.isEdit,
                      ),
                    ),

                    rowFields(
                      _multiSelectRoleField(isLoading, context, roles),
                      _startDateField(isLoading, context),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      _RegistrationPageConstants.addressInfo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    rowFields(
                      _input(
                        widget.areaCtrl,
                        _RegistrationPageConstants.fieldArea,
                        lettersOnly: true,
                        isLoading: isLoading,
                      ),
                      _input(
                        widget.cityCtrl,
                        _RegistrationPageConstants.fieldCity,
                        lettersOnly: true,
                        isLoading: isLoading,
                      ),
                    ),
                    rowFields(
                      _input(
                        widget.stateCtrl,
                        _RegistrationPageConstants.fieldState,
                        lettersOnly: true,
                        isLoading: isLoading,
                      ),
                      _input(
                        widget.countryCtrl,
                        _RegistrationPageConstants.fieldCountry,
                        lettersOnly: true,
                        isLoading: isLoading,
                      ),
                    ),
                    rowFields(
                      _input(
                        widget.pincodeCtrl,
                        _RegistrationPageConstants.fieldPincode,
                        keyboardType: TextInputType.number,
                        numbersOnly: true,
                        isLoading: isLoading,
                      ),
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
                                  _cancelButton(context, isLoading),
                                  const SizedBox(width: 16),
                                  _registerButton(context, isLoading),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _registerButton(context, isLoading),
                                  const SizedBox(height: 12),
                                  _cancelButton(context, isLoading),
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
}
