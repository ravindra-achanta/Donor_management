import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/visits/visit_bloc.dart';
import 'package:vikas_app/bloc_management/visits/visit_event.dart';
import 'package:vikas_app/bloc_management/visits/visit_state.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/list_view.dart';
import 'package:vikas_app/screeens/common/loader.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<VisitBloc>().add(const LoadVisits(page: 0));
    });
  }

  void _showDeleteDialog(String id, String visitorName) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Visit'),
        content: Text(
          'Are you sure you want to delete the visit for "$visitorName"?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              context.read<VisitBloc>().add(DeleteVisit(id));
              Get.showSnackbar(
                const GetSnackBar(
                  message: 'Deleting visit...',
                  duration: Duration(seconds: 1),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: state.isProfileViewVisible ? _flexValues[0] : _flexValues[2],
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: _buildListSection(state),
          ),
        ),
        if (state.isProfileViewVisible)
          Expanded(
            flex: _flexValues[1],
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: _buildProfileSection(state),
            ),
          ),
      ],
    );
  }

  Widget _buildListSection(VisitState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
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
                              existVisitor: item.existVisitor,
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Visits",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<VisitBloc>().add(const LoadVisits(page: 0));
                },
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => Get.toNamed('/add/visit'),
                icon: const Icon(Icons.add),
                label: const Text("Add Visit"),
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
      existVisitor: visit.existVisitor,
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
}
