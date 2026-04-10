import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:vikas_app/bloc_management/Activity/activity_bloc.dart';
import 'package:vikas_app/bloc_management/Activity/activity_event.dart';
import 'package:vikas_app/bloc_management/Activity/activity_state.dart';
import 'package:vikas_app/screeens/models/response/activity_dashboard_metrics.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ActivityDashboardScreen extends StatefulWidget {
  final String id;  
  const ActivityDashboardScreen({required this.id});

  @override
  State<ActivityDashboardScreen> createState() =>
      _ActivityDashboardScreenState();
}

class _ActivityDashboardScreenState
    extends State<ActivityDashboardScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ActivityBloc>().add(
          FetchUserActivityDashboardEvent(id: widget.id),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {

          if (state.isDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null &&
              state.errorMessage!.isNotEmpty) {
            return _errorWidget(state.errorMessage!);
          }

          if (state.dashboardMetrics.isEmpty) {
            return _emptyWidget();
          }

          final data = state.dashboardMetrics;

          return Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      /// 🔙 HEADER ROW
      Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            "Website Activity Dashboard",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      const SizedBox(height: 20),

      /// 📊 SUMMARY
      _buildSummary(data),

      const SizedBox(height: 20),

      /// 📈 GRAPH 1 - TOTAL
      _chartCard(
        title: "Total Activity",
        child: _buildTotalChart(data),
      ),

      const SizedBox(height: 20),

      /// 📈 GRAPH 2 - UPDATION
      _chartCard(
        title: "Updation Activity",
        child: _buildUpdationChart(data),
      ),
    ],
  ),
);
        },
      ),
    );
  }

  // =======================
  // 📊 SUMMARY
  // =======================
  Widget _buildSummary(List<ActivityDashboardMetrics> data) {
    int total = 0;

    for (var m in data) {
      total += m.dashboardCount +
          m.dharmasetuCount +
          m.visitsCount;
    }

    return Row(
      children: [
        Expanded(child: _card("Total Activity", total, Colors.blue)),
        const SizedBox(width: 10),
        Expanded(child: _card("Days", data.length, Colors.green)),
      ],
    );
  }

  Widget _card(String title, int value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 6),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartCard({required String title, required Widget child}) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  // =======================
  // 📈 TOTAL CHART
  // =======================
  Widget _buildTotalChart(List<ActivityDashboardMetrics> data) {
    return _baseChart(
      data: data,
      spots: List.generate(data.length, (i) {
        final m = data[i];
        final total =
            m.dashboardCount + m.dharmasetuCount + m.visitsCount;
        return FlSpot(i.toDouble(), total.toDouble());
      }),
      color: Colors.blue,
      tooltipBuilder: (m) {
        final total =
            m.dashboardCount + m.dharmasetuCount + m.visitsCount;
        return "Dashboard: ${m.dashboardCount}\n"
            "Dharmasetu: ${m.dharmasetuCount}\n"
            "Visits: ${m.visitsCount}\n"
            "Total: $total";
      },
    );
  }

  // =======================
  // 📈 UPDATION CHART
  // =======================
  Widget _buildUpdationChart(List<ActivityDashboardMetrics> data) {
    return _baseChart(
      data: data,
      spots: List.generate(data.length, (i) {
        return FlSpot(
            i.toDouble(), data[i].updationCount.toDouble());
      }),
      color: Colors.red,
      tooltipBuilder: (m) {
        return "Updation: ${m.updationCount}";
      },
    );
  }

  // =======================
  // 🔁 COMMON CHART
  // =======================
 Widget _baseChart({
  required List<ActivityDashboardMetrics> data,
  required List<FlSpot> spots,
  required Color color,
  required String Function(ActivityDashboardMetrics) tooltipBuilder,
}) {
  if (spots.isEmpty) return const SizedBox();

  final double minX = -0.5;
  final double maxX = (spots.length - 1) + 0.5;

  // 👇 Add both left and right padding
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: 0,
        clipData: FlClipData.none(),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: data.length > 10 ? 10 : 1,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                int i = value.round();
                if (i < 0 || i >= data.length) return const SizedBox();
                if (data.length > 10 && i % 10 != 0) return const SizedBox();
                final d = DateTime.parse(data[i].date);
                return Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Text(
                    DateFormat('dd MMM').format(d),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            preventCurveOverShooting: true,
            color: color,
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchSpotThreshold: 8,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.black87,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItems: (spots) {
              return spots.map((s) {
                final m = data[s.x.toInt()];
                return LineTooltipItem(
                  "${DateFormat('yyyy-MM-dd').format(DateTime.parse(m.date))}\n\n${tooltipBuilder(m)}",
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
      ),
    ),
  );
}
  

  // =======================
  // ERROR / EMPTY
  // =======================
  Widget _errorWidget(String msg) {
    return Center(child: Text(msg));
  }

  Widget _emptyWidget() {
    return const Center(child: Text("No Data Available"));
  }
}