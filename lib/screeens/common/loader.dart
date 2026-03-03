import 'package:flutter/material.dart';

class ScreenLoader extends StatelessWidget {
  const ScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 4, color: Colors.lightBlue),
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
