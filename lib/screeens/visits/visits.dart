import 'package:flutter/material.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class Visits extends StatefulWidget {
  const Visits({super.key});

  @override
  State<Visits> createState() => _VisitsState();
}

class _VisitsState extends State<Visits> {
  @override
  Widget build(BuildContext context) {
    return Layout(child: Center(child: Text("Visits")));
  }
}
