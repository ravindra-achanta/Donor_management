import 'package:flutter/material.dart';

class DonationStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final double screenWidth;

  const DonationStatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
    required this.screenWidth,
  }) : super(key: key);

  /// Format number with thousand separators
  String _formatNumberWithSeparators(String value) {
    try {
      final cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
      
      if (cleanValue.isEmpty) return value;
      
      final num = double.parse(cleanValue);
      
      // Remove trailing zeros
      String formatted;
      if (num == num.toInt()) {
        formatted = num.toInt().toString();
      } else {
        formatted = num.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
      }
      
      // Add thousand separators
      final parts = formatted.split('.');
      final intPart = parts[0].replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => ',',
      );
      
      if (parts.length > 1) {
        return '$intPart.${parts[1]}';
      }
      return intPart;
    } catch (e) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1.0;
    if (screenWidth < 600) {
      scale = 0.75;
    } else if (screenWidth < 900) {
      scale = 0.85;
    }

    final formattedValue = _formatNumberWithSeparators(value);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * scale,
        vertical: 16 * scale,
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Color accent bar at top
          Container(
            height: 3,
            width: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 8 * scale),
          
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11 * scale,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              height: 1.2,
            ),
          ),
          SizedBox(height: 10 * scale),
          
          // Large centered value
          Expanded(
            child: Center(
              child: Text(
                formattedValue,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 22 * scale,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.2,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}