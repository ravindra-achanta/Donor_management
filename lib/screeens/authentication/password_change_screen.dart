import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vikas_app/bloc_management/authentication/auth_bloc.dart';
import 'package:vikas_app/bloc_management/authentication/auth_event.dart';
import 'package:vikas_app/bloc_management/authentication/auth_state.dart';
import 'package:vikas_app/utils/mixins/ui_mixins.dart';
import 'package:vikas_app/views/layouts/auth_layout.dart';

class PasswordChangeScreen extends StatefulWidget {
  final String mobileNumber;
  final String userId;
  final String token;

  const PasswordChangeScreen({
    super.key,
    required this.mobileNumber,
    required this.userId,
    required this.token,
  });

  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  bool showPassword = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(_resetErrorMessage);
    
    // Debug prints to check current AuthBloc state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
    });
    
    // Prevent back navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupNavigationGuard();
    });
  }

  @override
  void dispose() {
    newPasswordController.removeListener(_resetErrorMessage);
    newPasswordController.dispose();
    super.dispose();
  }

  void _resetErrorMessage() {}

  void _setupNavigationGuard() {
    // Override back button behavior
    ModalRoute.of(context)?.addScopedWillPopCallback(() async {
      // Prevent back navigation
      return false;
    });
  }

  void _onChangeShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void _handlePasswordChange(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isNavigating = true);

    context.read<AuthBloc>().add(
      ChangePasswordEvent(
        newPassword: newPasswordController.text,
        mobileNumber: widget.mobileNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation
        return false;
      },
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isAuthenticated) {
              // Only navigate after successful password change
              Get.offNamed('/dashboard');
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
                      // Left side - Image
                      FxFlexItem(
                        sizes: "lg-6",
                        child: FxResponsive(
                          builder: (_, __, type) {
                            return type == FxScreenMediaType.xxl
                                ? Image.asset(
                                    'assets/images/student.png',
                                    fit: BoxFit.cover,
                                    height: 400,
                                  )
                                : type == FxScreenMediaType.xl
                                ? Image.asset(
                                    'assets/images/student.png',
                                    fit: BoxFit.cover,
                                    height: 400,
                                  )
                                : type == FxScreenMediaType.lg
                                ? Image.asset(
                                    'assets/images/student.png',
                                    fit: BoxFit.cover,
                                    height: 400,
                                  )
                                : const SizedBox();
                          },
                        ),
                      ),
                      
                      // Right side - Password Change Form
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

                                // Title
                                Center(
                                  child: FxText(
                                    'Password Change',
                                    style: FxTextStyle.labelMedium(
                                      fontSize: 24,
                                      fontWeight: 600,
                                      color: Colors.brown,
                                    ),
                                  ),
                                ),
                                FxSpacing.height(30),

                                // Mobile Number (read-only)
                                TextFormField(
                                  initialValue: widget.mobileNumber,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: "Mobile Number",
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: const Icon(
                                      LucideIcons.phone,
                                      size: 20,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade200,
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
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    counterText: "",
                                  ),
                                ),

                                FxSpacing.height(16),

                                // New Password Field
                                TextFormField(
                                  controller: newPasswordController,
                                  enabled: !state.isChangingPassword && !_isNavigating,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: !showPassword,
                                  decoration: InputDecoration(
                                    labelText: "New Password",
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: const Icon(
                                      LucideIcons.lock,
                                      size: 20,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: state.isChangingPassword || _isNavigating
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
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: "New password is required",
                                    ),
                                    FormBuilderValidators.minLength(
                                      6,
                                      errorText: 'Password length should be 6 or greater than 6',
                                    ),
                                  ]),
                                ),

                                FxSpacing.height(30),

                                // Error Message
                                if (state.isError && state.errorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: FxText(
                                      state.errorMessage!,
                                      style:  FxTextStyle.labelMedium(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),

                                // Password Change Button
                                Center(
                                  child: FxButton.rounded(
                                    onPressed: (state.isChangingPassword || _isNavigating)
                                        ? null
                                        : () {
                                            _handlePasswordChange(context);
                                          },
                                    elevation: 0,
                                    padding: FxSpacing.xy(20, 16),
                                    backgroundColor: Colors.brown,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (state.isChangingPassword || _isNavigating)
                                          SizedBox(
                                            height: 14,
                                            width: 14,
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context).colorScheme.onPrimary,
                                              strokeWidth: 1.2,
                                            ),
                                          ),
                                        if (state.isChangingPassword || _isNavigating) FxSpacing.width(16),
                                        FxText(
                                          'Change Password',
                                          style:  FxTextStyle.labelMedium(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: 500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                FxSpacing.height(20),

                                // Info Message
                                Center(
                                  child: FxText(
                                    'Please change your password to continue',
                                    style: FxTextStyle.labelMedium(
                                      fontSize: 14,
                                      color: Colors.brown.shade700,
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
        ),
      ),
    );
  }
}
