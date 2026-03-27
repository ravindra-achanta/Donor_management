import 'package:flutter/material.dart';

class CommonFilter extends StatelessWidget {
  final String? selectedValue;
  final Function(String?) onChanged;

  const CommonFilter({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: "Sort",
      onSelected: (value) {
        onChanged(value);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "LATEST",
          child: Row(
            children: const [
              Icon(Icons.arrow_downward, size: 18),
              SizedBox(width: 8),
              Text("Latest First"),
            ],
          ),
        ),
        PopupMenuItem(
          value: "OLDEST",
          child: Row(
            children: const [
              Icon(Icons.arrow_upward, size: 18),
              SizedBox(width: 8),
              Text("Oldest First"),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          Icons.sort, // 🔥 main icon
          size: 20,
          color: Colors.black87,
        ),
      ),
    );
  }
}