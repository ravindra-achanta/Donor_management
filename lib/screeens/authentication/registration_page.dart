import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/profile/profile_bloc.dart';
import 'package:vikas_app/bloc_management/profile/profile_event.dart';
import 'package:vikas_app/screeens/models/enum/RegistrationType.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/views/layouts/layout.dart';
import 'package:vikas_app/bloc_management/authentication/auth_bloc.dart';
import 'package:vikas_app/bloc_management/authentication/auth_event.dart';
import 'package:vikas_app/bloc_management/authentication/auth_state.dart';
import 'package:vikas_app/api_services/network_repos/auth_repository.dart';
import 'package:vikas_app/screeens/models/request/identity_request.dart';
import 'package:vikas_app/screeens/models/response/role_response.dart';

class RegistrationPage extends StatefulWidget {
  //const RegistrationPage({super.key});
  final String title;
  final RegistrationType type;
  final User? user;
  final bool isEdit;

  const RegistrationPage({
    super.key,
    required this.title,
    required this.type,
    required this.user,
    this.isEdit = false,
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

  @override
  // void initState() {
  //   super.initState();
  //   startDateCtrl.text = _formatDate(DateTime.now());
  // }
  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.user != null) {
      final nameParts = widget.user!.name.split(" ");

      firstNameCtrl.text = nameParts.isNotEmpty ? nameParts.first : "";

      lastNameCtrl.text = nameParts.length > 1
          ? nameParts.sublist(1).join(" ")
          : "";

      emailCtrl.text = widget.user!.email ?? "";
      mobileCtrl.text = widget.user!.mobileNumber ?? "";
      pincodeCtrl.text = widget.user!.pincode ?? "";
      cityCtrl.text = widget.user!.city ?? "";
      areaCtrl.text = widget.user!.area ?? "";
      stateCtrl.text = widget.user!.state ?? "";
      countryCtrl.text = widget.user!.country ?? "";
      startDateCtrl.text =
          widget.user!.startedDate ?? _formatDate(DateTime.now());
    } else {
      startDateCtrl.text = _formatDate(DateTime.now());
    }
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
    });
  }

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    //   create: (_) => AuthBloc(authRepository: AuthRepository()),
    //   child: _RegistrationFormContent(
          return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(authRepository: AuthRepository()),
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
        isEdit: widget.isEdit,
      ),
    );
  }
}

class _RegistrationFormContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String title;
  final User? user;
  final bool isEdit;

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
    required this.isEdit,

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
  });

  @override
  State<_RegistrationFormContent> createState() =>
      _RegistrationFormContentState();
}

class _RegistrationFormContentState extends State<_RegistrationFormContent> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(FetchRolesEvent());
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: !isLoading,
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
        // validator: (value) {
        //   if (value == null || value.trim().isEmpty)
        //     return '$label is required';
        //   if (lettersOnly && !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
        //     return '$label must contain letters only';
        //   }
        //   if (numbersOnly && !RegExp(r'^\d+$').hasMatch(value.trim())) {
        //     return '$label must contain numbers only';
        //   }
        //   if (label == "Mobile Number" && value.trim().length != 10) {
        //     return 'Mobile Number must be 10 digits';
        //   }
        //   if (label == "Pincode" && value.trim().length != 6) {
        //     return 'Pincode must be 6 digits';
        //   }
        //   if (label == "Email" &&
        //       !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
        //     return 'Enter a valid email';
        //   }
        //   return null;
        // },
        validator: (value) {
          if (widget.isEdit) return null;

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

  Widget _registerButton(BuildContext context, bool isLoading) {
    return Expanded(
      child: SizedBox(
        height: 45,
        child: ElevatedButton(
          onPressed: isLoading ? null : () => _submit(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8D6E63),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 3,
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              :
                //  const Text(
                //     "Register",
                //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                //   ),
                Text(
                  widget.isEdit ? "Update" : "Register",
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
        height: 45,
        child: ElevatedButton(
          onPressed: isLoading ? null : () => _cancel(context),
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // void _submit(BuildContext context) {
  //   if (!widget.formKey.currentState!.validate()) return;

  //   if (widget.selectedRoles.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please select at least one role'),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //     return;
  //   }

  //   final List<int> roleIds = widget.selectedRoles
  //       .map((role) => int.parse(role.id))
  //       .toList();

  //   final request = IdentityRequest(
  //     name: "${widget.firstNameCtrl.text.trim()} ${widget.lastNameCtrl.text.trim()}",
  //     email: widget.emailCtrl.text.trim(),
  //     mobileNumber: widget.mobileCtrl.text.trim(),
  //     roles: roleIds,
  //     startedDate: widget.startDateCtrl.text.trim(),
  //     pincode: widget.pincodeCtrl.text.trim(),
  //     city: widget.cityCtrl.text.trim(),
  //     area: widget.areaCtrl.text.trim(),
  //     state: widget.stateCtrl.text.trim(),
  //     country: widget.countryCtrl.text.trim(),
  //   );

  //   context.read<AuthBloc>().add(CreateUserEvent(request: request));
  // }
void _submit(BuildContext context) {
  if (!widget.formKey.currentState!.validate()) return;

  if (widget.isEdit) {
    final updatedUser = User(
      id: widget.user!.id,
      name:
          "${widget.firstNameCtrl.text.trim()} ${widget.lastNameCtrl.text.trim()}",
      email: widget.emailCtrl.text.trim(),
      mobileNumber: widget.mobileCtrl.text.trim(),
      status: widget.user!.status,
      userType: widget.user!.userType,
      uniqueId: widget.user!.uniqueId,
      pincode: widget.pincodeCtrl.text.trim(),
      city: widget.cityCtrl.text.trim(),
      area: widget.areaCtrl.text.trim(),
      state: widget.stateCtrl.text.trim(),
      country: widget.countryCtrl.text.trim(),
      startedDate: widget.startDateCtrl.text.trim(),
    );

    context.read<ProfileBloc>().add(
      UpdateProfile(id: widget.user!.id, user: updatedUser),
    );
    print("navigating to users");
    Get.toNamed('/users');
  } else {

    if (widget.selectedRoles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one role'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final List<int> roleIds = widget.selectedRoles
        .map((role) => int.parse(role.id))
        .toList();

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
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: widget.startDateCtrl,
        readOnly: true,
        enabled: !isLoading,
        decoration: InputDecoration(
          labelText: "Start Date",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onTap: isLoading
            ? null
            : () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2050),
                );
                if (pickedDate != null) {
                  widget.startDateCtrl.text = _formatDate(pickedDate);
                }
              },
        validator: (value) =>
            value == null || value.isEmpty ? "Start Date is required" : null,
      ),
    );
  }

  Widget _multiSelectRoleField(
    bool isLoading,
    BuildContext context,
    List<Role> allRoles,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            // onTap: isLoading
            //     ? null
            //     : () async {
            onTap: (isLoading || widget.type == RegistrationType.karyakartha)
                ? null
                : () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setModalState) {
                            return Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Select Role(s)",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ...allRoles.map((role) {
                                      final isSelected = widget.selectedRoles
                                          .any((r) => r.id == role.id);
                                      return CheckboxListTile(
                                        title: Text(role.displayName),
                                        value: isSelected,
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        onChanged: isLoading
                                            ? null
                                            : (val) {
                                                setModalState(() {
                                                  if (val == true) {
                                                    if (!widget.selectedRoles
                                                        .any(
                                                          (r) =>
                                                              r.id == role.id,
                                                        )) {
                                                      final updatedList =
                                                          List<Role>.from(
                                                            widget
                                                                .selectedRoles,
                                                          );
                                                      updatedList.add(role);
                                                      widget.onRolesUpdated(
                                                        updatedList,
                                                      );
                                                    }
                                                  } else {
                                                    final updatedList =
                                                        List<Role>.from(
                                                          widget.selectedRoles,
                                                        );
                                                    updatedList.removeWhere(
                                                      (r) => r.id == role.id,
                                                    );
                                                    widget.onRolesUpdated(
                                                      updatedList,
                                                    );
                                                  }
                                                });
                                              },
                                      );
                                    }).toList(),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Done"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
            child: AbsorbPointer(
              child: TextFormField(
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: "Role",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Select Role(s)",
                  suffixIcon: const Icon(Icons.arrow_drop_down, size: 20),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                // validator: (value) =>
                //     widget.selectedRoles.isEmpty ? 'Select at least 1 role' : null,
                validator: (value) {
                  if (widget.isEdit) return null;
                  return widget.selectedRoles.isEmpty
                      ? 'Select at least 1 role'
                      : null;
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (widget.selectedRoles.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: widget.selectedRoles.map((role) {
                  return Chip(
                    label: Text(role.displayName),
                    onDeleted: isLoading
                        ? null
                        : () {
                            final updatedList = List<Role>.from(
                              widget.selectedRoles,
                            );
                            updatedList.removeWhere((r) => r.id == role.id);
                            widget.onRolesUpdated(updatedList);
                          },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isUserCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.creationMessage ?? "User created successfully",
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            widget.onClearForm();
            context.read<AuthBloc>().add(CheckAuthStatusEvent());
    print("navigating to users");

            Get.toNamed('/users');
          });
        }
        if (state.isError && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isWideScreen = MediaQuery.of(context).size.width > 700;
          final isLoading = state.isCreatingUser || state.isLoadingRoles;
          final roles = state.roles;
          if (widget.type == RegistrationType.karyakartha &&
              roles.isNotEmpty &&
              widget.selectedRoles.isEmpty) {
            final karyakarthaRole = roles.firstWhere(
              (r) => r.displayName.toUpperCase() == "KARYAKARTHA",
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onRolesUpdated([karyakarthaRole]);
            });
          }

          // ✅ Loading indicator
          if (state.isLoadingRoles && roles.isEmpty) {
            return Layout(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading roles...'),
                  ],
                ),
              ),
            );
          }

          // ✅ ERROR HANDLING UI
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
                        'Failed to load roles: ${state.errorMessage}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<AuthBloc>().add(FetchRolesEvent()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

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
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: widget.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Text(
                          //   "Register New User",
                          //   style: TextStyle(
                          //     fontSize: 24,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),
                          const Divider(thickness: 1),
                          const SizedBox(height: 10),
                          const Text(
                            "Personal Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          rowFields(
                            _input(
                              widget.firstNameCtrl,
                              "First Name",
                              lettersOnly: true,
                              isLoading: isLoading,
                            ),
                            _input(
                              widget.lastNameCtrl,
                              "Last Name",
                              lettersOnly: true,
                              isLoading: isLoading,
                            ),
                          ),
                          rowFields(
                            _input(
                              widget.emailCtrl,
                              "Email",
                              keyboardType: TextInputType.emailAddress,
                              isLoading: isLoading,
                            ),
                            _input(
                              widget.mobileCtrl,
                              "Mobile Number",
                              keyboardType: TextInputType.phone,
                              numbersOnly: true,
                              isLoading: isLoading,
                            ),
                          ),
                          rowFields(
                            _multiSelectRoleField(isLoading, context, roles),
                            _startDateField(isLoading, context),
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
                              widget.areaCtrl,
                              "Area",
                              lettersOnly: true,
                              isLoading: isLoading,
                            ),
                            _input(
                              widget.cityCtrl,
                              "City",
                              lettersOnly: true,
                              isLoading: isLoading,
                            ),
                          ),
                          rowFields(
                            _input(
                              widget.stateCtrl,
                              "State",
                              lettersOnly: true,
                              isLoading: isLoading,
                            ),
                            _input(
                              widget.countryCtrl,
                              "Country",
                              lettersOnly: true,
                              isLoading: isLoading,
                            ),
                          ),
                          rowFields(
                            _input(
                              widget.pincodeCtrl,
                              "Pincode",
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
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
        },
      ),
    );
  }
}
