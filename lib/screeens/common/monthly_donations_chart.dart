import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_bloc.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_event.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_state.dart';
import 'package:vikas_app/screeens/models/response/monthly_donations.dart';

class MonthlyDonationsChart extends StatefulWidget {
  final MonthlyDonationsResponse monthlyDonations;

  const MonthlyDonationsChart({
    Key? key,
    required this.monthlyDonations,
  }) : super(key: key);

  @override
  State<MonthlyDonationsChart> createState() => _MonthlyDonationsChartState();
}

class _MonthlyDonationsChartState extends State<MonthlyDonationsChart> {
  late int selectedYear;
  late List<int> availableYears;

  @override
  void initState() {
    super.initState();
    _initializeYears();
  }

  // void _initializeYears() {
  //   availableYears = widget.monthlyDonations.donations
  //       .map((d) => d.year)
  //       .toSet()
  //       .toList()
  //     ..sort((a, b) => b.compareTo(a));
    
  //   selectedYear = availableYears.isNotEmpty ? availableYears.first : DateTime.now().year;
  // }
  void _initializeYears() {
  availableYears = List.generate(8, (index) => 2030 - index);
  
  // Use current year (2026) as default
  selectedYear = DateTime.now().year;
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<DashboardBloc>().add(FetchMonthlyDonationsEvent(year: selectedYear));
  });
}

  List<MonthlyDonation> _getSelectedYearData() {
    return widget.monthlyDonations.donations
        .where((d) => d.year == selectedYear)
        .toList()
      ..sort((a, b) => a.month.compareTo(b.month));
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return month >= 1 && month <= 12 ? months[month - 1] : '';
  }

  void _onYearChanged(int newYear) {
    setState(() => selectedYear = newYear);
    // Fetch data for the selected year
    context.read<DashboardBloc>().add(FetchMonthlyDonationsEvent(year: newYear));
  }

  @override
  Widget build(BuildContext context) {
     return BlocBuilder<DashboardBloc, DashboardState>(
    builder: (context, state) {

      final selectedData = _getSelectedYearData();

      final maxAmount = selectedData.isNotEmpty
          ? selectedData
              .map((d) => d.totalAmount)
              .reduce((a, b) => a > b ? a : b)
          : 1000000.0;
    // final selectedData = _getSelectedYearData();
    // final maxAmount = selectedData.isNotEmpty
    //     ? selectedData.map((d) => d.totalAmount).reduce((a, b) => a > b ? a : b)
    //     : 1000000.0;

    return Container(
      padding: const EdgeInsets.all(20),
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
          // Header with title and year selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Donations Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // Year selector dropdown
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12),
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(8),
  ),
  child: DropdownButtonHideUnderline(
    child: DropdownButton<int>(
      value: selectedYear,
      dropdownColor: Colors.white,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.black,
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      onChanged: (int? newYear) {
        if (newYear != null) {
          _onYearChanged(newYear);
        }
      },
      items: availableYears.map((year) {
        return DropdownMenuItem<int>(
          value: year,
          child: Text(
            year.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        );
      }).toList(),
    ),
  ),
)
            ],
          ),
          const SizedBox(height: 24),
          
          // Chart
          // selectedData.isEmpty
          //     ? const Center(
          //         child: Padding(
          //           padding: EdgeInsets.all(40),
          //           child: Text('No data available for selected year'),
          //         ),
          //       )
          state.monthlyDonationStatus == DashboardApiStatus.loading
    ? const SizedBox(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
    : selectedData.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Text(
                'No data available for selected year',
              ),
            ),
          )
              : SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: maxAmount / 4,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade200,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              if (value % 1 != 0) return const SizedBox.shrink();
                              final monthIndex = value.toInt();
                              if (monthIndex < 0 || monthIndex > 11) return const SizedBox.shrink();
                              return Text(
                                _getMonthName(monthIndex + 1),
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                _formatAmount(value),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: Colors.grey.shade300),
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: selectedData.map((item) {
  return FlSpot(
    (item.month - 1).toDouble(),
    item.totalAmount,
  );
}).toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                              radius: 4,
                              color: Colors.blue,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withOpacity(0.1),
                          ),
                        ),
                      ],
                      minX: 0,
                      maxX: 11,
                      minY: 0,
                      maxY: maxAmount * 1.1,
                    ),
                  ),
                ),
        ],
        ),
      );
    },
  );
}

  String _formatAmount(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
