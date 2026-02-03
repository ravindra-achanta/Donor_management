import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vikas_app/images.dart';
import 'package:vikas_app/utils/mixins/ui_mixins.dart';
import 'package:vikas_app/views/layouts/auth_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // late LoginController controller;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool showPassword = false, loading = false;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    emailController.addListener(resetErrorMessage);

    passwordController.addListener(resetErrorMessage);
  }

  @override
  void dispose() {
    emailController.removeListener(resetErrorMessage);

    passwordController.removeListener(resetErrorMessage);

    emailController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  void onChangeShowPassword() {
    showPassword = !showPassword;
  }

  void resetErrorMessage() {
    if (errorMessage != null) {
      setState(() {
        errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
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
                          Images.login[3],
                          fit: BoxFit.cover,
                          height: 500,
                        )
                      : type == FxScreenMediaType.xl
                      ? Image.asset(
                          Images.login[3],
                          fit: BoxFit.cover,
                          height: 500,
                        )
                      : type == FxScreenMediaType.lg
                      ? Image.asset(
                          Images.login[3],
                          fit: BoxFit.cover,
                          height: 500,
                        )
                      : const SizedBox();
                },
              ),
            ),
            FxFlexItem(
              sizes: "lg-6",
              child: Padding(
                padding: FxSpacing.y(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: FxText.titleLarge(
                          "Welcome Back !!",
                          fontWeight: 600,
                          fontSize: 24,
                        ),
                      ),
                      Center(
                        child: FxText.bodyMedium(
                          "Login to lead your work Force",
                          fontSize: 16,
                        ),
                      ),
                      FxSpacing.height(40),
                      FxText.bodyMedium("Email Id"),
                      FxSpacing.height(8),
                      TextFormField(
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle: FxTextStyle.bodySmall(xMuted: true),
                          // border: outlineInputBorder,
                          prefixIcon: const Icon(LucideIcons.mail, size: 20),
                          contentPadding: FxSpacing.all(16),
                          isCollapsed: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(
                            errorText: "Enter correct email format",
                          ),
                        ]),
                        onFieldSubmitted: (value) {},
                      ),
                      FxSpacing.height(16),
                      FxText.labelMedium("password"),
                      FxSpacing.height(8),
                      TextFormField(
                        controller: passwordController,

                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        keyboardType: TextInputType.visiblePassword,

                        obscureText:
                            !showPassword, // Correct handling of visibility

                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: FxTextStyle.bodySmall(xMuted: true),
                          // border: outlineInputBorder,
                          prefixIcon: const Icon(LucideIcons.lock, size: 20),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            child: Icon(
                              showPassword
                                  ? LucideIcons.eye
                                  : LucideIcons.eyeOff,
                              size: 20,
                            ),
                          ),
                          contentPadding: FxSpacing.all(16),
                          isCollapsed: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),

                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(
                            6,
                            errorText:
                                'Password length should be 6 or greater than 6',
                          ),
                        ]),
                      ),
                      FxSpacing.height(12),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FxText(
                            errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      FxSpacing.height(40),
                      Center(
                        child: FxButton.rounded(
                          onPressed: () {
                            Get.toNamed('/dashboard');
                          },
                          elevation: 0,
                          padding: FxSpacing.xy(20, 16),
                          // backgroundColor: contentTheme.primary,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              loading
                                  ? SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: CircularProgressIndicator(
                                        color: colorScheme.onPrimary,
                                        strokeWidth: 1.2,
                                      ),
                                    )
                                  : Container(),
                              if (loading) FxSpacing.width(16),
                              FxText.bodySmall(
                                'Login',
                                // color: contentTheme.onPrimary,
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
    );
  }
}
