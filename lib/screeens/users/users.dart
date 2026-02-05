import 'package:flutter/material.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Layout(child: Center(child: Text("Users")));
  }
}
