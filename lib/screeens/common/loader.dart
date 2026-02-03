import 'package:flutter/material.dart';

class ScreenLoader extends StatelessWidget {
  const ScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(height: 8),
          CircularProgressIndicator(strokeWidth: 5, color: Colors.lightBlue),
          SizedBox(height: 16),
          Text(
            'Loading ...',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
