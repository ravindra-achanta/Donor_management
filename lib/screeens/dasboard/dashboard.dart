import 'package:flutter/material.dart';
import 'package:vikas_app/screeens/dasboard/ActivityScorePage.dart';
import 'package:vikas_app/screeens/dasboard/DonationsReportScreen.dart';
import 'package:vikas_app/screeens/dasboard/profile_analytics_screen.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedRange = "Week";
  bool _showAllChanges = false;
  
  // Sample data for recent profile changes
  final List<ProfileChange> recentChanges = [
    ProfileChange(
      karyakarthaName: 'Rajesh Kumar',
      jeevandiId: 'JEEV001234',
      jeevandiName: 'Sri Rajesh Jeevandi',
      changePercentage: 95,
    ),
    ProfileChange(
      karyakarthaName: 'Priya Sharma',
      jeevandiId: 'JEEV001235',
      jeevandiName: 'Smt. Priya Jeevandi',
      changePercentage: 100,
    ),
    ProfileChange(
      karyakarthaName: 'Amit Patel',
      jeevandiId: 'JEEV001236',
      jeevandiName: 'Sri Amit Jeevandi',
      changePercentage: 85,
    ),
    ProfileChange(
      karyakarthaName: 'Sneha Reddy',
      jeevandiId: 'JEEV001237',
      jeevandiName: 'Smt. Sneha Jeevandi',
      changePercentage: 92,
    ),
    ProfileChange(
      karyakarthaName: 'Vikram Singh',
      jeevandiId: 'JEEV001238',
      jeevandiName: 'Sri Vikram Jeevandi',
      changePercentage: 100,
    ),
    ProfileChange(
      karyakarthaName: 'Anjali Mehta',
      jeevandiId: 'JEEV001239',
      jeevandiName: 'Smt. Anjali Jeevandi',
      changePercentage: 78,
    ),
    ProfileChange(
      karyakarthaName: 'Rahul Verma',
      jeevandiId: 'JEEV001240',
      jeevandiName: 'Sri Rahul Jeevandi',
      changePercentage: 88,
    ),
  ];

  List<ProfileChange> get displayedChanges {
    return _showAllChanges ? recentChanges : recentChanges.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  _buildRangeSelector(),
                ],
              ),
              const SizedBox(height: 24),

              // ================= TOP STATS (8 CARDS) =================
              _buildStatsGrid(),
              const SizedBox(height: 24),

              // ================= MEMBERS GRID =================
              _buildMembersGrid(),
              const SizedBox(height: 32),

              // ================= RECENT PROFILE CHANGES SECTION =================
              _buildRecentChangesSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= RECENT PROFILE CHANGES SECTION =================
  Widget _buildRecentChangesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Profile Changes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _showAllChanges = !_showAllChanges;
                });
              },
              icon: Icon(
                _showAllChanges ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
              ),
              label: Text(
                _showAllChanges ? "View Less" : "View More",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Table-like container
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Karyakartha Name",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          "J.ID",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: Text(
                          "Jeevanadi Name",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          "% Change",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          "Action",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Table Rows
              ...displayedChanges.map((change) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade100,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Karyakartha Name
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            change.karyakarthaName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                      // Jeevandi ID
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.blue.shade200,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              change.jeevandiId,
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Jeevandi Name
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            change.jeevandiName,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // Percentage of Change
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getPercentageColor(change.changePercentage)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  size: 14,
                                  color: _getPercentageColor(
                                      change.changePercentage),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${change.changePercentage}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _getPercentageColor(
                                        change.changePercentage),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Action Icon
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              _showProfileDetails(change);
                            },
                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 20,
                              color: Colors.blue,
                            ),
                            tooltip: "View Details",
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  // Function to show profile details
  void _showProfileDetails(ProfileChange change) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          change.karyakarthaName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Jeevandi ID:", change.jeevandiId),
              const SizedBox(height: 12),
              _buildDetailRow("Jeevandi Name:", change.jeevandiName),
              const SizedBox(height: 12),
              _buildDetailRow("Profile Completion:",
                  "${change.changePercentage}%"),
              const SizedBox(height: 16),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  widthFactor: change.changePercentage / 100,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getPercentageColor(change.changePercentage),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to full profile view
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              "View Full Profile",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Color _getPercentageColor(int percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 75) return Colors.blue.shade600;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  // ================= RANGE SELECTOR =================
  Widget _buildRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: ["Week", "Month", "Year"].map((item) {
          final isSelected = selectedRange == item;
          return GestureDetector(
            onTap: () => setState(() => selectedRange = item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ================= TOP STATS GRID =================
  Widget _buildStatsGrid() {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.35,
      ),
      children: [
        // -------- FIRST 4 (NO VIEW ICON) --------
        _statCard(
          title: "Total Donations",
          value: "₹12,53,978",
          trend: "↑ 12%",
          trendColor: Colors.green,
          icon: Icons.account_balance_wallet,
          color: Colors.blue,
        ),
        _statCard(
          title: "TOTAL JEEVANDI MEMBERS",
          value: "4500",
          trend: "↓ 6%",
          trendColor: Colors.red,
          icon: Icons.people,
          color: Colors.green,
        ),
        _statCard(
          title: "TOTAL KARYAKATHS ",
          value: "90",
          trend: "Active",
          trendColor: Colors.blue,
          icon: Icons.confirmation_number,
          color: Colors.purple,
        ),
        _statCard(
          title: "New jeevandi Members",
          value: "+12",
          trend: "Today",
          trendColor: Colors.green,
          icon: Icons.person_add,
          color: Colors.orange,
        ),

        // -------- NEXT 4 (WITH VIEW ICON) --------
        _statCard(
          title: "Total Karyakarthas",
          value: "24",
          trend: "Active",
          trendColor: Colors.green,
          icon: Icons.supervisor_account,
          color: Colors.indigo,
          showViewIcon: true,
          onView: () {},
        ),
        _statCard(
          title: "Activity Score",
          value: "87%",
          trend: "↑ 5%",
          trendColor: Colors.green,
          icon: Icons.trending_up,
          color: Colors.teal,
          showViewIcon: true,
          onView: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => const ActivityScoreScreen(),
              ),
            );
          },
        ),
        _statCard(
          title: "Total Profile Activity",
          value: "92%",
          trend: "Completed",
          trendColor: Colors.blue,
          icon: Icons.assignment_turned_in,
          color: Colors.purple,
          showViewIcon: true,
          onView: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => const ProfileAnalyticsScreen(),
              ),
            );
          },
        ),
        _statCard(
          title: "Donations",
          value: "₹22,23,374",
          trend: "↑ 68%",
          trendColor: Colors.green,
          icon: Icons.account_balance_wallet,
          color: Colors.orange,
          showViewIcon: true,
          onView: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => const DonationsReportScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ================= MEMBER GRID =================
  Widget _buildMembersGrid() {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.6,
      ),
      children: [
        // Uncomment if you want to show these cards
        // _memberCard("Active Members", "4636", Colors.green, Icons.people),
        // _memberCard(
        //     "Inactive Members", "19", Colors.orange, Icons.people_outline),
        // _memberCard("Deleted Members", "0", Colors.red, Icons.delete),
        // _memberCard("Total Members", "4655", Colors.blue, Icons.groups),
      ],
    );
  }

  // ================= STAT CARD =================
  Widget _statCard({
    required String title,
    required String value,
    required String trend,
    required Color trendColor,
    required IconData icon,
    required Color color,
    bool showViewIcon = false,
    VoidCallback? onView,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconBox(icon, color),
                Row(
                  children: [
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: trendColor,
                      ),
                    ),
                    if (showViewIcon) ...[
                      const SizedBox(width: 6),
                      IconButton(
                        tooltip: "View Chart",
                        icon: const Icon(Icons.bar_chart, size: 18),
                        onPressed: onView,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= MEMBER CARD =================
  Widget _memberCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _iconBox(icon, color),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ICON BOX =================
  Widget _iconBox(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

// Data model for profile changes
class ProfileChange {
  final String karyakarthaName;
  final String jeevandiId;
  final String jeevandiName;
  final int changePercentage;

  ProfileChange({
    required this.karyakarthaName,
    required this.jeevandiId,
    required this.jeevandiName,
    required this.changePercentage,
  });
}