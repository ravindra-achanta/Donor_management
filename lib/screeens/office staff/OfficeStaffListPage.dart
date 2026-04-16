import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/bloc_management/Officestaff/office_staff_bloc.dart';
import 'package:vikas_app/bloc_management/Officestaff/office_staff_event.dart';
import 'package:vikas_app/bloc_management/Officestaff/office_staff_state.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_bloc.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_event.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_bloc.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_event.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_state.dart';
import 'package:vikas_app/screeens/authentication/registration_page.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/add_button.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/common_search_bar.dart';
import 'package:vikas_app/screeens/common/deletion_popup.dart';
import 'package:vikas_app/screeens/common/list_view.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/common/stats_grid.dart';
import 'package:vikas_app/screeens/models/enum/RegistrationType.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class OfficeStaffListPage extends StatefulWidget {
  const OfficeStaffListPage({super.key});

  @override
  State<OfficeStaffListPage> createState() =>
      _OfficeStaffListPageState();
}

class _OfficeStaffListPageState extends State<OfficeStaffListPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// 🔥 Fetch Office Staff
    context.read<OfficeStaffBloc>().add(FetchOfficeStaffEvent(0));

    context.read<DashboardBloc>().add(FetchDashboardMetricsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// 🔥 Change type
            StatsGrid(visibleType: "OFFICE_STAFF"),

            BlocBuilder<OfficeStaffBloc, OfficeStaffState?>(
              builder: (context, state) {
                switch (state?.status) {
                  case OfficeStaffApiStatus.loading:
                    return ScreenLoader();

                  case OfficeStaffApiStatus.error:
                    return Center(
                      child:
                          ErrorCard(message: state?.errorMessage ?? ""),
                    );

                  case OfficeStaffApiStatus.loaded:
                    return Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              const SizedBox(height: 16),

                              /// 🔹 HEADER
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "All Office Staff :",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Chip(
                                          label: Text(
                                            '${state!.totalElements}',
                                          ),
                                          avatar: const Icon(
                                            Icons.people,
                                            size: 18,
                                          ),
                                          backgroundColor:
                                              Colors.grey.shade200,
                                        ),
                                      ],
                                    ),

                                    /// 🔍 SEARCH
                                    CommonSearchBar(
                                      controller: _searchController,
                                      hintText:
                                          "Search office staff...",
                                      onSearch: (value) {
                                        context
                                            .read<OfficeStaffBloc>()
                                            .add(
                                              FetchOfficeStaffEvent(
                                                0,
                                                value.isNotEmpty
                                                    ? value
                                                    : null,
                                              ),
                                            );
                                      },
                                    ),

                                    /// ➕ ADD BUTTON
                                    if (Vikasdb().getString("USER_TYPE") !=
                                            "GURUJI" &&
                                        Vikasdb().getString("USER_TYPE") !=
                                            "SUPER_ADMIN" && Vikasdb().getString("USER_TYPE") != "ADMIN")
                                      AddButton().addButton(
                                        context: context,
                                        buttonText:
                                            "Add Office Staff",
                                        onClicked: () {
                                          Get.to(
                                            () => RegistrationPage(
                                              title:
                                                  "Add Office Staff",
                                              type: RegistrationType
                                                  .officeStaff,
                                              user: null,
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),

                              /// 🔹 LIST CARD
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    CommonList(
                                      users:
                                          state?.officeStaff ?? [],
                                      currentPage:
                                          state?.currentPage ?? 0,
                                      screenType: 'OFFICE_STAFF',

                                      /// 👇 VIEW PROFILE
                                     onUserTap: (id) {
  context.read<OfficeStaffBloc>().add(
    FetchOfficeStaffProfileEvent(id),
  );
},

                                      /// ❌ DELETE
                                      onDelete: (id) {
                                        DeletionPopup
                                            .showDeleteConfirmation(
                                          context: context,
                                          title: "Delete User ?",
                                          message:
                                              "Are you sure you want to delete this user?\nThis action cannot be undone.",
                                          onConfirm: () {
                                            context
                                                .read<
                                                    OfficeStaffBloc>()
                                                .add(
                                                  DeleteOfficeStaffEvent(
                                                      id),
                                                );
                                            Navigator.pop(context);
                                          },
                                        );
                                      },

                                      /// ✏️ UPDATE
                                      onUpdate: (id) {
                                        try {
                                          final user = state
                                              ?.officeStaff
                                              ?.firstWhere(
                                                  (u) => u.id == id);

                                          if (user != null) {
                                            Get.to(
                                              () =>
                                                  RegistrationPage(
                                                title:
                                                    "Edit Office Staff",
                                                type:
                                                    RegistrationType
                                                        .officeStaff,
                                                user: user,
                                                isEdit: true,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          debugPrint(
                                              'User not found: $id');
                                        }
                                      },
                                    ),

                                    /// 🔹 PAGINATION
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 50),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (state!
                                                      .currentPage >
                                                  0) {
                                                context
                                                    .read<
                                                        OfficeStaffBloc>()
                                                    .add(
                                                      FetchOfficeStaffEvent(
                                                        state.currentPage -
                                                            1,
                                                        _searchController
                                                                .text
                                                                .isNotEmpty
                                                            ? _searchController
                                                                .text
                                                            : null,
                                                      ),
                                                    );
                                              }
                                            },
                                            icon: const Icon(Icons
                                                .skip_previous_outlined),
                                          ),

                                          Text(
                                            "${(state?.currentPage ?? 0) + 1}/${(state?.totalPages ?? 0)}",
                                          ),

                                          IconButton(
                                            onPressed: () {
                                              if (state!
                                                      .currentPage <
                                                  state!.totalPages -
                                                      1) {
                                                context
                                                    .read<
                                                        OfficeStaffBloc>()
                                                    .add(
                                                      FetchOfficeStaffEvent(
                                                        state.currentPage +
                                                            1,
                                                        _searchController
                                                                .text
                                                                .isNotEmpty
                                                            ? _searchController
                                                                .text
                                                            : null,
                                                      ),
                                                    );
                                              }
                                            },
                                            icon: const Icon(Icons
                                                .skip_next_outlined),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// 🔹 RIGHT PROFILE PANEL
                        if (state?.isProfileViewVisible == true)
                          Expanded(
                            flex: 3,
                            child:
                             ListViewScreen(
                              data: state?.officeStaffProfile,
                              screenType: "OFFICE_STAFF",

                              onClose: () {
                                context
                                    .read<OfficeStaffBloc>()
                                    .add(CloseOfficeStaffProfile());
                              },

                              onDelete: () {
                                DeletionPopup.showDeleteConfirmation(
                                  context: context,
                                  onConfirm: () {
                                    final id = state
                                        ?.officeStaffProfile?.id;

                                    if (id != null) {
                                      context
                                          .read<OfficeStaffBloc>()
                                          .add(
                                            DeleteOfficeStaffEvent(
                                                id),
                                          );
                                      Navigator.pop(context);
                                      context
                                          .read<OfficeStaffBloc>()
                                          .add(
                                              CloseOfficeStaffProfile());
                                    }
                                  },
                                  title: "Delete User ?",
                                  message:
                                      "Are you sure you want to delete this user?",
                                );
                              },

                              onViewMore: () {
                                final id =
                                    state?.officeStaffProfile?.id;

                                if (id != null) {
                                  Get.toNamed(
                                    '/office-staff-view',
                                    arguments: id,
                                  );
                                }
                              },
                            ),
                          ),
                      ],
                    );

                  default:
                    return ScreenLoader();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}