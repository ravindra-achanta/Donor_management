import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_bloc.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_state.dart';
import 'package:vikas_app/screeens/common/stat_card.dart';

class StatsGrid extends StatelessWidget {
  final String? visibleType;

  StatsGrid({Key? key, this.visibleType}) : super(key: key);

  /// Check role permission
  bool isCardVisible(List<String> allowedRoles) {
    final userType = Vikasdb().getString("USER_TYPE") ?? "";
    return allowedRoles.contains(userType);
  }

  /// Check visible type
  bool isVisibleType(String type) {
    return visibleType == null || visibleType == type;
  }

  @override
  Widget build(BuildContext context) {
    final userType = Vikasdb().getString("USER_TYPE") ?? "";

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardApiStatus.loading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == DashboardApiStatus.error) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('Error loading stats: ${state.errorMessage}'),
            ),
          );
        }

        final metrics = state.metrics;
        if (metrics == null) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {

            double aspectRatio;
            if (constraints.maxWidth > 1200) {
              aspectRatio = 2.1;
            } else if (constraints.maxWidth > 800) {
              aspectRatio = 1.8;
            } else {
              aspectRatio = 1.3;
            }

            return GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: aspectRatio,
              ),
              children: [

                /// Total Jeevanadis
                if (isCardVisible(["GURUJI", "SUPER_ADMIN"]) &&
                    isVisibleType("JEEVANAADI"))
                  StatCard(
                    title: "Total Jeevanadis",
                    value: "${metrics.totalJeevanadis}",
                    icon: Icons.groups_rounded,
                    color: Colors.indigo,
                    screenWidth: constraints.maxWidth,
                  ),

                /// Total Vikas Users
                // if (isCardVisible(["GURUJI", "SUPER_ADMIN"]) &&
                //     isVisibleType("USERS"))
                //    StatCard(
                //     title: "Total Vikas Users",
                //     value: "${metrics.activeKaryakarthas+metrics.activeStaff+metrics.activeAdmins}",
                //     icon: Icons.people_alt_rounded,
                //     color: Colors.indigo,
                //     screenWidth: constraints.maxWidth,
                //   ),

                /// Total Admins
                if (isCardVisible(["GURUJI", "SUPER_ADMIN"]) &&
                    isVisibleType("USERS"))
                  StatCard(
                    title: "Total Admins",
                    value: "${metrics.activeAdmins}",
                    icon: Icons.admin_panel_settings,
                    color: Colors.blueGrey,
                    screenWidth: constraints.maxWidth,
                  ),

                /// Total Staff
                if (isCardVisible(["GURUJI", "SUPER_ADMIN", "ADMIN"]) &&
                    isVisibleType("USERS"))
                  StatCard(
                    title: "Total Staff",
                    value: "${metrics.activeStaff}",
                    icon: Icons.badge,
                    color: Colors.deepPurple,
                    screenWidth: constraints.maxWidth,
                  ),

                /// Total Requests
                if (isCardVisible(["OFFICE_STAFF", "GURUJI", "SUPER_ADMIN"]) &&
                    isVisibleType("REQUESTS"))
                  StatCard(
                    title: "Total Requests",
                    value: "${metrics.pendingRequests + metrics.inProgressRequests + metrics.completedRequests}",
                    icon: Icons.assignment,
                    color: Colors.teal,
                    screenWidth: constraints.maxWidth,
                  ),

                /// Pending Requests
                if (isCardVisible(["OFFICE_STAFF"]) &&
                    isVisibleType("REQUESTS"))
                  StatCard(
                    title: "Pending Requests",
                    value: "${metrics.pendingRequests}",
                    icon: Icons.pending_actions,
                    color: Colors.orange,
                    screenWidth: constraints.maxWidth,
                  ),

                   if (isCardVisible(["OFFICE_STAFF"]) &&
                    isVisibleType("REQUESTS"))
                  StatCard(
                    title: "InProgress Requests",
                    value: "${metrics.inProgressRequests}",
                    icon: Icons.hourglass_top,
                    color: Colors.orange,
                    screenWidth: constraints.maxWidth,
                  ),

                /// Completed Requests
                if (isCardVisible(["OFFICE_STAFF"]) &&
                    isVisibleType("REQUESTS"))
                  StatCard(
                    title: "Completed Requests",
                    value: "${metrics.completedRequests}",
                    icon: Icons.task_alt,
                    color: Colors.green,
                    screenWidth: constraints.maxWidth,
                  ),

                /// Active Jeevanadis
                if (!["KARYAKARTHA", "OFFICE_STAFF"].contains(userType) &&
                    isVisibleType("JEEVANAADI"))
                  StatCard(
                    title: "Active Jeevanadis",
                    value: "${metrics.activeJeevanadis}",
                    icon: Icons.check_circle_rounded,
                    color: Colors.teal,
                    screenWidth: constraints.maxWidth,
                  ),

                /// Inactive Jeevanadis
                if (isCardVisible(["GURUJI", "SUPER_ADMIN"]) &&
                    isVisibleType("JEEVANAADI"))
                  StatCard(
                    title: "Inactive Jeevanadis",
                    value: "${metrics.inActiveJeevanadis}",
                    icon: Icons.cancel_rounded,
                    color: Colors.orange,
                    screenWidth: constraints.maxWidth,
                  ),

                /// Assigned Jeevanadis
                if (isCardVisible(["GURUJI", "SUPER_ADMIN", "ADMIN"]) &&
                    isVisibleType("JEEVANAADI"))
                  StatCard(
                    title: "Assigned Jeevanadis",
                    value: "${metrics.assignedJeevanadis}",
                    icon: Icons.assignment_ind,
                    color: Colors.blue,
                    screenWidth: constraints.maxWidth,
                  ),

                /// Unassigned Jeevanadis
                if (isCardVisible(["GURUJI", "SUPER_ADMIN", "ADMIN"]) &&
                    isVisibleType("JEEVANAADI"))
                  StatCard(
                    title: "Unassigned Jeevanadis",
                    value: "${metrics.unAssignedJeevanadis}",
                    icon: Icons.assignment_late,
                    color: Colors.redAccent,
                    screenWidth: constraints.maxWidth,
                  ),

                /// Active Karyakarthas
                if (!["KARYAKARTHA", "OFFICE_STAFF"].contains(userType) &&
                    isVisibleType("USERS") ||  isVisibleType("KARYAKARTHA"))
                  StatCard(
                    title: "Active Karyakarthas",
                    value: "${metrics.activeKaryakarthas}",
                    icon: Icons.people_alt,
                    color: Colors.purple,
                    screenWidth: constraints.maxWidth,
                  ),

                /// Profile Update %
                if (isCardVisible(["KARYAKARTHA"]) &&
                    isVisibleType("KARYAKARTHA")|| isVisibleType("JEEVANAADI"))
                  StatCard(
                    title: "Profile Update %",
                    value:
                        "${metrics.updationPercentgaeByKaryakartha?.toStringAsFixed(2)}%",
                    icon: Icons.trending_up,
                    color: Colors.amber,
                    screenWidth: constraints.maxWidth,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}