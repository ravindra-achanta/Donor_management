import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';

import 'package:vikas_app/bloc_management/dashboard/dashboard_bloc.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_event.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_state.dart';

import 'package:vikas_app/bloc_management/notices/notice_bloc.dart';
import 'package:vikas_app/bloc_management/notices/notice_event.dart';
import 'package:vikas_app/bloc_management/notices/notice_state.dart';
import 'package:vikas_app/screeens/common/stats_grid.dart';

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

  /// NOTICE QUEUE
  final List<NoticeResponse> _pendingNotices = [];
  int _currentNoticeIndex = 0;
  bool _isShowing = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      
      context.read<DashboardBloc>().add(FetchDashboardMetricsEvent());

      /// FETCH NOTICES
      context.read<NoticeBloc>().add(FetchNoticesEvent());

    });
  }

  /// START NOTICE QUEUE
  void _startNoticeQueue(List<NoticeResponse> notices) {

    if (notices.isEmpty || _isShowing) return;

    _pendingNotices.clear();
    _pendingNotices.addAll(notices);

    _currentNoticeIndex = 0;
    _isShowing = true;

    _showNextNotice();
  }

  /// SHOW NEXT NOTICE
  void _showNextNotice() {

    if (_currentNoticeIndex >= _pendingNotices.length) {
      _isShowing = false;
      return;
    }

    final notice = _pendingNotices[_currentNoticeIndex];

    NoticePopup.show(
      context: context,
      imageUrl: notice.image ?? '',
      title: notice.title,
      description: notice.description,
      cancelText: "Close",
      onClosed: () {

        context.read<NoticeBloc>().add(
          MarkNoticeReadEvent(notice.id),
        );

        setState(() {
          _currentNoticeIndex++;
        });

        Future.delayed(
          const Duration(milliseconds: 300),
          _showNextNotice,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Layout(

      child: MultiBlocListener(

        listeners: [

          /// NOTICE LISTENER
          BlocListener<NoticeBloc, NoticeState>(
            listener: (context, state) {

              if (state.status == NoticeStatus.success &&
                  state.notices.isNotEmpty) {

                _startNoticeQueue(state.notices);
              }

              if (state.status == NoticeStatus.failure) {
                debugPrint("Notice Error: ${state.errorMessage}");
              }
            },
          ),

        ],

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: SingleChildScrollView(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Dashboard",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    _buildRangeSelector(),

                  ],
                ),

                const SizedBox(height: 24),

                /// STATS
                _buildStatsGrid(),

                const SizedBox(height: 24),

              ],
            ),
          ),
        ),
      ),
    );
  }

  /// RANGE SELECTOR
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

              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),

              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                item,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : Colors.grey.shade700,
                ),
              ),
            ),
          );

        }).toList(),
      ),
    );
  }

 Widget _buildStatsGrid() {
  return  StatsGrid();
}


}
