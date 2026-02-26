import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({
    super.key,
    required this.user,
    required this.onClose,
    required this.onViewMore,
    required this.onDelete,
    this.screenType,
  });

  final User? user;
  final String? screenType;
  final Function() onClose;
  final Function() onViewMore;
  final Function() onDelete;

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 580,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔷 Header
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.person, size: 28),
                        SizedBox(width: 8),
                        Text(
                          "${widget.user?.name} Demographic Info",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        widget.onClose();
                      },
                      child: Icon(Icons.close, color: Colors.red),
                    ),
                  ],
                ),
                buildDemoGrphs(),

                const SizedBox(height: 6),
                const Divider(),
                _sectionTitle('Basic Details'),
                Row(
                  children: [
                    Expanded(
                      child: _infoTile(
                        Icons.person_outline,
                        'Unique ID',
                        widget.user?.uniqueId ?? "1234",
                      ),
                    ),
                    Expanded(
                      child: _infoTile(
                        Icons.phone_outlined,
                        'Phone',
                        widget.user?.mobileNumber ?? "",
                      ),
                    ),
                  ],
                ),
                _infoTile(
                  Icons.location_on_outlined,
                  'Address',
                  _buildAddress(),
                ),
                const SizedBox(height: 16),

                // 🔷 Actions
                _sectionTitle('Actions'),
                const SizedBox(height: 4),

                Row(
                  children: [
                    if (widget.screenType != "JEEVANADI")
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            widget.onDelete();
                          },
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete'),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onViewMore();
                        },
                        icon: const Icon(Icons.more_horiz),
                        label: const Text('View more'),
                        
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDemoGrphs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Pie Chart
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: PieChart(
                    PieChartData(
                      sections: _getSections(),
                      centerSpaceRadius: 20,
                      sectionsSpace: 2,
                      startDegreeOffset: -90,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                buildDotContainer(Colors.orange, "Orange"),
                const SizedBox(height: 6),
                buildDotContainer(Colors.green, "Green"),
              ],
            ),
          ),

          const SizedBox(width: 24), // Space between Pie and bars
          // 🔹 Vertical Linear Bars
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "40%",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                LinearProgressBar(
                  maxSteps: 6,
                  progressType: ProgressType.linear,
                  currentStep: 3,
                  progressColor: Colors.black,
                  backgroundColor: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 12,
                ),
                const SizedBox(height: 12),
                Text(
                  "60%",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                LinearProgressBar(
                  maxSteps: 6,
                  progressType: ProgressType.linear,
                  currentStep: 4,
                  progressColor: Colors.red,
                  backgroundColor: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 12,
                ),
                const SizedBox(height: 20),
                buildDotContainer(Colors.black, "Activity"),
                const SizedBox(height: 6),
                buildDotContainer(Colors.red, "Attendance"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildDotContainer(Color color, String text) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          height: 12,
          width: 12,
        ),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.black)),
      ],
    );
  }

  List<PieChartSectionData> _getSections() {
    // Sample data: 40% blue, 30% orange, 30% green
    const double radius = 30; // Adjust the size of the sections

    return [
      PieChartSectionData(
        color: Colors.orange,
        value: 30,
        title: '25%',
        radius: radius,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 30,
        title: '25%',
        radius: radius,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }

  String _buildAddress() {
    final u = widget.user;

    if (u == null) return '-';

    final parts = [u.area, u.city, u.state, u.pincode, u.country];

    return parts
        .where((e) => e != null && e.toString().trim().isNotEmpty)
        .join(', ');
  }

  // 🔹 Reusable Section Title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  // 🔹 Reusable Info Row
  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
