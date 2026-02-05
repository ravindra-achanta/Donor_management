import 'package:flutter/material.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class DhramSetuScreen extends StatefulWidget {
  const DhramSetuScreen({super.key});

  @override
  State<DhramSetuScreen> createState() => _DhramSetuScreenState();
}

class _DhramSetuScreenState extends State<DhramSetuScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(child: Center(child: Text("Dharmasetu")));
  }
}
