// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:vikas_app/bloc_management/profile/profile_bloc.dart';
// import 'package:vikas_app/bloc_management/profile/profile_event.dart';
// import 'package:vikas_app/bloc_management/users/user_bloc.dart';
// import 'package:vikas_app/bloc_management/users/user_event.dart';
// import 'package:vikas_app/bloc_management/users/user_state.dart';
// import 'package:vikas_app/screeens/common/backButton.dart';
// import 'package:vikas_app/screeens/models/enum/RegistrationType.dart';
// import 'package:vikas_app/screeens/models/response/user.dart';
// import 'package:vikas_app/views/layouts/layout.dart';
// import 'package:vikas_app/bloc_management/authentication/auth_bloc.dart';
// import 'package:vikas_app/bloc_management/authentication/auth_event.dart';
// import 'package:vikas_app/bloc_management/authentication/auth_state.dart';
// import 'package:vikas_app/api_services/network_repos/auth_repository.dart';
// import 'package:vikas_app/screeens/models/response/role_response.dart';

// class EditUserPage extends StatefulWidget {
//   final String userId;
//   final RegistrationType type;

//   const EditUserPage({
//     super.key,
//     required this.userId,
//     required this.type,
//   });

//   @override
//   State<EditUserPage> createState() => _EditUserPageState();
// }

// class _EditUserPageState extends State<EditUserPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController firstNameCtrl = TextEditingController();
//   final TextEditingController lastNameCtrl = TextEditingController();
//   final TextEditingController emailCtrl = TextEditingController();
//   final TextEditingController mobileCtrl = TextEditingController();
//   final TextEditingController pincodeCtrl = TextEditingController();
//   final TextEditingController cityCtrl = TextEditingController();
//   final TextEditingController areaCtrl = TextEditingController();
//   final TextEditingController stateCtrl = TextEditingController();
//   final TextEditingController countryCtrl = TextEditingController();
//   final TextEditingController startDateCtrl = TextEditingController();

//   List<Role> selectedRoles = [];

//   String _formatDate(DateTime date) {
//     return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//   }

//   @override
//   void dispose() {
//     firstNameCtrl.dispose();
//     lastNameCtrl.dispose();
//     emailCtrl.dispose();
//     mobileCtrl.dispose();
//     pincodeCtrl.dispose();
//     cityCtrl.dispose();
//     areaCtrl.dispose();
//     stateCtrl.dispose();
//     countryCtrl.dispose();
//     startDateCtrl.dispose();
//     super.dispose();
//   }

//   void _clearForm() {
//     _formKey.currentState?.reset();
//     setState(() {
//       selectedRoles.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => AuthBloc(authRepository: AuthRepository())),
//         BlocProvider(create: (_) => UserBloc()),
//       ],
//       child: _EditUserFormContent(
//         userId: widget.userId,
//         type: widget.type,
//         formKey: _formKey,
//         firstNameCtrl: firstNameCtrl,
//         lastNameCtrl: lastNameCtrl,
//         emailCtrl: emailCtrl,
//         mobileCtrl: mobileCtrl,
//         pincodeCtrl: pincodeCtrl,
//         cityCtrl: cityCtrl,
//         areaCtrl: areaCtrl,
//         stateCtrl: stateCtrl,
//         countryCtrl: countryCtrl,
//         startDateCtrl: startDateCtrl,
//         selectedRoles: selectedRoles,
//         onRolesUpdated: (List<Role> updatedList) {
//           setState(() {
//             selectedRoles = updatedList;
//           });
//         },
//         onClearForm: _clearForm,
//       ),
//     );
//   }
// }

// class _EditUserFormContent extends StatefulWidget {
//   final String userId;
//   final RegistrationType type;
//   final GlobalKey<FormState> formKey;
//   final TextEditingController firstNameCtrl;
//   final TextEditingController lastNameCtrl;
//   final TextEditingController emailCtrl;
//   final TextEditingController mobileCtrl;
//   final TextEditingController pincodeCtrl;
//   final TextEditingController cityCtrl;
//   final TextEditingController areaCtrl;
//   final TextEditingController stateCtrl;
//   final TextEditingController countryCtrl;
//   final TextEditingController startDateCtrl;
//   final List<Role> selectedRoles;
//   final Function(List<Role>) onRolesUpdated;
//   final VoidCallback onClearForm;

//   const _EditUserFormContent({
//     required this.userId,
//     required this.type,
//     required this.formKey,
//     required this.firstNameCtrl,
//     required this.lastNameCtrl,
//     required this.emailCtrl,
//     required this.mobileCtrl,
//     required this.pincodeCtrl,
//     required this.cityCtrl,
//     required this.areaCtrl,
//     required this.stateCtrl,
//     required this.countryCtrl,
//     required this.startDateCtrl,
//     required this.selectedRoles,
//     required this.onRolesUpdated,
//     required this.onClearForm,
//   });

//   @override
//   State<_EditUserFormContent> createState() => _EditUserFormContentState();
// }

// class _EditUserFormContentState extends State<_EditUserFormContent> {
//   User? fetchedUser;

//   @override
//   void initState() {
//     super.initState();

//     // Fetch user profile
//     context.read<UserBloc>().add(FetchUsersProfileEvent(userId: widget.userId));

//     // Fetch roles
//     context.read<AuthBloc>().add(FetchRolesEventByType());
//   }

//   String _formatDate(DateTime date) {
//     return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//   }

//   void _populateUserFields(User user, List<Role> availableRoles) {
//     final nameParts = user.name.split(" ");
//     widget.firstNameCtrl.text = nameParts.isNotEmpty ? nameParts.first : "";
//     widget.lastNameCtrl.text = nameParts.length > 1
//         ? nameParts.sublist(1).join(" ")
//         : "";

//     widget.emailCtrl.text = user.email ?? "";
//     widget.mobileCtrl.text = user.mobileNumber ?? "";
//     widget.pincodeCtrl.text = user.pincode ?? "";
//     widget.cityCtrl.text = user.city ?? "";
//     widget.areaCtrl.text = user.area ?? "";
//     widget.stateCtrl.text = user.state ?? "";
//     widget.countryCtrl.text = user.country ?? "";
//     widget.startDateCtrl.text = user.startedDate ?? _formatDate(DateTime.now());

//     // Match user roles with available roles
//     if (user.roles.isNotEmpty && availableRoles.isNotEmpty) {
//       final matchedRoles = availableRoles.where(
//         (role) => user.roles.contains(role.id) || user.roles.contains(role.roleName),
//       ).toList();

//       if (matchedRoles.isNotEmpty) {
//         widget.onRolesUpdated(matchedRoles);
//       }
//     }
//   }

//   Widget _input(
//     TextEditingController controller,
//     String label, {
//     TextInputType keyboardType = TextInputType.text,
//     bool lettersOnly = false,
//     bool numbersOnly = false,
//     bool isLoading = false,
//     IconData? icon,
//     bool enabled = true,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 18),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         enabled: enabled && !isLoading,
//         inputFormatters: [
//           if (lettersOnly)
//             FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
//           if (numbersOnly) FilteringTextInputFormatter.digitsOnly,
//         ],
//         style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: "Enter $label",
//           prefixIcon: icon != null
//               ? Icon(icon, color: Colors.grey.shade600)
//               : null,
//           filled: true,
//           fillColor: !enabled ? Colors.grey[200] : const Color(0xffF7F9FC),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.blue, width: 1.5),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.red),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.red, width: 1.5),
//           ),
//         ),
//         validator: (value) {
//           if (label == "Email" &&
//               value!.trim().isNotEmpty &&
//               !RegExp(
//                 r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//               ).hasMatch(value.trim())) {
//             return 'Enter a valid email';
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _updateButton(BuildContext context, bool isLoading, User? user) {
//     return Expanded(
//       child: SizedBox(
//         height: 45,
//         child: ElevatedButton(
//           onPressed: isLoading
//               ? null
//               : () {
//                   if (!widget.formKey.currentState!.validate()) return;

//                   final updatedRoles = widget.selectedRoles.isNotEmpty
//                       ? widget.selectedRoles.map((role) => role.id).toList()
//                       : user?.roles ?? [];

//                   final updatedUser = User(
//                     id: user!.id,
//                     name:
//                         "${widget.firstNameCtrl.text.trim()} ${widget.lastNameCtrl.text.trim()}",
//                     email: widget.emailCtrl.text.trim(),
//                     mobileNumber: widget.mobileCtrl.text.trim(),
//                     status: user.status,
//                     roles: updatedRoles,
//                     pincode: widget.pincodeCtrl.text.trim(),
//                     city: widget.cityCtrl.text.trim(),
//                     area: widget.areaCtrl.text.trim(),
//                     state: widget.stateCtrl.text.trim(),
//                     country: widget.countryCtrl.text.trim(),
//                   );

//                   context.read<ProfileBloc>().add(
//                     UpdateProfile(id: user.id, user: updatedUser),
//                   );
//                 },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF8D6E63),
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             elevation: 3,
//           ),
//           child: isLoading
//               ? const SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 )
//               : const Text(
//                   "Update",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _cancelButton(BuildContext context, bool isLoading) {
//     return Expanded(
//       child: SizedBox(
//         height: 45,
//         child: ElevatedButton(
//           onPressed: isLoading ? null : () => Navigator.pop(context),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.grey[700],
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//               side: BorderSide(color: Colors.grey[400]!, width: 1),
//             ),
//             elevation: 1,
//           ),
//           child: const Text(
//             "Cancel",
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _startDateField(bool isLoading) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 18),
//       child: TextFormField(
//         controller: widget.startDateCtrl,
//         readOnly: true,
//         enabled: !isLoading,
//         style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//         decoration: InputDecoration(
//           labelText: "Start Date",
//           hintText: "Select Start Date",
//           prefixIcon: const Icon(Icons.event, color: Colors.grey),
//           filled: true,
//           fillColor: const Color(0xffF7F9FC),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.blue, width: 1.5),
//           ),
//           suffixIcon: Container(
//             margin: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(Icons.calendar_today, size: 18),
//           ),
//         ),
//         onTap: isLoading
//             ? null
//             : () async {
//                 final pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2050),
//                 );

//                 if (pickedDate != null) {
//                   widget.startDateCtrl.text = _formatDate(pickedDate);
//                 }
//               },
//       ),
//     );
//   }

//   Widget _multiSelectRoleField(bool isLoading, List<Role> allRoles) {
//     String selectedText = widget.selectedRoles.isNotEmpty
//         ? widget.selectedRoles.map((e) => e.displayName).join(", ")
//         : "";

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 18),
//       child: GestureDetector(
//         onTap: isLoading
//             ? null
//             : () async {
//                 await showModalBottomSheet(
//                   context: context,
//                   isScrollControlled: true,
//                   backgroundColor: Colors.transparent,
//                   builder: (context) {
//                     return StatefulBuilder(
//                       builder: (context, setModalState) {
//                         return DraggableScrollableSheet(
//                           initialChildSize: 0.35,
//                           minChildSize: 0.25,
//                           maxChildSize: 0.6,
//                           expand: false,
//                           builder: (_, controller) {
//                             return Container(
//                               padding: const EdgeInsets.all(20),
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.vertical(
//                                   top: Radius.circular(20),
//                                 ),
//                               ),
//                               child: ListView(
//                                 controller: controller,
//                                 children: [
//                                   const Center(
//                                     child: Text(
//                                       "Select Role(s)",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 16),
//                                   ...allRoles.map((role) {
//                                     final isSelected = widget.selectedRoles
//                                         .any((r) => r.id == role.id);

//                                     return CheckboxListTile(
//                                       dense: true,
//                                       title: Text(role.displayName),
//                                       value: isSelected,
//                                       onChanged: (val) {
//                                         setModalState(() {
//                                           final updatedList =
//                                               List<Role>.from(
//                                                 widget.selectedRoles,
//                                               );

//                                           if (val == true) {
//                                             updatedList.add(role);
//                                           } else {
//                                             updatedList.removeWhere(
//                                               (r) => r.id == role.id,
//                                             );
//                                           }

//                                           widget.onRolesUpdated(updatedList);
//                                         });
//                                       },
//                                     );
//                                   }).toList(),
//                                   const SizedBox(height: 10),
//                                   ElevatedButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     child: const Text("Done"),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//         child: AbsorbPointer(
//           child: TextFormField(
//             readOnly: true,
//             enabled: !isLoading,
//             initialValue: selectedText,
//             maxLines: 1,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//             ),
//             decoration: InputDecoration(
//               labelText: "Role",
//               hintText: "Select Role(s)",
//               prefixIcon: const Icon(Icons.badge, color: Colors.grey),
//               filled: true,
//               fillColor: const Color(0xffF7F9FC),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(
//                   color: Colors.blue,
//                   width: 1.5,
//                 ),
//               ),
//               suffixIcon: const Icon(Icons.keyboard_arrow_down),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<UserBloc, UserState>(
//       listener: (context, userState) {
//         // Populate fields when user data is fetched
//         if (userState.user != null &&
//             !userState.profileLoading &&
//             fetchedUser == null) {
//           fetchedUser = userState.user;
//           final authState = context.read<AuthBloc>().state;
//           _populateUserFields(userState.user!, authState.typeBasedRoles);
//         }

//         // Show error
//         if (userState.profileErrorMsg != null &&
//             userState.profileErrorMsg!.isNotEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Failed to load user: ${userState.profileErrorMsg}'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       child: BlocListener<ProfileBloc, dynamic>(
//         listener: (context, state) {
//           // Handle update success
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('User updated successfully'),
//               backgroundColor: Colors.green,
//               duration: Duration(seconds: 3),
//             ),
//           );

//           Future.delayed(const Duration(milliseconds: 500), () {
//             widget.type == RegistrationType.user
//                 ? Get.toNamed('/users')
//                 : Get.toNamed('/karyakarthas');
//           });
//         },
//         child: BlocBuilder<AuthBloc, AuthState>(
//           builder: (context, authState) {
//             return BlocBuilder<UserBloc, UserState>(
//               builder: (context, userState) {
//                 final isWideScreen = MediaQuery.of(context).size.width > 700;
//                 final isLoading = userState.profileLoading;
//                 final roles = authState.typeBasedRoles;

//                 // Loading state
//                 if (isLoading) {
//                   return Layout(
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           CircularProgressIndicator(),
//                           SizedBox(height: 16),
//                           Text('Loading user data...'),
//                         ],
//                       ),
//                     ),
//                   );
//                 }

//                 // Error state
//                 if (userState.profileErrorMsg != null &&
//                     userState.user == null) {
//                   return Layout(
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(24),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(
//                               Icons.error_outline,
//                               size: 48,
//                               color: Colors.red,
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               'Failed to load user: ${userState.profileErrorMsg}',
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(color: Colors.red),
//                             ),
//                             const SizedBox(height: 16),
//                             ElevatedButton(
//                               onPressed: () {
//                                 context.read<UserBloc>().add(
//                                   FetchUsersProfileEvent(userId: widget.userId),
//                                 );
//                               },
//                               child: const Text('Retry'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }

//                 Widget rowFields(Widget first, Widget second) {
//                   return isWideScreen
//                       ? Row(
//                           children: [
//                             Expanded(child: first),
//                             const SizedBox(width: 16),
//                             Expanded(child: second),
//                           ],
//                         )
//                       : Column(children: [first, second]);
//                 }

//                 return Layout(
//                   child: Center(
//                     child: SingleChildScrollView(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 16,
//                       ),
//                       child: Card(
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(32),
//                           child: Form(
//                             key: widget.formKey,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Backbutton().buildBackButton(context, "Users"),
//                                 const SizedBox(height: 10),
//                                 const Text(
//                                   "Edit User",
//                                   style: TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 const Divider(thickness: 1),
//                                 const SizedBox(height: 10),
//                                 const Text(
//                                   "Personal Information",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 rowFields(
//                                   _input(
//                                     widget.firstNameCtrl,
//                                     "First Name",
//                                     lettersOnly: true,
//                                     isLoading: isLoading,
//                                   ),
//                                   _input(
//                                     widget.lastNameCtrl,
//                                     "Last Name",
//                                     lettersOnly: true,
//                                     isLoading: isLoading,
//                                   ),
//                                 ),
//                                 rowFields(
//                                   _input(
//                                     widget.emailCtrl,
//                                     "Email",
//                                     keyboardType: TextInputType.emailAddress,
//                                     isLoading: isLoading,
//                                   ),
//                                   _input(
//                                     widget.mobileCtrl,
//                                     "Mobile Number",
//                                     keyboardType: TextInputType.phone,
//                                     numbersOnly: true,
//                                     isLoading: isLoading,
//                                     enabled: false,
//                                   ),
//                                 ),
//                                 rowFields(
//                                   _multiSelectRoleField(isLoading, roles),
//                                   _startDateField(isLoading),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 const Text(
//                                   "Address Information",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 rowFields(
//                                   _input(
//                                     widget.areaCtrl,
//                                     "Area",
//                                     lettersOnly: true,
//                                     //isLoading: isLoading,
//                                   ),
//                                   _input(
//                                     widget.cityCtrl,
//                                     "City",
//                                     lettersOnly: true,
//                                    // isLoading: isLoading,
//                                   ),
//                                 ),
//                                 rowFields(
//                                   _input(
//                                     widget.stateCtrl,
//                                     "State",
//                                     lettersOnly: true,
//                                    // isLoading: isLoading,
//                                   ),
//                                   _input(
//                                     widget.countryCtrl,
//                                     "Country",
//                                     lettersOnly: true,
//                                     //isLoading: isLoading,
//                                   ),
//                                 ),
//                                 rowFields(
//                                   _input(
//                                     widget.pincodeCtrl,
//                                     "Pincode",
//                                     keyboardType: TextInputType.number,
//                                     numbersOnly: true,
//                                    // isLoading: isLoading,
//                                   ),
//                                   const SizedBox(),
//                                 ),
//                                 const SizedBox(height: 22),
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Container(
//                                     width: MediaQuery.of(context).size.width > 600
//                                         ? 430
//                                         : double.infinity,
//                                     child: isWideScreen
//                                         ? Row(
//                                             children: [
//                                               _cancelButton(context, isLoading),
//                                               const SizedBox(width: 16),
//                                               _updateButton(
//                                                 context,
//                                                // isLoading,
//                                                 userState.user,
//                                               ),
//                                             ],
//                                           )
//                                         : Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.stretch,
//                                             children: [
//                                               _updateButton(
//                                                 context,
//                                                 isLoading,
//                                                 //userState.user,
//                                               ),
//                                               const SizedBox(height: 12),
//                                               _cancelButton(context, isLoading),
//                                             ],
//                                           ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }