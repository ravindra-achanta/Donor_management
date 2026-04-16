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
import 'package:get/get.dart';

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
    // Vikasdb().setString("TOKEN", "eyJhbGciOiJIUzI1NiJ9.eyJ1dWlkVG9rZW4iOiIyYzNhMjk5OS0wOTQzLTQyMjEtOTM0OC1kODY3NTcyNTEwYmQiLCJpZGVudGl0eUlkIjoiYjQxNWU1ZTItODYxMy00ZjI3LWJkMTEtMTgyYjcyZDQ1MjE5IiwidXNlclR5cGUiOiJLQVJZQUtBUlRIQSIsImlhdCI6MTc3MzczMDk2MiwiZXhwIjoxNzc0MzM1NzYyfQ.94m5Im4grkogqt7EBpU2T1LXEZ87GEJVB6cQDqM4gEw");
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

                   //_buildStats(user),
                  // const SizedBox(height: 16),

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
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(user.email, style: const TextStyle(color: Colors.white70)),
                Text(
                  user.mobileNumber ?? "",
                  style: const TextStyle(color: Colors.white),
                ),
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
                    userId: user.id,
                    fromProfile: true,
                  ),
                ),
              );
              _loadProfile();
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.edit, color: Colors.white),
          //   onPressed: () {
          //     print('🔄 Edit button tapped, userId: ${user.id}');

          //     if (user.id.isEmpty) {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(
          //           content: Text('Error: User ID is empty'),
          //           backgroundColor: Colors.red,
          //         ),
          //       );
          //       return;
          //     }

          //     Get.toNamed('/profile-edit', arguments: user.id)?.then((_) {
          //       _loadProfile();
          //     });
          //   },
          // ),
        ],
      ),
    );
  }

  // ================= STATS =================
  Widget _buildStats(User user) {
    return Row(
      children: [
        _statCard("Assigned Members", user.karyakarthaAssignCount.toString()),
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
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
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
          _twoColumnRow(
            Icons.person,
            "Name",
            user.name,
            Icons.email,
            "Email",
            user.email,
          ),
          _infoRow(Icons.phone, "Mobile", user.mobileNumber ?? ""),

          const Divider(),

          // ROLE
          _sectionHeader("Role"),
          _buildUserTypesGrid(user),

          const Divider(),

          // ADDRESS
          _sectionHeader("Address"),
          _twoColumnRow(
            Icons.home,
            "Area",
            user.area ?? "",
            Icons.location_city,
            "City",
            user.city ?? "",
          ),
          _twoColumnRow(
            Icons.map,
            "State",
            user.state ?? "",
            Icons.public,
            "Country",
            user.country ?? "",
          ),
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

    if (user.userType != null && (user.userType?.isNotEmpty ?? false)) {
      types.add(user.userType ?? "");
    } else if (user.userTypes.isNotEmpty) {
      types = user.userTypes;
    }

    if (types.isEmpty) {
      return _infoRow(Icons.security, "User Type", "N/A");
    }

    List<Widget> rows = [];

    for (int i = 0; i < types.length; i += 2) {
      if (i + 1 < types.length) {
        rows.add(
          _twoColumnRow(
            Icons.security,
            "",
            types[i],
            Icons.security,
            "",
            types[i + 1],
          ),
        );
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
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  Widget _twoColumnRow(
    IconData i1,
    String l1,
    String v1,
    IconData i2,
    String l2,
    String v2,
  ) {
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
                  Text(
                    label,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
