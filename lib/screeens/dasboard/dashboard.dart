import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/bloc_management/notices/notice_bloc.dart';
import 'package:vikas_app/bloc_management/notices/notice_event.dart';
import 'package:vikas_app/bloc_management/notices/notice_state.dart';
import 'package:vikas_app/screeens/common/notice_dilouge.dart';
import 'package:vikas_app/screeens/dasboard/ActivityScorePage.dart';
import 'package:vikas_app/screeens/dasboard/DonationsReportScreen.dart';
import 'package:vikas_app/screeens/dasboard/profile_analytics_screen.dart';
import 'package:vikas_app/screeens/models/response/notice_response.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedRange = "Week";
  bool _showAllChanges = false;

  // Notice queue management
  final List<NoticeResponse> _pendingNotices = [];
  int _currentNoticeIndex = 0;
  bool _isShowing = false; // prevents overlapping queues

  // Sample data for recent profile changes (unchanged)
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
  void initState() {
    super.initState();
    // Fetch notices when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoticeBloc>().add(FetchNoticesEvent());
    });
  }

  /// Starts showing the notice queue
  void _startNoticeQueue(List<NoticeResponse> notices) {
    if (notices.isEmpty || _isShowing) return;
    _pendingNotices.clear();
    _pendingNotices.addAll(notices);
    _currentNoticeIndex = 0;
    _isShowing = true;
    _showNextNotice();
  }

  /// Displays the next notice in the queue
  void _showNextNotice() {
    if (_currentNoticeIndex >= _pendingNotices.length) {
      // No more notices
      _isShowing = false;
      return;
    }
    if (!mounted) return;

    final notice = _pendingNotices[_currentNoticeIndex];

    NoticePopup.show(
      context: context,
      imageUrl: notice.image ?? '',
      title: notice.title,
      description: notice.description,
      cancelText: "OK",
      onClosed: () {
        // Mark this notice as read
        context.read<NoticeBloc>().add(MarkNoticeReadEvent(notice.id));
        // Move to next notice
        if (mounted) {
          setState(() {
            _currentNoticeIndex++;
          });
          // Small delay before showing the next one (optional)
          Future.delayed(const Duration(milliseconds: 300), _showNextNotice);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: BlocListener<NoticeBloc, NoticeState>(
        listener: (context, state) {
          if (state.status == NoticeStatus.success && state.notices.isNotEmpty) {
            _startNoticeQueue(state.notices);
          }
          if (state.status == NoticeStatus.failure) {
            debugPrint('Failed to load notices: ${state.errorMessage}');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with range selector
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

                // Stats grid
                _buildStatsGrid(),
                const SizedBox(height: 24),

                // Members grid (currently empty)
                _buildMembersGrid(),
                const SizedBox(height: 32),

                // Recent profile changes section
                _buildRecentChangesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // All the UI helper methods remain exactly as in the original dashboard
  // -------------------------------------------------------------------------

  Widget _buildRecentChangesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Profile Changes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              // Header row
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
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

              // Data rows
              ...displayedChanges.map((change) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade100, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
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

                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getPercentageColor(
                                change.changePercentage,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  size: 14,
                                  color: _getPercentageColor(
                                    change.changePercentage,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${change.changePercentage}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _getPercentageColor(
                                      change.changePercentage,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

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
              _buildDetailRow(
                "Profile Completion:",
                "${change.changePercentage}%",
              ),
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
            child: const Text("Close", style: TextStyle(fontSize: 14)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
      children: const [],
    );
  }

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

// Data model for profile changes (keep as is)
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

// import 'package:flutter/material.dart';
// import 'package:vikas_app/api_services/network_repos/notice_repo.dart';
// import 'package:vikas_app/screeens/common/notice_dilouge.dart';
// import 'package:vikas_app/screeens/dasboard/ActivityScorePage.dart';
// import 'package:vikas_app/screeens/dasboard/DonationsReportScreen.dart';
// import 'package:vikas_app/screeens/dasboard/profile_analytics_screen.dart';
// import 'package:vikas_app/screeens/models/response/notice_response.dart';
// import 'package:vikas_app/views/layouts/layout.dart';

// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   String selectedRange = "Week";
//   bool _showAllChanges = false;

//   // ── NEW: notices queue ──────────────────────────────────────────────────────
//   final NoticeRepo _noticeRepo = NoticeRepo();
//   List<NoticeResponse> _pendingNotices = [];
//   int _currentNoticeIndex = 0;
//   // ────────────────────────────────────────────────────────────────────────────

//   // Sample data for recent profile changes
//   final List<ProfileChange> recentChanges = [
//     ProfileChange(
//       karyakarthaName: 'Rajesh Kumar',
//       jeevandiId: 'JEEV001234',
//       jeevandiName: 'Sri Rajesh Jeevandi',
//       changePercentage: 95,
//     ),
//     ProfileChange(
//       karyakarthaName: 'Priya Sharma',
//       jeevandiId: 'JEEV001235',
//       jeevandiName: 'Smt. Priya Jeevandi',
//       changePercentage: 100,
//     ),
//     ProfileChange(
//       karyakarthaName: 'Amit Patel',
//       jeevandiId: 'JEEV001236',
//       jeevandiName: 'Sri Amit Jeevandi',
//       changePercentage: 85,
//     ),
//     ProfileChange(
//       karyakarthaName: 'Sneha Reddy',
//       jeevandiId: 'JEEV001237',
//       jeevandiName: 'Smt. Sneha Jeevandi',
//       changePercentage: 92,
//     ),
//     ProfileChange(
//       karyakarthaName: 'Vikram Singh',
//       jeevandiId: 'JEEV001238',
//       jeevandiName: 'Sri Vikram Jeevandi',
//       changePercentage: 100,
//     ),
//     ProfileChange(
//       karyakarthaName: 'Anjali Mehta',
//       jeevandiId: 'JEEV001239',
//       jeevandiName: 'Smt. Anjali Jeevandi',
//       changePercentage: 78,
//     ),
//     ProfileChange(
//       karyakarthaName: 'Rahul Verma',
//       jeevandiId: 'JEEV001240',
//       jeevandiName: 'Sri Rahul Jeevandi',
//       changePercentage: 88,
//     ),
//   ];

//   List<ProfileChange> get displayedChanges {
//     return _showAllChanges ? recentChanges : recentChanges.take(5).toList();
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       //_showMaintenancePopup();
//       _fetchAndShowNotices();
//     });
//   }

//   // void _showMaintenancePopup() {
//   //   NoticePopup.show(
//   //     context: context,
//   //     imageUrl: "https://images.unsplash.com/photo-1519389950473-47ba0277781c",
//   //     title: "Scheduled System Maintenance",
//   //     description:
//   //         "Our platform will undergo scheduled maintenance today from 12:00 AM to 2:00 AM.\n"
//   //         "During this time, some features may be temporarily unavailable.\n"
//   //         "Thank you for your patience.",
//   //     onClosed: _fetchAndShowNotices, 
//   //   );
//   // }

//   Future<void> _fetchAndShowNotices() async {
//     if (!mounted) return;

//     final result = await _noticeRepo.getNotices();

//     if (!mounted) return;

//     if (result.isSuccess && result.data != null && result.data!.isNotEmpty) {
//       _pendingNotices = result.data!;
//       _currentNoticeIndex = 0;
//       _showNextNotice();
//     }
//   }

//   void _showNextNotice() {
//     if (_currentNoticeIndex >= _pendingNotices.length) return;

//     if (!mounted) return;

//     final notice = _pendingNotices[_currentNoticeIndex];

//     NoticePopup.show(
//       context: context,
//       imageUrl: notice.image ?? '',
//       title: notice.title,
//       description: notice.description,
//       cancelText: "OK",
//       onClosed: () {
//         _currentNoticeIndex++;
//         _showNextNotice(); 
//       },
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Layout(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Dashboard",
//                     style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//                   ),
//                   _buildRangeSelector(),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               _buildStatsGrid(),
//               const SizedBox(height: 24),

//               _buildMembersGrid(),
//               const SizedBox(height: 32),

//               _buildRecentChangesSection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRecentChangesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               "Recent Profile Changes",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             TextButton.icon(
//               onPressed: () {
//                 setState(() {
//                   _showAllChanges = !_showAllChanges;
//                 });
//               },
//               icon: Icon(
//                 _showAllChanges ? Icons.arrow_upward : Icons.arrow_downward,
//                 size: 16,
//               ),
//               label: Text(
//                 _showAllChanges ? "View Less" : "View More",
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),

//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 blurRadius: 8,
//                 spreadRadius: 1,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     topRight: Radius.circular(12),
//                   ),
//                   border: Border(
//                     bottom: BorderSide(color: Colors.grey.shade200, width: 1),
//                   ),
//                 ),
//                 child: const Row(
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 8.0),
//                         child: Text(
//                           "Karyakartha Name",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Center(
//                         child: Text(
//                           "J.ID",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 6.0),
//                         child: Text(
//                           "Jeevanadi Name",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Center(
//                         child: Text(
//                           "% Change",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Center(
//                         child: Text(
//                           "Action",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               ...displayedChanges.map((change) {
//                 return Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 18,
//                   ),
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey.shade100, width: 1),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 8.0),
//                           child: Text(
//                             change.karyakarthaName,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ),
//                       ),

//                       Expanded(
//                         flex: 2,
//                         child: Center(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 5,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.shade50,
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(
//                                 color: Colors.blue.shade200,
//                                 width: 1,
//                               ),
//                             ),
//                             child: Text(
//                               change.jeevandiId,
//                               style: TextStyle(
//                                 color: Colors.blue.shade800,
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       Expanded(
//                         flex: 2,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 8.0),
//                           child: Text(
//                             change.jeevandiName,
//                             style: TextStyle(
//                               color: Colors.grey.shade700,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),

//                       Expanded(
//                         flex: 2,
//                         child: Center(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: _getPercentageColor(
//                                 change.changePercentage,
//                               ).withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.trending_up,
//                                   size: 14,
//                                   color: _getPercentageColor(
//                                     change.changePercentage,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   '${change.changePercentage}%',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: _getPercentageColor(
//                                       change.changePercentage,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),

//                       Expanded(
//                         flex: 2,
//                         child: Center(
//                           child: IconButton(
//                             onPressed: () {
//                               _showProfileDetails(change);
//                             },
//                             icon: const Icon(
//                               Icons.visibility_outlined,
//                               size: 20,
//                               color: Colors.blue,
//                             ),
//                             tooltip: "View Details",
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   void _showProfileDetails(ProfileChange change) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           change.karyakarthaName,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         content: Container(
//           width: double.maxFinite,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildDetailRow("Jeevandi ID:", change.jeevandiId),
//               const SizedBox(height: 12),
//               _buildDetailRow("Jeevandi Name:", change.jeevandiName),
//               const SizedBox(height: 12),
//               _buildDetailRow(
//                 "Profile Completion:",
//                 "${change.changePercentage}%",
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: FractionallySizedBox(
//                   widthFactor: change.changePercentage / 100,
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: _getPercentageColor(change.changePercentage),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Close", style: TextStyle(fontSize: 14)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text(
//               "View Full Profile",
//               style: TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 120,
//           child: Text(
//             label,
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade600,
//               fontSize: 14,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//               fontSize: 14,
//               color: Colors.black87,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Color _getPercentageColor(int percentage) {
//     if (percentage >= 90) return Colors.green;
//     if (percentage >= 75) return Colors.blue.shade600;
//     if (percentage >= 50) return Colors.orange;
//     return Colors.red;
//   }

//   Widget _buildRangeSelector() {
//     return Container(
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Row(
//         children: ["Week", "Month", "Year"].map((item) {
//           final isSelected = selectedRange == item;
//           return GestureDetector(
//             onTap: () => setState(() => selectedRange = item),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.blue : Colors.transparent,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 item,
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: isSelected ? Colors.white : Colors.grey.shade700,
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildStatsGrid() {
//     return GridView(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 1.35,
//       ),
//       children: [
//         _statCard(
//           title: "Total Donations",
//           value: "₹12,53,978",
//           trend: "↑ 12%",
//           trendColor: Colors.green,
//           icon: Icons.account_balance_wallet,
//           color: Colors.blue,
//         ),
//         _statCard(
//           title: "TOTAL JEEVANDI MEMBERS",
//           value: "4500",
//           trend: "↓ 6%",
//           trendColor: Colors.red,
//           icon: Icons.people,
//           color: Colors.green,
//         ),
//         _statCard(
//           title: "TOTAL KARYAKATHS ",
//           value: "90",
//           trend: "Active",
//           trendColor: Colors.blue,
//           icon: Icons.confirmation_number,
//           color: Colors.purple,
//         ),
//         _statCard(
//           title: "New jeevandi Members",
//           value: "+12",
//           trend: "Today",
//           trendColor: Colors.green,
//           icon: Icons.person_add,
//           color: Colors.orange,
//         ),

//         _statCard(
//           title: "Total Karyakarthas",
//           value: "24",
//           trend: "Active",
//           trendColor: Colors.green,
//           icon: Icons.supervisor_account,
//           color: Colors.indigo,
//           showViewIcon: true,
//           onView: () {},
//         ),
//         _statCard(
//           title: "Activity Score",
//           value: "87%",
//           trend: "↑ 5%",
//           trendColor: Colors.green,
//           icon: Icons.trending_up,
//           color: Colors.teal,
//           showViewIcon: true,
//           onView: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 fullscreenDialog: true,
//                 builder: (_) => const ActivityScoreScreen(),
//               ),
//             );
//           },
//         ),
//         _statCard(
//           title: "Total Profile Activity",
//           value: "92%",
//           trend: "Completed",
//           trendColor: Colors.blue,
//           icon: Icons.assignment_turned_in,
//           color: Colors.purple,
//           showViewIcon: true,
//           onView: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 fullscreenDialog: true,
//                 builder: (_) => const ProfileAnalyticsScreen(),
//               ),
//             );
//           },
//         ),
//         _statCard(
//           title: "Donations",
//           value: "₹22,23,374",
//           trend: "↑ 68%",
//           trendColor: Colors.green,
//           icon: Icons.account_balance_wallet,
//           color: Colors.orange,
//           showViewIcon: true,
//           onView: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 fullscreenDialog: true,
//                 builder: (_) => const DonationsReportScreen(),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildMembersGrid() {
//     return GridView(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 1.6,
//       ),
//       children: const [],
//     );
//   }

//   Widget _statCard({
//     required String title,
//     required String value,
//     required String trend,
//     required Color trendColor,
//     required IconData icon,
//     required Color color,
//     bool showViewIcon = false,
//     VoidCallback? onView,
//   }) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _iconBox(icon, color),
//                 Row(
//                   children: [
//                     Text(
//                       trend,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: trendColor,
//                       ),
//                     ),
//                     if (showViewIcon) ...[
//                       const SizedBox(width: 6),
//                       IconButton(
//                         tooltip: "View Chart",
//                         icon: const Icon(Icons.bar_chart, size: 18),
//                         onPressed: onView,
//                       ),
//                     ],
//                   ],
//                 ),
//               ],
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   title,
//                   style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _memberCard(String title, String value, Color color, IconData icon) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _iconBox(icon, color),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================= ICON BOX =================
//   Widget _iconBox(IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Icon(icon, color: color, size: 20),
//     );
//   }
// }

// // Data model for profile changes
// class ProfileChange {
//   final String karyakarthaName;
//   final String jeevandiId;
//   final String jeevandiName;
//   final int changePercentage;

//   ProfileChange({
//     required this.karyakarthaName,
//     required this.jeevandiId,
//     required this.jeevandiName,
//     required this.changePercentage,
//   });
// }