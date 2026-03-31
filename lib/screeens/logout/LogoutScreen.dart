import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/bloc_management/profile/profile_bloc.dart';
import 'package:vikas_app/bloc_management/profile/profile_event.dart';
import 'package:vikas_app/bloc_management/profile/profile_state.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return Layout(
  child: Align(
    alignment: Alignment.topCenter, // 👈 move to top center
    child: Padding(
      padding: const EdgeInsets.only(top: 80), // 👈 space from top
      child: SizedBox(
        width: 400, // 👈 control width (important)
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state.status == ProfileStatus.initial) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.red.shade50,
                    child: Icon(
                      Icons.logout,
                      size: 32,
                      color: Colors.red.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Logout Account",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Are you sure want to logout your account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<ProfileBloc>().add(LogoutEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                          ),
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);
  }
}