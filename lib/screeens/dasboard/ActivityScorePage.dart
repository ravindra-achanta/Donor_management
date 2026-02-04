import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ActivityScoreScreen extends StatefulWidget {
  const ActivityScoreScreen({super.key});

  @override
  State<ActivityScoreScreen> createState() => _ActivityScoreScreenState();
}

class _ActivityScoreScreenState extends State<ActivityScoreScreen> {
  String selectedPeriod = "Week";

  // Sample data for cards and charts
  final Map<String, Map<String, String>> cardData = {
    "Week": {
      "Total Active Times": "15",
      "Profile Visits": "45",
      "Total Changes": "5",
    },
    "Month": {
      "Total Active Times": "60",
      "Profile Visits": "180",
      "Total Changes": "20",
    },
    "Year": {
      "Total Active Times": "720",
      "Profile Visits": "2100",
      "Total Changes": "250",
    },
  };

  final Map<String, List<double>> chartData = {
    "Week": [30, 50, 40, 60, 70, 90, 80],
    "Month": [100, 150, 120, 180, 200, 170, 190, 210, 160, 180, 200, 220],
    "Year": [1200, 1500, 1300, 1700, 1600, 1800, 1900, 2100, 2000, 2300, 2200, 2400],
  };

  List<String> getLabels(String period) {
    if (period == "Week") return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    if (period == "Month") return List.generate(12, (i) => "W${i + 1}");
    if (period == "Year") return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.show_chart, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        "Activity Score",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // ===== RANGE SELECTOR =====
              Row(
                children: ["Week", "Month", "Year"].map((e) {
                  final isSelected = selectedPeriod == e;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(e),
                      selected: isSelected,
                      selectedColor: Colors.blue.shade100,
                      onSelected: (_) => setState(() => selectedPeriod = e),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // ===== STATS CARDS =====
              Row(
                children: [
                  _statCard(
                    title: "TOTAL ACTIVE TIMES",
                    value: cardData[selectedPeriod]!["Total Active Times"]!,
                  ),
                  const SizedBox(width: 16),
                  _statCard(
                    title: "PROFILE VISITS",
                    value: cardData[selectedPeriod]!["Profile Visits"]!,
                  ),
                  const SizedBox(width: 16),
                  _statCard(
                    title: "TOTAL CHANGES",
                    value: cardData[selectedPeriod]!["Total Changes"]!,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ===== LINE CHART =====
              Container(
                height: 280,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Activity Trend",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Shows your activity score over time",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: (chartData[selectedPeriod]!.length - 1).toDouble(),
                          minY: 0,
                          maxY: chartData[selectedPeriod]!
                              .reduce((a, b) => a > b ? a : b) * 1.2,
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: false,
                            horizontalInterval: chartData[selectedPeriod]!
                                .reduce((a, b) => a > b ? a : b) / 4,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.shade300,
                                strokeWidth: 1,
                                dashArray: [4, 4],
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 36,
                                interval: selectedPeriod == "Week" ? 1 : 2,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  List<String> labels = getLabels(selectedPeriod);
                                  if (index < labels.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        labels[index],
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }
                                  return const Text("");
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: chartData[selectedPeriod]!
                                    .reduce((a, b) => a > b ? a : b) / 4,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade700,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: chartData[selectedPeriod]!
                                  .asMap()
                                  .entries
                                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                                  .toList(),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: Colors.white,
                                    strokeWidth: 2,
                                    strokeColor: Colors.blue,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.1),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.blue.withOpacity(0.3),
                                    Colors.blue.withOpacity(0.1),
                                    Colors.blue.withOpacity(0.05),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.blue.shade50,
                              tooltipRoundedRadius: 8,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((touchedSpot) {
                                  final index = touchedSpot.spotIndex;
                                  final labels = getLabels(selectedPeriod);
                                  return LineTooltipItem(
                                    '${labels[index]}: ${touchedSpot.y.toInt()}',
                                    const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= STAT CARD =================
  Widget _statCard({
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}