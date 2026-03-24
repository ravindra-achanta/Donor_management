import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/bloc_management/visits/visit_bloc.dart';
import 'package:vikas_app/bloc_management/visits/visit_event.dart';
import 'package:vikas_app/bloc_management/visits/visit_state.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/deletion_popup.dart';
import 'package:vikas_app/screeens/common/list_view.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/models/request/VisitMetrics.dart';
import 'package:vikas_app/screeens/models/request/visit_model.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/screeens/models/response/visit_view.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class VisitsListScreen extends StatefulWidget {
  const VisitsListScreen({super.key});

  @override
  State<VisitsListScreen> createState() => _VisitsListScreenState();
}

class _VisitsListScreenState extends State<VisitsListScreen> {
  static const _flexValues = [6, 3, 7];
  static const _animationDuration = Duration(milliseconds: 300);
bool _showMetrics = true; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<VisitBloc>().add(const LoadVisits(page: 0));
      context.read<VisitBloc>().add(LoadVisitMetrics());
    });
  }

  void _showDeleteDialog(String id, String visitorName) {
    DeletionPopup.showDeleteConfirmation(
      context: context,
      title: 'Delete Visit',
      message: 'Are you sure you want to delete the visit for "$visitorName"?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      onConfirm: () {
        context.read<VisitBloc>().add(DeleteVisit(id));
        Get.showSnackbar(
          const GetSnackBar(
            message: 'Deleting visit...',
            duration: Duration(seconds: 1),
          ),
        );
      },
    );
  }

  void _onVisitTap(String id) =>
      context.read<VisitBloc>().add(LoadVisitDetails(id));

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<VisitBloc, VisitState>(
          builder: (context, state) {
            if (state.status == VisitApiStatus.loading) {
              return const Center(child: ScreenLoader());
            }
            if (state.status == VisitApiStatus.error) {
              return Center(
                child: ErrorCard(
                  message: state.errorMessage ?? 'Unknown error',
                ),
              );
            }
            if (state.status == VisitApiStatus.loaded) {
              return _buildContent(state);
            }
            return const Center(child: ScreenLoader());
          },
        ),
      ),
    );
  }

Widget _buildContent(VisitState state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (_showMetrics) ...[
        _buildMetricsChart(state),
        const SizedBox(height: 10),
      ],
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: state.isProfileViewVisible ? _flexValues[0] : _flexValues[2],
              child: _buildListSection(state),
            ),
            if (state.isProfileViewVisible)
              Expanded(
                flex: _flexValues[1],
                child: _buildProfileSection(state),
              ),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildListSection(VisitState state) {
    return Column(
      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
       const SizedBox(height: 10),
     // _buildMetricsChart(state),
      const SizedBox(height: 10),
      _buildHeader(context, state),

      const SizedBox(height: 8),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      child: CommonList<VisitView>(
                        currentPage: state.currentPage,
                        users: state.visitList,
                        screenType: "VISIT",
                        onUserTap: _onVisitTap,
                        onDelete: (id) {
                          final item = state.visitList.firstWhere(
                            (d) => d.id == id,
                          );
                          _showDeleteDialog(id, item.visitorName);
                        },
                        onUpdate: (id) {
                          final item = state.visitList.firstWhere(
                            (d) => d.id == id,
                          );
                          Get.toNamed(
                            '/add/visit',
                            arguments: VisitModel(
                              id: item.id,
                              visitorName: item.visitorName,
                              phoneNumber: item.phoneNumber,
                              email: item.email,
                              visitPurpose: item.visitPurpose,
                              comments: item.comments,
                              noOfGuests: item.noOfGuests,
                              // existVisitor: item.existVisitor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                _buildPaginationBar(state),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(context, state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const Text(
          //   "Visits",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),
          Row(
            children: [
              const Text(
                "Visits :",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text('${state!.totalElements}'),
                avatar: const Icon(Icons.people, size: 18),
                backgroundColor: Colors.grey.shade200,
              ),
            ],
          ),
          
          Row(
            children: [
              // IconButton(
              //   icon: const Icon(Icons.refresh),
              //   onPressed: () {
              //     context.read<VisitBloc>().add(const LoadVisits(page: 0));
              //   },
              // ),
              InkWell(
  onTap: () { setState(() { _showMetrics = !_showMetrics; }); },
  borderRadius: BorderRadius.circular(30),
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.grey.shade400),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_showMetrics ? Icons.visibility_off : Icons.insert_chart, size: 18),
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
              if (Vikasdb().getString("USER_TYPE") == "OFFICE_STAFF")
                // ElevatedButton.icon(
                //   onPressed: () => Get.toNamed('/add/visit'),
                //   icon: const Icon(Icons.add),
                //   label: const Text("Add Visit"),
                // ),
                if (Vikasdb().getString("USER_TYPE") == "OFFICE_STAFF")
                  InkWell(
                    onTap: () => Get.toNamed('/add/visit'),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),

                        /// 🔥 Gradient style
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            "Add Visit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationBar(VisitState state) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: state.currentPage > 0
                  ? () => context.read<VisitBloc>().add(
                      LoadVisits(page: state.currentPage - 1),
                    )
                  : null,
              icon: const Icon(Icons.skip_previous_outlined),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${state.currentPage + 1}/${state.totalPages}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              onPressed: state.currentPage < state.totalPages - 1
                  ? () => context.read<VisitBloc>().add(
                      LoadVisits(page: state.currentPage + 1),
                    )
                  : null,
              icon: const Icon(Icons.skip_next_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(VisitState state) {
    return AnimatedSwitcher(
      duration: _animationDuration,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: state.profileLoading == true
          ? const ScreenLoader(key: ValueKey('loader'))
          : state.profileErrorMsg != null
          ? Center(child: ErrorCard(message: state.profileErrorMsg!))
          : state.selectedVisit != null
          ? _buildProfileView(state.selectedVisit!)
          : const SizedBox.shrink(),
    );
  }

  Widget _buildProfileView(VisitModel visit) {
    final visitView = VisitView(
      id: visit.id,
      visitorName: visit.visitorName,
      phoneNumber: visit.phoneNumber,
      email: visit.email,
      visitPurpose: visit.visitPurpose,
      comments: visit.comments,
      noOfGuests: visit.noOfGuests,
      // existVisitor: visit.existVisitor,
    );

    return ListViewScreen(
      key: ValueKey('profile_${visit.id}'),
      data: visitView,
      // visitData: visitView,
      onClose: () =>
          context.read<VisitBloc>().add(const CloseVisitProfileView()),
      screenType: "VISITS",
      onDelete: () => _showDeleteDialog(visit.id, visit.visitorName),
      onViewMore: () => Get.toNamed('/view/visit', arguments: visitView),
    );
  }
  
 Widget _buildMetricsChart(VisitState state) {
  if (state.metricsLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (state.metrics.isEmpty) {
    return const SizedBox();
  }

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: state.showMonthlyChart
          ? _buildMonthlyChart(state)
          : _buildSummaryChart(state),
    ),
  );
}
double _getMaxY(List<VisitMetrics> data) {
  double max = 0;
  for (var e in data) {
    if (e.totalVisits > max) max = e.totalVisits.toDouble();
    if (e.totalVisitors > max) max = e.totalVisitors.toDouble();
  }
  return max + 10;
}

  Widget _buildSummaryChart(VisitState state) {
  double totalVisits = 0;
  double totalVisitors = 0;

  for (var e in state.metrics) {
    totalVisits += e.totalVisits;
    totalVisitors += e.totalVisitors;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Overview",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 20),

      SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            barTouchData: BarTouchData(
              enabled: true,

              /// 👇 CLICK TO OPEN MONTHLY
              touchCallback: (event, response) {
                if (event.isInterestedForInteractions &&
                    response?.spot != null) {
                  context.read<VisitBloc>().add(
                        const ToggleChartView(true),
                      );
                }
              },
            ),

            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(value == 0 ? "Visits" : "Visitors");
                  },
                ),
              ),
              leftTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: true)),
            ),

            barGroups: [
              /// Visits
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: totalVisits,
                    color: Colors.blue,
                    width: 30,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),

              /// Visitors
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: totalVisitors,
                    color: Colors.green,
                    width: 30,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 10),

      /// 👇 Hint
      const Center(
        child: Text(
          "Tap to view monthly data",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    ],
  );
}

  Widget _buildMonthlyChart(VisitState state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Last 12 Months",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          /// 👇 BACK BUTTON
          TextButton(
            onPressed: () {
              context.read<VisitBloc>().add(
                    const ToggleChartView(false),
                  );
            },
            child: const Text("Back"),
          ),
        ],
      ),

      const SizedBox(height: 10),

      /// Legend
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _Legend(color: Colors.blue, text: "Visits"),
          SizedBox(width: 16),
          _Legend(color: Colors.green, text: "Visitors"),
        ],
      ),

      const SizedBox(height: 12),

      SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            barTouchData: BarTouchData(enabled: true),

            maxY: _getMaxY(state.metrics),

            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int i = value.toInt();
                    if (i >= state.metrics.length)
                      return const SizedBox();

                    return Text(
                      _getMonthShort(state.metrics[i].month),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              leftTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: true)),
            ),

            barGroups: List.generate(state.metrics.length, (i) {
              final item = state.metrics[i];

              return BarChartGroupData(
                x: i,
                barsSpace: 4,
                barRods: [
                  BarChartRodData(
                    toY: item.totalVisits.toDouble(),
                    width: 6,
                    color: Colors.blue,
                  ),
                  BarChartRodData(
                    toY: item.totalVisitors.toDouble(),
                    width: 6,
                    color: Colors.green,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    ],
  );
}

 String _getMonthShort(String month) {
  final parts = month.split("-");
  int m = int.parse(parts[1]);

  const months = [
    "", // index 0 not used
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  return months[m];
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