import 'package:flutter/material.dart';

class CommonSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String value)? onSearch;
  final String hintText;
  final double width;

  const CommonSearchBar({
    super.key,
    required this.controller,
    this.onSearch,
    this.hintText = "Search...",
    this.width = 220, // 🔽 reduced width
  });

  @override
  State<CommonSearchBar> createState() => _CommonSearchBarState();
}

class _CommonSearchBarState extends State<CommonSearchBar> {
  final FocusNode _focusNode = FocusNode();

  void _triggerSearch() {
    final query = widget.controller.text.trim();
    widget.onSearch?.call(query);
  }

  void _clearSearch() {
    widget.controller.clear();
    widget.onSearch?.call("");
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 40, // 🔽 compact height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: _focusNode.hasFocus ? Colors.blue : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _triggerSearch(),

        onChanged: (_) {
          setState(() {});
        },

        style: const TextStyle(fontSize: 14), // 🔽 smaller text

        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),

          // ❌ removed left icon

          // ✅ RIGHT SIDE ICONS
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔍 Search icon
              IconButton(
                icon: const Icon(Icons.search, size: 18),
                onPressed: _triggerSearch,
              ),

              // ❌ Clear icon
              if (widget.controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: _clearSearch,
                ),
            ],
          ),
        ),
      ),
    );
  }
}