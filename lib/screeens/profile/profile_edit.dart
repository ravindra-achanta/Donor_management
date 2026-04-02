import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/profile/profile_bloc.dart';
import 'package:vikas_app/bloc_management/profile/profile_event.dart';
import 'package:vikas_app/bloc_management/profile/profile_state.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/views/layouts/layout.dart';
class ProfileEditScreen extends StatefulWidget {
  final String userId;

  const ProfileEditScreen({
    required this.userId,
    super.key,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _pincodeController;
  TextEditingController? _cityController;
  TextEditingController? _areaController;
  TextEditingController? _stateController;
  TextEditingController? _countryController;

  List<String> _selectedRoles = [];
  String _selectedStatus = 'ACTIVE';

  final List<String> _statusOptions = ['ACTIVE', 'INACTIVE'];
  final _formKey = GlobalKey<FormState>();

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // 🔥 Fetch user using ID
    context.read<ProfileBloc>().add(
          FetchProfile(id: widget.userId),
        );
  }

  void _initializeControllers(User user) {
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _pincodeController = TextEditingController(text: user.pincode ?? '');
    _cityController = TextEditingController(text: user.city ?? '');
    _areaController = TextEditingController(text: user.area ?? '');
    _stateController = TextEditingController(text: user.state ?? '');
    _countryController = TextEditingController(text: user.country ?? '');

    _selectedRoles = List.from(user.roles ?? []);
    _selectedStatus = user.status ?? 'ACTIVE';

    _isInitialized = true;
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _emailController?.dispose();
    _pincodeController?.dispose();
    _cityController?.dispose();
    _areaController?.dispose();
    _stateController?.dispose();
    _countryController?.dispose();
    super.dispose();
  }

  void _submitForm(User user) {
    if (!_formKey.currentState!.validate()) return;

    final updatedUser = User(
      id: user.id,
      name: _nameController!.text.trim(),
      email: _emailController!.text.trim(),
      pincode: _pincodeController!.text.trim(),
      city: _cityController!.text.trim(),
      area: _areaController!.text.trim(),
      state: _stateController!.text.trim(),
      country: _countryController!.text.trim(),
      status: _selectedStatus,
      roles: _selectedRoles, // ✅ FIXED
      mobileNumber: user.mobileNumber,
      userType: user.userType,
      uniqueId: user.uniqueId,
      password: user.password,
      joinedDate: user.joinedDate,
      startedDate: user.startedDate,
      karyakarthaAssignCount: user.karyakarthaAssignCount,
      userTypes: user.userTypes,
    );

    context.read<ProfileBloc>().add(
          UpdateProfileInfo(
            id: widget.userId,
            user: updatedUser,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: Colors.blue,
        ),

        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.updated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Profile updated successfully"),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.back();
              });
            } else if (state.status == ProfileStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.profileErrorMsg ?? "Error updating profile"),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },

          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              // Loading state
              if (state.status == ProfileStatus.loading || state.user == null) {
                return const ScreenLoader();
              }

              final user = state.user!;

              // Initialize controllers once
              if (!_isInitialized) {
                _initializeControllers(user);
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      _buildTextField(_nameController!, "Name"),
                      _buildTextField(_emailController!, "Email"),
                      _buildTextField(_pincodeController!, "Pincode"),
                      _buildTextField(_cityController!, "City"),
                      _buildTextField(_areaController!, "Area"),
                      _buildTextField(_stateController!, "State"),
                      _buildTextField(_countryController!, "Country"),

                      const SizedBox(height: 12),
                      _buildRolesField(),

                      const SizedBox(height: 12),
                      _buildStatusDropdown(),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _submitForm(user),
                        child: const Text("Update"),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildRolesField() {
    return GestureDetector(
      onTap: _showRoleSelection,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border.all()),
        child: Text(
          _selectedRoles.isEmpty
              ? "Select roles"
              : _selectedRoles.join(", "),
        ),
      ),
    );
  }

  void _showRoleSelection() {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Roles"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['ADMIN', 'USER', 'MANAGER']
                .map((role) => CheckboxListTile(
                      title: Text(role),
                      value: _selectedRoles.contains(role),
                      onChanged: (val) {
                        setDialogState(() {
                          val!
                              ? _selectedRoles.add(role)
                              : _selectedRoles.remove(role);
                        });
                      },
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    ).then((_) {
      // Update parent widget after dialog closes
      setState(() {});
    });
  }

  Widget _buildStatusDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: _selectedStatus,
        isExpanded: true,
        items: _statusOptions
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (val) => setState(() => _selectedStatus = val!),
        decoration: InputDecoration(labelText: "Status"),
      ),
    );
  }
}