import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class DonationsReportScreen extends StatefulWidget {
  const DonationsReportScreen({super.key});

  @override
  State<DonationsReportScreen> createState() => _DonationsReportScreenState();
}

class _DonationsReportScreenState extends State<DonationsReportScreen> {
  String selectedPeriod = "Week";
  String? selectedMember; // For dropdown filter

  // Sample data for cards and charts
  final Map<String, Map<String, String>> donationCards = {
    "Week": {
      "Total Donations": "₹15,000",
      "Total Donors": "12",
      "Average Donation": "₹1,250",
    },
    "Month": {
      "Total Donations": "₹60,000",
      "Total Donors": "45",
      "Average Donation": "₹1,333",
    },
    "Year": {
      "Total Donations": "₹7,20,000",
      "Total Donors": "500",
      "Average Donation": "₹1,440",
    },
  };

  final Map<String, List<double>> donationChartData = {
    "Week": [2000, 1500, 3000, 2500, 3500, 4000, 2500],
    "Month": [5000, 7000, 6000, 8000, 7500, 9000, 8500, 10000, 9500, 9000, 10500, 11000],
    "Year": [60000, 55000, 65000, 70000, 75000, 80000, 78000, 82000, 85000, 90000, 88000, 95000],
  };

  final Map<String, List<Map<String, dynamic>>> memberDonations = {
    "Week": [
      {"name": "Arun Kumar", "donation": 2500},
      {"name": "Meena Patel", "donation": 3000},
      {"name": "Ravi Shankar", "donation": 1500},
    ],
    "Month": [
      {"name": "Arun Kumar", "donation": 10000},
      {"name": "Meena Patel", "donation": 12000},
      {"name": "Ravi Shankar", "donation": 9000},
      {"name": "Priya Verma", "donation": 8000},
    ],
    "Year": [
      {"name": "Arun Kumar", "donation": 120000},
      {"name": "Meena Patel", "donation": 150000},
      {"name": "Ravi Shankar", "donation": 100000},
      {"name": "Priya Verma", "donation": 90000},
      {"name": "Kiran Sharma", "donation": 110000},
    ],
  };

  List<String> getLabels(String period) {
    if (period == "Week") return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    if (period == "Month") return List.generate(12, (i) => "M${i + 1}");
    if (period == "Year") return List.generate(12, (i) => "${2023 + i}");
    return [];
  }

  List<String> getMemberNames() {
    final members = memberDonations[selectedPeriod]!;
    return members.map((e) => e["name"] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Filtered members based on selected dropdown
    final filteredMembers = selectedMember == null
        ? memberDonations[selectedPeriod]!
        : memberDonations[selectedPeriod]!
            .where((e) => e["name"] == selectedMember)
            .toList();

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
                      Icon(Icons.volunteer_activism, color: Colors.orange),
                      SizedBox(width: 10),
                      Text(
                        "Donations Report",
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
                      selectedColor: Colors.orange.shade100,
                      onSelected: (_) => setState(() {
                        selectedPeriod = e;
                        selectedMember = null; // reset member filter
                      }),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // ===== DONATION CARDS =====
              Row(
                children: [
                  _statCard(
                    title: "TOTAL DONATIONS",
                    value: donationCards[selectedPeriod]!["Total Donations"]!,
                  ),
                  const SizedBox(width: 16),
                  _statCard(
                    title: "TOTAL DONORS",
                    value: donationCards[selectedPeriod]!["Total Donors"]!,
                  ),
                  const SizedBox(width: 16),
                  _statCard(
                    title: "AVG DONATION",
                    value: donationCards[selectedPeriod]!["Average Donation"]!,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ===== DONATIONS BAR CHART =====
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: donationChartData[selectedPeriod]!
                            .reduce((a, b) => a > b ? a : b) +
                        1000,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: true, reservedSize: 40)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            List<String> labels = getLabels(selectedPeriod);
                            if (index < labels.length) {
                              return Text(labels[index],
                                  style: const TextStyle(fontSize: 12));
                            }
                            return const Text("");
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(
                      donationChartData[selectedPeriod]!.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: donationChartData[selectedPeriod]![index],
                            color: Colors.orange,
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ===== MEMBER DROPDOWN =====
              Row(
                children: [
                  const Text(
                    "Select Member: ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: selectedMember,
                    hint: const Text("All Members"),
                    items: getMemberNames()
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedMember = val;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ===== MEMBER DONATION LIST =====
              const Text(
                "Member Donations",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  return _memberTile(member["name"], member["donation"]);
                },
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

  // ================= MEMBER TILE =================
  Widget _memberTile(String name, double donation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade100,
            child: Text(name[0]),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            "₹${donation.toStringAsFixed(0)}",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
