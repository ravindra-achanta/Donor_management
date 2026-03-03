import 'package:flutter/material.dart';

class Backbutton {
  Widget buildBackButton(BuildContext context, String title) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_back, size: 18),
          const SizedBox(width: 6),
          Text(title),
        ],
      ),
    );
  }
}
