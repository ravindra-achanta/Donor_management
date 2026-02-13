import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
  List<Role> roles = [];            // ← store fetched roles
  bool isLoadingRoles = false;      // ← loading indicator for dropdown
  Role? selectedRole;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_resetErrorMessage);
    passwordController.addListener(_resetErrorMessage);
    _fetchRoles();   
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

  
  void _handleLogin(BuildContext context) {
  if (!_formKey.currentState!.validate()) return;

  if (selectedRole == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a role')),
    );
    return;
  }

  final mobileNumber = emailController.text.trim();
  final password = passwordController.text;

  context.read<AuthBloc>().add(
    LoginEvent(
      mobileNumber: mobileNumber,
      password: password,
      roleName: selectedRole!.roleName,   
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepository: AuthRepository()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/dashboard');
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
                    // FxFlexItem(
                    //   sizes: "lg-6",
                    //   child: Center(
                    //     child: LayoutBuilder(
                    //       builder: (context, constraints) {
                    //         double imageHeight = constraints.maxWidth > 1200
                    //             ? 520
                    //             : 380;
                    //         return Image.asset(
                    //           'assets/images/student.png',
                    //           height: imageHeight,
                    //           fit: BoxFit.contain,
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),

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

                              // Mobile Number Field
                              TextFormField(
                                controller: emailController,
                                enabled: !state.isLoading,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  labelText: "Mobile Number",
                                  labelStyle: FxTextStyle.bodySmall(
                                    xMuted: true,
                                  ),
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
                              TextFormField(
                                controller: passwordController,
                                enabled: !state.isLoading,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: !showPassword,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: FxTextStyle.bodySmall(
                                    xMuted: true,
                                  ),
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

                              
                        //       DropdownButtonFormField<UserType>(
                        //         value: selectedUserType,
                        //         decoration: InputDecoration(
                        //           labelText: "Select User Type",
                        //           labelStyle: FxTextStyle.bodySmall(
                        //             xMuted: true,
                        //           ),
                        //           filled: true,
                        //           fillColor:
                        //               Colors.grey.shade100, // Field background
                        //           contentPadding: const EdgeInsets.symmetric(
                        //             horizontal: 16,
                        //             vertical: 18,
                        //           ),
                        //           enabledBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(12),
                        //             borderSide: BorderSide(
                        //               color: Colors.brown.shade300,
                        //               width: 1,
                        //             ),
                        //           ),
                        //           focusedBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(12),
                        //             borderSide: const BorderSide(
                        //               color: Colors.brown,
                        //               width: 1.5,
                        //             ),
                        //           ),
                        //         ),
                        //         dropdownColor: Colors
                        //             .grey
                        //             .shade100, // Popup menu background
                        //         style: const TextStyle(
                        //           color: Colors
                        //               .brown, // Text color for selected item
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //         icon: const Icon(
                        //           LucideIcons.chevronDown,
                        //           color: Colors.brown,
                        //         ),
                        //         isExpanded: true, // Fill full width
                        //         validator: (value) {
                        //           if (value == null) {
                        //             return 'Please select a user type';
                        //           }
                        //           return null;
                        //         },
                        //         items: UserType.values.map((UserType type) {
                        //           return DropdownMenuItem<UserType>(
                        //             value: type,
                        //             child: Text(
                        //               type.displayName,
                        //               style: const TextStyle(
                        //                 color: Colors.brown,
                        //                 fontSize: 16,
                        //               ),
                        //             ),
                        //           );
                        //         }).toList(),
                        //         onChanged: (UserType? value) {
                        //           setState(() {
                        //             selectedUserType = value;
                        //           });
                        //         },
                        //         selectedItemBuilder: (BuildContext context) {
                        //           return UserType.values.map((UserType type) {
                        //             return Text(
                        //               type.displayName,
                        //               style: const TextStyle(
                        //                 color: Colors.brown,
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.w600,
                        //               ),
                        //             );
                        //           }).toList();
                        //         },
                        //       ),

                        // if (state.isError && state.errorMessage != null)
                        //         Padding(
                        //           padding: const EdgeInsets.only(bottom: 10),
                        //           child: FxText(
                        //             state.errorMessage!,
                        //             style: const TextStyle(
                        //               color: Colors.red,
                        //               fontSize: 16,
                        //             ),
                        //           ),
                        //         ),
                        //       FxSpacing.height(10),
                         if (isLoadingRoles)
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ))
                              else if (roles.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: FxText.bodySmall(
                                      'No roles available',
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              else
                                DropdownButtonFormField<Role>(
                                  value: selectedRole,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: "Select Role",
                                    labelStyle:
                                        FxTextStyle.bodySmall(xMuted: true),
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                  icon: const Icon(
                                    LucideIcons.chevronDown,
                                    color: Colors.brown,
                                  ),
                                  validator: (value) => value == null
                                      ? 'Please select a role'
                                      : null,
                                  items: roles.map((Role role) {
                                    return DropdownMenuItem<Role>(
                                      value: role,
                                      child: Text(
                                        role.displayName,
                                        style: const TextStyle(
                                          color: Colors.brown,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (Role? value) {
                                    setState(() => selectedRole = value);
                                  },
                                  selectedItemBuilder: (context) {
                                    return roles.map((Role role) {
                                      return Text(
                                        //role.roleName ?? role.roleName ?? 'Role',
                                        role.displayName,

                                        style: const TextStyle(
                                          color: Colors.brown,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),

                              if (state.isError && state.errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: FxText(
                                    state.errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                              FxSpacing.height(10),

                              // Login Button
                              Center(
                                child: FxButton.rounded(
                                  onPressed: state.isLoading
                                      ? null
                                      : () {
                                          _handleLogin(context);
                                        },
                                  elevation: 0,
                                  padding: FxSpacing.xy(20, 16),
                                  backgroundColor: Colors.brown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (state.isLoading)
                                        SizedBox(
                                          height: 14,
                                          width: 14,
                                          child: CircularProgressIndicator(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                            strokeWidth: 1.2,
                                          ),
                                        ),
                                      if (state.isLoading) FxSpacing.width(16),
                                      FxText.bodySmall(
                                        'Login',
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
      ),
    );
  }
  
  Future<void> _fetchRoles() async {
  setState(() => isLoadingRoles = true);
  final result = await AuthRepository().getRoles();  
  setState(() {
    if (result.isSuccess) {
      roles = result.data ?? [];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load roles: ${result.error?.message}')),
      );
    }
    isLoadingRoles = false;
  });
}
}




// import 'package:flutter/material.dart';
// import 'package:flutx/flutx.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:get/get.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:vikas_app/images.dart';
// import 'package:vikas_app/utils/mixins/ui_mixins.dart';
// import 'package:vikas_app/views/layouts/auth_layout.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   // late LoginController controller;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController emailController = TextEditingController();

//   final TextEditingController passwordController = TextEditingController();

//   bool showPassword = false, loading = false;

//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();

//     emailController.addListener(resetErrorMessage);

//     passwordController.addListener(resetErrorMessage);
//   }

//   @override
//   void dispose() {
//     emailController.removeListener(resetErrorMessage);

//     passwordController.removeListener(resetErrorMessage);

//     emailController.dispose();

//     passwordController.dispose();

//     super.dispose();
//   }

//   void onChangeShowPassword() {
//     showPassword = !showPassword;
//   }

//   void resetErrorMessage() {
//     if (errorMessage != null) {
//       setState(() {
//         errorMessage = null;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color.fromARGB(255, 205, 88, 29),
//       child: AuthLayout(
//         child: Padding(
//           padding: FxSpacing.all(16),
//           child: FxFlex(
//             contentPadding: false,
//             children: [
//               // FxFlexItem(
//               //   sizes: "lg-6",
//               //   child: FxResponsive(
//               //     builder: (_, __, type) {
//               //       return type == FxScreenMediaType.xxl
//               //           ? Image.asset(
//               //               //Images.login[3],
//               //               'assets/images/student.png',

//               //               fit: BoxFit.cover,
//               //               height: 400,
//               //             )
//               //           : type == FxScreenMediaType.xl
//               //           ? Image.asset(
//               //               //Images.login[3],
//               //               'assets/images/student.png',

//               //               fit: BoxFit.cover,
//               //               height: 400,
//               //             )
//               //           : type == FxScreenMediaType.lg
//               //           ? Image.asset(
//               //               // Images.login[3],
//               //               'assets/images/student.png',

//               //               fit: BoxFit.cover,
//               //               height: 400,
//               //             )
//               //           : const SizedBox();
//               //     },
//               //   ),
//               // ),
//               FxFlexItem(
//                 sizes: "lg-6",
//                 child: Center(
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       double imageHeight = constraints.maxWidth > 1200
//                           ? 520
//                           : 380;

//                       return Image.asset(
//                         'assets/images/student.png',
//                         height: imageHeight,
//                         fit: BoxFit.contain,
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               FxFlexItem(
//                 sizes: "lg-6",
//                 child: Padding(
//                   padding: FxSpacing.y(28),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Center(
//                           child: Column(
//                             children: [
//                               // Logo Image
//                               Image.asset(
//                                 'assets/vidyaaranayam_logo.png',
//                                 height: 150,
//                                 width: 150,
//                                 fit: BoxFit.contain,
//                               ),
//                               FxSpacing.height(5),
//                             ],
//                           ),
//                         ),

//                         // FxSpacing.height(14),
//                         // Center(
//                         //   child: FxText.titleLarge(
//                         //     "Welcome Back !!",
//                         //     fontWeight: 600,
//                         //     fontSize: 24,
//                         //   ),
//                         // ),
//                         // Center(
//                         //   child: FxText.bodyMedium(
//                         //     "Login to lead your spiritual seva",
//                         //     fontSize: 16,
//                         //   ),
//                         // ),
//                         FxSpacing.height(16),

//                         TextFormField(
//                           controller: emailController,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           keyboardType: TextInputType.phone,
//                           maxLength: 10,
//                           decoration: InputDecoration(
//                             labelText: "Mobile Number",
//                             labelStyle: FxTextStyle.bodySmall(xMuted: true),
//                             prefixIcon: const Icon(LucideIcons.phone, size: 20),

//                             filled: true,
//                             fillColor: Colors.grey.shade100,

//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 18,
//                             ),

//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color: Colors.brown.shade300,
//                                 width: 1,
//                               ),
//                             ),

//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(
//                                 color: Colors.brown,
//                                 width: 1.5,
//                               ),
//                             ),

//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             counterText: "",
//                           ),

//                           validator: FormBuilderValidators.compose([
//                             FormBuilderValidators.required(
//                               errorText: "Mobile number is required",
//                             ),
//                             FormBuilderValidators.numeric(
//                               errorText: "Only numbers allowed",
//                             ),
//                             FormBuilderValidators.minLength(
//                               10,
//                               errorText: "Enter 10 digit mobile number",
//                             ),
//                             FormBuilderValidators.maxLength(
//                               10,
//                               errorText: "Enter 10 digit mobile number",
//                             ),
//                           ]),
//                         ),

//                         FxSpacing.height(16),

//                         TextFormField(
//                           controller: passwordController,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           keyboardType: TextInputType.visiblePassword,
//                           obscureText: !showPassword,
//                           decoration: InputDecoration(
//                             labelText: "Password",
//                             labelStyle: FxTextStyle.bodySmall(xMuted: true),
//                             prefixIcon: const Icon(LucideIcons.lock, size: 20),

//                             suffixIcon: InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   showPassword = !showPassword;
//                                 });
//                               },
//                               child: Icon(
//                                 showPassword
//                                     ? LucideIcons.eye
//                                     : LucideIcons.eyeOff,
//                                 size: 20,
//                               ),
//                             ),

//                             filled: true,
//                             fillColor: Colors.grey.shade100,

//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 18,
//                             ),

//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color: Colors.brown.shade300,
//                                 width: 1,
//                               ),
//                             ),

//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(
//                                 color: Colors.brown,
//                                 width: 1.5,
//                               ),
//                             ),

//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                           ),

//                           validator: FormBuilderValidators.compose([
//                             FormBuilderValidators.required(),
//                             FormBuilderValidators.minLength(
//                               6,
//                               errorText:
//                                   'Password length should be 6 or greater than 6',
//                             ),
//                           ]),
//                         ),

//                         FxSpacing.height(16),

//                         if (errorMessage != null)
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 10),
//                             child: FxText(
//                               errorMessage!,
//                               style: const TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         FxSpacing.height(10),
//                         Center(
//                           child: FxButton.rounded(
//                             onPressed: () {
//                               Get.toNamed('/dashboard');
//                             },
//                             elevation: 0,
//                             padding: FxSpacing.xy(20, 16),
//                             backgroundColor: Colors.brown,
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 loading
//                                     ? SizedBox(
//                                         height: 14,
//                                         width: 14,
//                                         child: CircularProgressIndicator(
//                                           color: colorScheme.onPrimary,
//                                           strokeWidth: 1.2,
//                                         ),
//                                       )
//                                     : Container(),
//                                 if (loading) FxSpacing.width(16),
//                                 FxText.bodySmall(
//                                   'Login',
//                                   color: Colors.white,
//                                   // color: contentTheme.onPrimary,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

