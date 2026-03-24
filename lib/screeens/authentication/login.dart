import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vikas_app/bloc_management/authentication/auth_bloc.dart';
import 'package:vikas_app/bloc_management/authentication/auth_event.dart';
import 'package:vikas_app/bloc_management/authentication/auth_state.dart';
import 'package:vikas_app/api_services/network_repos/auth_repository.dart';
import 'package:vikas_app/screeens/models/response/role_response.dart';
import 'package:vikas_app/utils/mixins/ui_mixins.dart';
import 'package:vikas_app/views/layouts/auth_layout.dart';
import 'package:vikas_app/screeens/models/enum/user_type.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  UserType? selectedUserType;
  List<Role> roles = [];

  String? selectedRole;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_resetErrorMessage);
    passwordController.addListener(_resetErrorMessage);
    //_fetchRoles();
  }

  @override
  void dispose() {
    emailController.removeListener(_resetErrorMessage);
    passwordController.removeListener(_resetErrorMessage);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _resetErrorMessage() {}

  void _onChangeShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void _handleCheckLogin(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final mobileNumber = emailController.text.trim();
    final password = passwordController.text;

    context.read<AuthBloc>().add(
      CheckLoginEvent(mobileNumber: mobileNumber, password: password),
    );
  }

  void _handleLoginWithRole(BuildContext context) {
    if (selectedRole == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a role')));
      return;
    }
    context.read<AuthBloc>().add(
      LoginWithRoleEvent(
        mobileNumber: emailController.text.trim(),
        roleName: selectedRole!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          Get.offNamed('/dashboard');
        } else if (state.isPasswordChangeRequired) {
          // Navigate to password change screen
          Get.offNamed(
            '/password-change',
            arguments: {
              'mobileNumber': emailController.text.trim(),
              'userId': state.userId,
              'token': state.token,
            },
          );
        }
      },
      builder: (context, state) {
        return Container(
          color: const Color.fromARGB(255, 205, 88, 29),
          child: AuthLayout(
            child: Padding(
              padding: FxSpacing.all(16),
              child: FxFlex(
                contentPadding: false,
                children: [
                  FxFlexItem(
                    sizes: "lg-6",
                    child: FxResponsive(
                      builder: (_, __, type) {
                        return type == FxScreenMediaType.xxl
                            ? Image.asset(
                                //Images.login[3],
                                'assets/images/student.png',

                                fit: BoxFit.cover,
                                height: 400,
                              )
                            : type == FxScreenMediaType.xl
                            ? Image.asset(
                                //Images.login[3],
                                'assets/images/student.png',

                                fit: BoxFit.cover,
                                height: 400,
                              )
                            : type == FxScreenMediaType.lg
                            ? Image.asset(
                                // Images.login[3],
                                'assets/images/student.png',

                                fit: BoxFit.cover,
                                height: 400,
                              )
                            : const SizedBox();
                      },
                    ),
                  ),

                  FxFlexItem(
                    sizes: "lg-6",
                    child: Padding(
                      padding: FxSpacing.y(10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/vidyaaranayam_logo.png',
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.contain,
                                  ),
                                  FxSpacing.height(5),
                                ],
                              ),
                            ),
                            FxSpacing.height(6),

                            // Normal login form
                            // Mobile Number Field
                            FxText.labelMedium("Mobile Number"),
                            FxSpacing.height(10),

                            TextFormField(
                              controller: emailController,
                              enabled: !state.isLoading,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                labelText: "Mobile Number",
                                labelStyle: FxTextStyle.bodySmall(xMuted: true),
                                prefixIcon: const Icon(
                                  LucideIcons.phone,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.brown.shade300,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.brown,
                                    width: 1.5,
                                  ),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                counterText: "",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Mobile number is required",
                                ),
                                FormBuilderValidators.numeric(
                                  errorText: "Only numbers allowed",
                                ),
                                FormBuilderValidators.minLength(
                                  10,
                                  errorText: "Enter 10 digit mobile number",
                                ),
                                FormBuilderValidators.maxLength(
                                  10,
                                  errorText: "Enter 10 digit mobile number",
                                ),
                              ]),
                            ),

                            FxSpacing.height(16),

                            // Password Field
                            FxText.labelMedium("Password"),
                            FxSpacing.height(10),

                            TextFormField(
                              controller: passwordController,
                              enabled: !state.isLoading,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !showPassword,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: FxTextStyle.bodySmall(xMuted: true),
                                prefixIcon: const Icon(
                                  LucideIcons.lock,
                                  size: 20,
                                ),
                                suffixIcon: InkWell(
                                  onTap: state.isLoading
                                      ? null
                                      : () {
                                          _onChangeShowPassword();
                                        },
                                  child: Icon(
                                    showPassword
                                        ? LucideIcons.eye
                                        : LucideIcons.eyeOff,
                                    size: 20,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.brown.shade300,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.brown,
                                    width: 1.5,
                                  ),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Password is required",
                                ),
                                FormBuilderValidators.minLength(
                                  6,
                                  errorText:
                                      'Password length should be 6 or greater than 6',
                                ),
                              ]),
                            ),

                            FxSpacing.height(16),

                            if (state.isLoginChecked &&
                                state.availableRoles != null) ...[
                              FxText.labelMedium("Select Role"),
                              FxSpacing.height(10),
                              DropdownButtonFormField<String>(
                                value: selectedRole,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.brown.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.brown,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                dropdownColor: Colors.grey.shade100,
                                style: const TextStyle(
                                  color: Colors.brown,
                                  fontSize: 16,
                                ),
                                icon: const Icon(
                                  LucideIcons.chevronDown,
                                  color: Colors.brown,
                                ),
                                items: state.availableRoles!.map((role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    setState(() => selectedRole = value),
                                hint: const Text('Choose role'),
                              ),
                              FxSpacing.height(8),

                              // Optional "Change user" button to reset
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => _resetLogin(context),
                                    child: const Text('Change user'),
                                  ),
                                ],
                              ),
                            ],

                            // Error message (keep as is)
                            if (state.isError && state.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: FxText(
                                  state.errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),

                            FxSpacing.height(10),
                            // Login Button
                            Center(
                              child: FxButton.rounded(
                                onPressed: state.isLoading
                                    ? null
                                    : state.isLoginChecked
                                    ? () => _handleLoginWithRole(context)
                                    : () => _handleCheckLogin(context),
                                elevation: 0,
                                padding: FxSpacing.xy(20, 16),
                                backgroundColor: Colors.brown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (state.isLoading)
                                      const SizedBox(
                                        height: 14,
                                        width: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.2,
                                        ),
                                      ),
                                    if (state.isLoading) FxSpacing.width(16),
                                    FxText.bodySmall(
                                      state.isLoginChecked
                                          ? (selectedRole == null
                                                ? 'Select a role'
                                                : 'Login as $selectedRole')
                                          : 'Login',
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
 void _resetLogin(BuildContext context) {
  context.read<AuthBloc>().add(ResetAuthEvent());
  setState(() => selectedRole = null);
}
}
