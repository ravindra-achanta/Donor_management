import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_bloc.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_event.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_state.dart';
import 'package:vikas_app/screeens/models/request/JeevanaadiFullProfile.dart';
import 'package:vikas_app/screeens/models/response/Dharmasetu_view.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/screeens/models/response/visit_view.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({
    super.key,
    required this.data,
    required this.onClose,
    required this.onViewMore,
    required this.onDelete,
    required this.screenType,
  });

  final dynamic data;
  final String screenType;
  final Function() onClose;
  final Function() onViewMore;
  final Function() onDelete;

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  String screenType = "";

  Future<bool> isDeleteButtonVisible() async {
    String userType = await Vikasdb().getString("USER_TYPE");

    if (userType == 'SUPER_ADMIN' &&
            (screenType == "USER_PROFILE" || screenType == "DHARMASETU") ||
        screenType == "USER_PROFILE" ||
        screenType == "VISITS") {
      return true;
    }

    if (userType == 'ADMIN' && screenType == "USER_PROFILE") {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    dynamic data = widget.data;
    screenType = widget.screenType;
    VisitView? _visit = data is VisitView ? data : null;
    DharmasetuView? _dharmasetu = data is DharmasetuView ? data : null;
    User? _user = data is User ? data : null;

    JeevanaadiFullProfile? _jeevanaadiUser = data is JeevanaadiFullProfile
        ? data
        : null;
    String name = _user != null
        ? _user.name
        : _jeevanaadiUser != null
        ? _jeevanaadiUser.profileDetails.fullName
        : _visit != null
        ? _visit.visitorName
        : _dharmasetu != null
        ? _dharmasetu.communityName
        : "N/A";

    String email = _user != null
        ? _user.email
        : _jeevanaadiUser != null
        ? _jeevanaadiUser.basicDetails.email
        : _visit != null
        ? _visit.email
        : "N/A";

    String phoneNumber = _user != null
        ? _user.mobileNumber.toString()
        : _jeevanaadiUser != null
        ? _jeevanaadiUser.profileDetails.phoneNumber
        : _visit != null
        ? _visit.phoneNumber
        : "N/A";

    return Container(
      height: 600,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      // 👈 important
                      child: Row(
                        children: [
                          Icon(
                            screenType == "VISITS"
                                ? Icons.calendar_today
                                : screenType == "DHARMASETU"
                                ? Icons.volunteer_activism
                                : Icons.person,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              screenType == "VISITS"
                                  ? name
                                  : screenType == "DHARMASETU"
                                  ? name
                                  : "${name}'s Demographic Info:",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: widget.onClose,
                      child: const Icon(Icons.close, color: Colors.red),
                    ),
                  ],
                ),

                if (screenType == "JEEVANAADI_PROFILE" ||
                    screenType == "USER_PROFILE")
                  buildDemoGrphs(_jeevanaadiUser ?? _user),

                // const SizedBox(height: 6),
                const Divider(),

                if (screenType == "VISITS" && _visit != null) ...[
                  _sectionTitle('Visit Information'),

                  // Row 1: ID and Visitor Name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _infoTile(
                          Icons.person_outline,
                          'Visitor Name',
                          _visit.visitorName,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _infoTile(
                          Icons.info_outline,
                          'Visit Purpose',
                          _visit!.visitPurpose,
                        ),
                      ),
                    ],
                  ),

                  // Row 4: Number of Guests and Existing Visitor
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _infoTile(
                          Icons.group,
                          'Number of Guests',
                          _visit.noOfGuests.toString(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Expanded(
                      //   child: _infoTile(
                      //     Icons.check_circle_outline,
                      //     'Existing Visitor',
                      //     _visit.existVisitor ? 'Yes' : 'No',

                      //     //valueColor: Colors.green,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _infoTile(
                    Icons.comment_outlined,
                    'Comments',
                    _visit!.comments.isEmpty ? 'No comments' : _visit!.comments,
                  ),
                ],

                if (screenType == "DHARMASETU" && _dharmasetu != null) ...[
                  _sectionTitle('Dharmasetu Information'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _infoTile(
                          Icons.category,
                          'Type',
                          _dharmasetu.type ?? 'N/A',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _infoTile(
                          Icons.feedback_outlined,
                          'Feedback',
                          _dharmasetu.feedback,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _infoTile(
                          Icons.calendar_today,
                          'Date',
                          _dharmasetu!.date,
                        ),
                      ),
                    ],
                  ),
                  _infoTile(
                    Icons.person,
                    'Referred By',
                    _dharmasetu.referredBy,
                  ),
                  const SizedBox(height: 16),
                ],

                if (screenType == "JEEVANAADI_PROFILE") ...[
                  _sectionTitle('Basic Details'),
                  Row(
                    children: [
                      Expanded(
                        child: _infoTile(
                          Icons.person_outline,
                          'Jeevanadi No',
                          _jeevanaadiUser?.basicDetails.jeevanadiNo ?? "N/A",
                        ),
                      ),
                      // Expanded(
                      //   child: _infoTile(
                      //     Icons.person_outline,
                      //     'Jeevanadi No',
                      //     _jeevanaadiUser?.basicDetails.jeevanadiNo ?? "N/A",
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Common Row : Phone Number and Email
                if (screenType != "DARMASETU")
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _infoTile(
                          Icons.phone_outlined,
                          'Phone Number',
                          phoneNumber,
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (screenType != "DARMASETU")
                        Expanded(
                          child: _infoTile(
                            Icons.email_outlined,
                            'Email',
                            email,
                          ),
                        ),
                    ],
                  ),
                if (screenType != "DARMASETU" && screenType != "VISITS")
                  _infoTile(
                    Icons.location_on_outlined,
                    'Address',
                    _buildAddress(
                      screenType == "JEEVANAADI_PROFILE"
                          ? _jeevanaadiUser?.profileDetails
                          : _user,
                    ),
                  ),
                const SizedBox(height: 16),
                if (screenType == "USER_PROFILE" &&
                    _user != null &&
                    _user.userTypes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _sectionTitle('User Roles'),
                  _buildUserTypesChips(_user.userTypes),
                ],

                const SizedBox(height: 16),

                // Actions - Show for all screen types
                if (screenType != "DARMASETU" && screenType != "VISITS")
                  _sectionTitle('Actions'),
                const SizedBox(height: 4),
                if (screenType != "DARMASETU" && screenType != "VISITS" ||
                    screenType == "kart")
                  Row(
                    children: [
                      // FutureBuilder<bool>(
                      //   future: isDeleteButtonVisible(),
                      //   builder: (context, snapshot) {
                      //     if (!snapshot.hasData || snapshot.data == false) {
                      //       return const SizedBox();
                      //     }

                      //     return Expanded(
                      //       child: OutlinedButton.icon(
                      //         onPressed: () {
                      //           widget.onDelete();
                      //         },
                      //         icon: const Icon(
                      //           Icons.delete_outline,
                      //           color: Colors.white,
                      //         ),
                      //         label: Text(
                      //           screenType == "VISIT"
                      //               ? 'Delete Visit'
                      //               : 'Delete',
                      //           style: const TextStyle(color: Colors.white),
                      //         ),
                      //         style: OutlinedButton.styleFrom(
                      //           backgroundColor: const Color.fromARGB(
                      //             255,
                      //             255,
                      //             103,
                      //             92,
                      //           ),
                      //           shape: const RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.all(
                      //               Radius.circular(8),
                      //             ),
                      //           ),
                      //           padding: const EdgeInsets.symmetric(
                      //             vertical: 14,
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            widget.onViewMore();
                          },
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                          ),
                          label: Text(
                            screenType == "VISIT"
                                ? 'View Full Details'
                                //: 'Click to view more actions',
                                : 'More Actions',
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // background color
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
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

  String _buildAddress(address) {
    final u = address;
    if (u == null) return '-';
    final parts = [
      screenType == "JEEVANAADI_PROFILE" ? address.address : u.area,
      u.city,
      u.state,
      u.pincode,
      u.country,
    ];
    return parts
        .where((e) => e != null && e.toString().trim().isNotEmpty)
        .join(', ');
  }

  Widget buildDemoGrphs(dynamic jeevanaadiUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: screenType == "JEEVANAADI_PROFILE"
          ? buildJeevandiDemographs(jeevanaadiUser)
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (screenType == "USER_PROFILE") ...[
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.assignment_ind,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              softWrap: true,
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  const TextSpan(
                                    text: "Karyakartha Assignments: ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "${jeevanaadiUser.karyakarthaAssignCount}",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Text("User Activity"),
                // LinearProgressIndicator(
                //   value: 0.5,

                //   backgroundColor: Colors.grey[300],
                //   valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                // ),
              ],
            ),
    );
  }

  Widget buildJeevandiDemographs(dynamic jeevanaadiUser) {
    context.read<DashboardBloc>().add(
      FetchDonationMetricsEvent(id: jeevanaadiUser.profileDetails.userId),
    );
    return BlocBuilder<DashboardBloc, DashboardState?>(
      builder: (context, state) {
        return Column(
          children: [
            ProfileScoreCard(
              scores:
                  jeevanaadiUser
                      .jeevanaadiDemoGraphicDetails
                      .percentageHistory
                      .isNotEmpty
                  ? jeevanaadiUser
                        .jeevanaadiDemoGraphicDetails
                        .percentageHistory
                  : [
                      jeevanaadiUser
                          .jeevanaadiDemoGraphicDetails
                          .profileCompletionPercentage,
                    ],
            ),
            _sectionTitle('Donation Metrics'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _infoTile(
                    Icons.feedback_outlined,
                    'Avg Donation Frequency',
                    "${state?.donationMetrics?.monthlyAvgFrequency ?? "N/A"} times/monthly ",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _infoTile(
                    Icons.calendar_today,
                    'Avg Donation Amount',
                    "₹${state?.donationMetrics?.monthlyAmountAvgFrequency?.toStringAsFixed(2) ?? "N/A"}",
                  ),
                ),
              ],
            ),
            _infoTile(
              Icons.feedback_outlined,
              'Total Donation Amount',
              "₹ ${state?.donationMetrics?.totalContributions?.toStringAsFixed(2) ?? "N/A"} ",
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserTypesChips(List<String> userTypes) {
    if (userTypes.isEmpty) return const Text('-');
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: userTypes.map((type) {
        return Chip(
          label: Text(
            type,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: _getUserTypeColor(type),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  Color _getUserTypeColor(String userType) {
    switch (userType.toUpperCase()) {
      case 'SUPER_ADMIN':
        return Colors.red;
      case 'ADMIN':
        return Colors.orange;
      case 'KARYAKARTHA':
        return Colors.blue;
      case 'OFFICE_STAFF':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

Widget buildDotContainer(Color color, String text) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        height: 12,
        width: 12,
      ),
      const SizedBox(width: 6),
      Text(text, style: TextStyle(color: Colors.black), maxLines: 1),
    ],
  );
}

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

Widget _infoTile(
  IconData icon,
  String label,
  String value, {
  Color? valueColor,
}) {
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ProfileScoreCard extends StatelessWidget {
  ProfileScoreCard({super.key, required this.scores});

  final List<double> scores;

  bool get isDownTrend {
    if (scores.length < 2) return false;
    return scores.last < scores[scores.length - 2];
  }

  double get lastScore {
    if (scores.isEmpty) return 0;
    return scores.last;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Profile Score",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "${lastScore.toInt()}%",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (scores.length >= 2) ...[
                        const SizedBox(width: 6),
                        Icon(
                          isDownTrend
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: isDownTrend ? Colors.red : Colors.green,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              height: 50,
              child: scores.isEmpty
                  ? const Center(child: Text("No Data"))
                  : LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 100,
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 2,
                            spots: scores
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value))
                                .toList(),
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
