import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double screenWidth; 

   StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define scaling factor based on screen width
    double scale = 1.0;
    if (screenWidth < 600) {
      scale = 0.8; // Smaller on very narrow screens
    } else if (screenWidth < 900) {
      scale = 0.9; // Slightly smaller on medium screens
    }

    // Responsive values
    final double horizontalPadding = 20 * scale;
    final double verticalPadding = 16 * scale; // Keep balanced
    final double iconSize = 24 * scale;
    final double iconContainerSize = 40 * scale; // approx padding *2 + iconSize
    final double titleFontSize = 13 * scale;
    final double valueFontSize = 24 * scale;
    final double spacing = 16 * scale;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(iconContainerSize * 0.25), // ~10*scale
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: iconSize),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   
                    SizedBox(height: 4 * scale),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}