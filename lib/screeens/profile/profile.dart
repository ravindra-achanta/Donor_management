// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
// import 'package:vikas_app/bloc_management/profile/profile_bloc.dart';
// import 'package:vikas_app/bloc_management/profile/profile_event.dart';
// import 'package:vikas_app/bloc_management/profile/profile_state.dart';
// import 'package:vikas_app/screeens/authentication/registration_page.dart';
// import 'package:vikas_app/screeens/common/ErrorText.dart';
// import 'package:vikas_app/screeens/common/loader.dart';
// import 'package:vikas_app/screeens/models/enum/RegistrationType.dart';
// import 'package:vikas_app/screeens/models/response/user.dart';
// import 'package:vikas_app/views/layouts/layout.dart';

// class MyProfile extends StatefulWidget {
//   const MyProfile({super.key});

//   @override
//   State<MyProfile> createState() => _MyProfileState();
// }

// class _MyProfileState extends State<MyProfile>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnim;
//   late Animation<Offset> _slideAnim;

//   @override
//   void initState() {
//     super.initState();
//       _loadProfile();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );

//     _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

//     _slideAnim = Tween<Offset>(
//       begin: const Offset(0, 0.05),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//   }

  

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Layout(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: AnimatedSwitcher(
//           duration: const Duration(seconds: 2),
//           switchInCurve: Curves.easeOutCubic,
//           switchOutCurve: Curves.easeInCubic,
//           transitionBuilder: (child, animation) {
//             return FadeTransition(
//               opacity: animation,
//               child: SlideTransition(
//                 position: Tween<Offset>(
//                   begin: const Offset(0, 0.03),
//                   end: Offset.zero,
//                 ).animate(animation),
//                 child: ScaleTransition(
//                   scale: Tween<double>(
//                     begin: 0.98,
//                     end: 1.0,
//                   ).animate(animation),
//                   child: child,
//                 ),
//               ),
//             );
//           },
//           child: Card(
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: BlocBuilder<ProfileBloc, ProfileState?>(
//                 builder: (context, state) {
//                   if (state?.status == ProfileStatus.loading) {
//                     return const ScreenLoader();
//                   }

//                   if (state?.status == ProfileStatus.error) {
//                     return ErrorCard(
//                       message: state?.profileErrorMsg ?? "Something went wrong",
//                     );
//                   }

//                   if (state?.user == null) {
//                     return const ErrorCard(message: "User not found");
//                   }

//                   _controller.forward();

//                   final user = state!.user!;

//                   return FadeTransition(
//                     opacity: _fadeAnim,
//                     child: SlideTransition(
//                       position: _slideAnim,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // ================= HEADER =================
//                           _buildHeader(user),

//                           const SizedBox(height: 16),

//                           // ================= CONTACT =================
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: _animatedSection(
//                                   index: 1,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       _sectionTitle('Contact Information'),
//                                       _infoRow(
//                                         Icons.email_outlined,
//                                         'Email',
//                                         user.email,
//                                       ),
//                                       _infoRow(
//                                         Icons.phone_outlined,
//                                         'Mobile',
//                                         user.mobileNumber ?? "",
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),

//                               Expanded(
//                                 child: _animatedSection(
//                                   index: 3,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       _sectionTitle('System Info'),
//                                       _infoRow(
//                                         Icons.badge_outlined,
//                                         'User ID',
//                                         user.uniqueId ?? "",
//                                       ),
//                                       _infoRow(
//                                         Icons.security_outlined,
//                                         'Role',
//                                         user.userType ?? "N/A",
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 12),

//                           // ================= ADDRESS =================
//                           _animatedSection(
//                             index: 2,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _sectionTitle('Address'),
//                                 _infoRow(
//                                   Icons.location_on_outlined,
//                                   'Location',
//                                   _buildAddress(user),
//                                 ),
//                                 _infoRow(
//                                   Icons.pin_drop_outlined,
//                                   'Pincode',
//                                   user.pincode ?? "",
//                                 ),
//                               ],
//                             ),
//                           ),

//                           // const SizedBox(height: 12),

//                           // ================= SYSTEM =================
//                           const SizedBox(height: 20),

//                           // ================= ACTIONS =================
//                           _animatedSection(
//                             index: 4,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   width: 160,
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: BackdropFilter(
//                                       filter: ImageFilter.blur(
//                                         sigmaX: 6,
//                                         sigmaY: 6,
//                                       ),
//                                       child: OutlinedButton.icon(
//                                         onPressed: () {},
//                                         icon: const Icon(
//                                           Icons.logout,
//                                           size: 18,
//                                           color: Color.fromARGB(
//                                             255,
//                                             255,
//                                             134,
//                                             126,
//                                           ),
//                                         ),
//                                         label: const Text(
//                                           'Logout',
//                                           style: TextStyle(
//                                             color: Color.fromARGB(
//                                               255,
//                                               255,
//                                               134,
//                                               126,
//                                             ),
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         style: OutlinedButton.styleFrom(
//                                           backgroundColor: Colors.white
//                                               .withOpacity(0.7),
//                                           side: const BorderSide(
//                                             color: Color.fromARGB(
//                                               255,
//                                               255,
//                                               134,
//                                               126,
//                                             ),
//                                           ),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               12,
//                                             ),
//                                           ),
//                                           padding: const EdgeInsets.symmetric(
//                                             vertical: 12,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),

//                                 // const SizedBox(width: 10),
//                                 // Expanded(
//                                 //   child: ElevatedButton.icon(
//                                 //     onPressed: () {},
//                                 //     icon: const Icon(
//                                 //       Icons.delete_outline,
//                                 //       size: 18,
//                                 //     ),
//                                 //     label: const Text('Delete'),
//                                 //     style: ElevatedButton.styleFrom(
//                                 //       backgroundColor: Colors.red,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ================= UI BUILDERS =================

//   Widget _buildHeader(User user) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue.shade50, Colors.blue.shade100],
//         ),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Row(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [Colors.blue, Colors.lightBlueAccent],
//               ),
//             ),
//             padding: const EdgeInsets.all(3),
//             child: CircleAvatar(
//               radius: 28,
//               backgroundColor: Colors.white,
//               child: Text(
//                 user.name.substring(0, 1).toUpperCase(),
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   user.name,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   user.userType != null ? user.userType!.toUpperCase() : "N/A",
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
//                 ),
//               ],
//             ),
//           ),
//           //_statusChip(user.status),
//           Row(
//   mainAxisSize: MainAxisSize.min,
//   children: [
//     _statusChip(user.status),
//     const SizedBox(width: 8),
//     IconButton(
//       tooltip: "Edit Profile",
//       icon: const Icon(
//         Icons.edit_outlined,
//         color: Colors.blue,
//         size: 20,
//       ), 
//       onPressed: () async {
//   await Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => RegistrationPage(
//         title: "Edit Profile",
//         type: RegistrationType.user,
//         user: user,
//         isEdit: true,
//       ),
//     ),
//   );

//   // reload profile after returning
//   _loadProfile();
// },

//       // onPressed: () {
//       //   RegistrationPage();
//       // },
//     ),
//   ],
// ),

          
//         ],
//       ),
//     );
//   }

//   Widget _sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.bold,
//           color: Colors.blueGrey,
//           letterSpacing: 0.3,
//         ),
//       ),
//     );
//   }

//   Widget _infoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 18, color: Colors.blueGrey),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: const TextStyle(fontSize: 11, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   value.isNotEmpty ? value : '-',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _statusChip(String status) {
//     final isActive = status == 'ACTIVE';

//     return Chip(
//       label: Text(
//         isActive ? 'Active' : 'Inactive',
//         style: TextStyle(
//           fontSize: 12,
//           color: isActive ? Colors.green : Colors.red,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       backgroundColor: isActive ? Colors.green.shade100 : Colors.red.shade100,
//       side: BorderSide.none,
//     );
//   }

//   Widget _animatedSection({required int index, required Widget child}) {
//     final delay = index * 120;

//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0, end: 1),
//       duration: Duration(milliseconds: 2000 + delay),
//       curve: Curves.easeOut,
//       builder: (context, value, _) {
//         return Opacity(
//           opacity: value,
//           child: Transform.translate(
//             offset: Offset(0, (1 - value) * 12),
//             child: child,
//           ),
//         );
//       },
//     );
//   }

//   String _buildAddress(User u) {
//     final parts = [u.area, u.city, u.state, u.country];
//     return parts.where((e) => e != null && e.trim().isNotEmpty).join(', ');
//   }
  
// Future<void> _loadProfile() async {
//   final userId = await Vikasdb().getString("USER_ID");

//   if (userId != null && userId.isNotEmpty) {
//     context.read<ProfileBloc>().add(FetchProfile(id: userId));
//   }}
//     }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/bloc_management/profile/profile_bloc.dart';
import 'package:vikas_app/bloc_management/profile/profile_event.dart';
import 'package:vikas_app/bloc_management/profile/profile_state.dart';
import 'package:vikas_app/screeens/authentication/registration_page.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/models/enum/RegistrationType.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocBuilder<ProfileBloc, ProfileState?>(
          builder: (context, state) {
            if (state?.status == ProfileStatus.loading) {
              return const ScreenLoader();
            }

            if (state?.status == ProfileStatus.error) {
              return ErrorCard(
                message: state?.profileErrorMsg ?? "Something went wrong",
              );
            }

            if (state?.user == null) {
              return const ErrorCard(message: "User not found");
            }

            final user = state!.user!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(user),
                  const SizedBox(height: 16),

                  _buildStats(user),
                  const SizedBox(height: 16),

                  _buildProfileCard(user),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(User user) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Text(
              user.name.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(user.email,
                    style: const TextStyle(color: Colors.white70)),
                Text(user.mobileNumber ?? "",
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegistrationPage(
                    title: "Edit Profile",
                    type: RegistrationType.user,
                    user: user,
                    isEdit: true,
                  ),
                ),
              );
              _loadProfile();
            },
          )
        ],
      ),
    );
  }

  // ================= STATS =================
  Widget _buildStats(User user) {
    return Row(
      children: [
        _statCard("Assignments",
            user.karyakarthaAssignCount.toString()),
        _statCard("Roles", user.userTypes.length.toString()),
        _statCard("Status", user.status),
      ],
    );
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            Text(title,
                style:
                    const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ================= PROFILE CARD =================
  Widget _buildProfileCard(User user) {
    return _buildCard(
      title: "Profile Details",
      child: Column(
        children: [

          // BASIC
          _sectionHeader("Basic Info"),
          _twoColumnRow(Icons.person, "Name", user.name,
              Icons.email, "Email", user.email),
          _infoRow(Icons.phone, "Mobile", user.mobileNumber ?? ""),

          const Divider(),

          // ROLE
          _sectionHeader("Role"),
          _buildUserTypesGrid(user),

          const Divider(),

          // ADDRESS
          _sectionHeader("Address"),
          _twoColumnRow(Icons.home, "Area", user.area ?? "",
              Icons.location_city, "City", user.city ?? ""),
          _twoColumnRow(Icons.map, "State", user.state ?? "",
              Icons.public, "Country", user.country ?? ""),
          _infoRow(Icons.pin_drop, "Pincode", user.pincode ?? ""),
          //_buildLogoutButton(),
                  const SizedBox(height: 20),

        ],
      ),
    );
  }

  // ================= USER TYPES =================
  Widget _buildUserTypesGrid(User user) {
    List<String> types = [];

    if (user.userType != null && user.userType!.isNotEmpty) {
      types.add(user.userType!);
    } else if (user.userTypes.isNotEmpty) {
      types = user.userTypes;
    }

    if (types.isEmpty) {
      return _infoRow(Icons.security, "User Type", "N/A");
    }

    List<Widget> rows = [];

    for (int i = 0; i < types.length; i += 2) {
      if (i + 1 < types.length) {
        rows.add(_twoColumnRow(
            Icons.security, "", types[i],
            Icons.security, "", types[i + 1]));
      } else {
        rows.add(_infoRow(Icons.security, "Type", types[i]));
      }
    }

    return Column(children: rows);
  }

  // ================= COMMON UI =================

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          child
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey)),
      ),
    );
  }

  Widget _twoColumnRow(
      IconData i1,
      String l1,
      String v1,
      IconData i2,
      String l2,
      String v2) {
    return Row(
      children: [
        Expanded(child: _infoRow(i1, l1, v1)),
        const SizedBox(width: 10),
        Expanded(child: _infoRow(i2, l2, v2)),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label.isNotEmpty)
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                Text(value.isNotEmpty ? value : '-',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= LOAD =================
  Future<void> _loadProfile() async {
    final userId = await Vikasdb().getString("USER_ID");

    if (userId != null && userId.isNotEmpty) {
      context.read<ProfileBloc>().add(FetchProfile(id: userId));
    }
  }
  
 Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: logout logic
        },
        icon: const Icon(Icons.logout),
        label: const Text("Logout"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }   
}