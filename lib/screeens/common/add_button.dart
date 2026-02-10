import 'package:flutter/material.dart';

class AddButton {
  Widget addButton({
    required BuildContext context,
    String buttonText = "Add",
    VoidCallback? onClicked,
  }) {
    return ElevatedButton.icon(
      onPressed: () {
        onClicked!();
      },
      icon: const Icon(Icons.add, size: 18),
      label: Text(
        buttonText,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
