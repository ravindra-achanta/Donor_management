import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/bloc_management/Activity/activity_bloc.dart';
import 'package:vikas_app/bloc_management/Activity/activity_event.dart';
import 'package:vikas_app/bloc_management/Activity/activity_state.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/add_button.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/common/stats_grid.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen({super.key});

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  bool _showMetrics = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityBloc>().add(
            const FetchActivitiesEvent(page: 0, pageSize: 10),
          );
          context.read<ActivityBloc>().add(
          const LoadActivityMetricsEvent(),
        );
    });
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          // TextButton(
          //   onPressed: () {
          //     Navigator.pop(dialogContext);
          //     context.read<ActivityBloc>().add(DeleteActivityEvent(id));
          //   },
          //   child: const Text('Delete', style: TextStyle(color: Colors.red)),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StatsGrid(visibleType: "ACTIVITY"),
            BlocBuilder<ActivityBloc, ActivityState>(
              builder: (context, state) {
                switch (state.status) {
                  case ActivityStatus.loading:
                    return const ScreenLoader();
                  case ActivityStatus.error:
                    return Center(
                      child: ErrorCard(message: state.errorMessage ?? 'Unknown error'),
                    );
                  case ActivityStatus.loaded:
                    return Column(
                      children: [
                        // Header with title, count chip, and add button
                        // Metrics Chart
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _showMetrics
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildMetricsChart(state),
                                )
                              : const SizedBox(),
                        ),
                        // Header with title, count chip, and buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Call Logs List",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text('${state.totalElements}'),
                                    avatar: const Icon(Icons.assignment, size: 18),
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _showMetrics = !_showMetrics;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: Colors.grey.shade400),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _showMetrics
                                                ? Icons.visibility_off
                                                : Icons.insert_chart,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            _showMetrics ? 'Hide metrics' : 'Show metrics',
                                            style: const TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (Vikasdb().getString("USER_TYPE") != "GURUJI")
                                    AddButton().addButton(
                                      context: context,
                                      buttonText: "Add Call Data",
                                      onClicked: () {
                                        Get.toNamed('/activity');
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              CommonList<dynamic>(
                                currentPage: state.currentPage,
                                users: state.activities,
                                screenType: 'ACTIVITY',
                                onUserTap: (id) {
                                  // Optional: handle tap
                                  print('Tapped activity: $id');
                                },
                                onDelete: (id) => _showDeleteConfirmation(context, id),
                                onUpdate: (id) {
                                  Get.toNamed('/activity-edit', arguments: id);
                                },
                              ),
                              // Pagination controls
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: state.currentPage > 0
                                          ? () {
                                              context.read<ActivityBloc>().add(
                                                    FetchActivitiesEvent(
                                                      page: state.currentPage - 1,
                                                      pageSize: 10,
                                                    ),
                                                  );
                                            }
                                          : null,
                                      icon: const Icon(Icons.skip_previous_outlined),
                                    ),
                                    Text(
                                      "${state.currentPage + 1}/${state.totalPages}",
                                    ),
                                    IconButton(
                                      onPressed: state.currentPage < state.totalPages - 1
                                          ? () {
                                              context.read<ActivityBloc>().add(
                                                    FetchActivitiesEvent(
                                                      page: state.currentPage + 1,
                                                      pageSize: 10,
                                                    ),
                                                  );
                                            }
                                          : null,
                                      icon: const Icon(Icons.skip_next_outlined),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  default:
                    return const ScreenLoader();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  List<Map<String, dynamic>> _getLast12MonthsMetrics(
    ActivityState state,
  ) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    final now = DateTime.now();

    final List<String> last12Months = [];

    for (int i = 11; i >= 0; i--) {
      final date = DateTime(
        now.year,
        now.month - i,
      );

      last12Months.add(
        months[date.month - 1],
      );
    }

    return last12Months.map((month) {
      final existing = state.metrics
          .cast<dynamic>()
          .where((e) => e.month == month)
          .toList();

      return {
        "month": month,
        "totalCalls":
            existing.isNotEmpty
                ? existing.first.totalCalls
                : 0,
      };
    }).toList();
  }
Widget _buildMetricsChart(ActivityState state) {
  if (state.isDashboardLoading) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  if (state.isDashboardLoading) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
   final metrics = _getLast12MonthsMetrics(state);

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 12),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 5),
            
            const Text(
              "Last 12 Months Metrics",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),

           Row(
  children: const [
    _Legend(
      color: Color(0xFF4F9CF9),
      text: "Calls",
    ),
    SizedBox(width: 30),
  ],
),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 140,
          child: BarChart(
            BarChartData(
              alignment:
                  BarChartAlignment.spaceAround,

            maxY: _getMaxY(metrics),

              groupsSpace: 18,

              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData:
                    BarTouchTooltipData(
                  tooltipBgColor:
                      Colors.black87,
                  getTooltipItem:
                      (
                        group,
                        groupIndex,
                        rod,
                        rodIndex,
                      ) {
                    final index =
                        group.x.toInt();

                    if (index >=
                        metrics.length) {
                      return null;
                    }

                    final item =
                        metrics[index];

                    return BarTooltipItem(
                     "${_getMonthName(item["month"])}\nCalls: ${item["totalCalls"]}",
                      const TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),

              gridData: const FlGridData(
  show: false,
),

              borderData:
                  FlBorderData(show: false),

              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles:
                      SideTitles(
                    showTitles: false,
                  ),
                ),

                topTitles: const AxisTitles(
                  sideTitles:
                      SideTitles(
                    showTitles: false,
                  ),
                ),

                rightTitles:
                    const AxisTitles(
                  sideTitles:
                      SideTitles(
                    showTitles: false,
                  ),
                ),

                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget:
                        (value, meta) {
                      final index =
                          value.toInt();

                      if (index >=
                          metrics
                              .length) {
                        return const SizedBox();
                      }

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          _getMonthShort(
  metrics[index]["month"],
),
                          style:
                              TextStyle(
                            fontSize: 13,
                            color: Colors
                                .grey.shade600,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              barGroups: List.generate(
                metrics.length,
                (index) {
                  final item = metrics[index];

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (item["totalCalls"] as int).toDouble(),
                        width: 16,

                        borderRadius:
                            BorderRadius.circular(
                          6,
                        ),

                        gradient:
                            const LinearGradient(
                          begin:
                              Alignment
                                  .bottomCenter,
                          end: Alignment
                              .topCenter,
                          colors: [
                            Color(
                              0xFF4F9CF9,
                            ),
                            Color(
                              0xFF00D2FF,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            swapAnimationDuration:
                const Duration(
              milliseconds: 400,
            ),
          ),
        ),
      ],
    ),
  );
}
double _getMaxY(List<Map<String, dynamic>> metrics) {
  double max = 0;

  for (var e in metrics) {
    if (e["totalCalls"] > max) {
      max = e["totalCalls"].toDouble();
    }
  }

  if (max == 0) {
    return 10;
  }

  return max + (max * 0.2);
}
String _getMonthName(String month) {
  const months = {
    "Jan": "January",
    "Feb": "February",
    "Mar": "March",
    "Apr": "April",
    "May": "May",
    "Jun": "June",
    "Jul": "July",
    "Aug": "August",
    "Sep": "September",
    "Oct": "October",
    "Nov": "November",
    "Dec": "December",
  };

  return months[month] ?? month;
}

String _getMonthShort(String month) {
  return month;
}



}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}