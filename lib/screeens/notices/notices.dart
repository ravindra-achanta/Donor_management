import 'package:flutter/material.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class Notices extends StatefulWidget {
  const Notices({super.key});

  @override
  State<Notices> createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  @override
  Widget build(BuildContext context) {
    return Layout(child: Center(child: Text("Notices")));
  }
}
