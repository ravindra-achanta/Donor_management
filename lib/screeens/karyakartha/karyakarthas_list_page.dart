import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
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

class KaryakarthasListPage extends StatefulWidget {
  const KaryakarthasListPage({super.key});

  @override
  State<KaryakarthasListPage> createState() => _KaryakarthasListPageState();
}

class _KaryakarthasListPageState extends State<KaryakarthasListPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<KaryakarthaBloc>().add(FetchKaryakattasEvent(0));

    context.read<DashboardBloc>().add(FetchDashboardMetricsEvent());
  }

  void _callSearchApi() {
    final query = _searchController.text.trim();

    context.read<KaryakarthaBloc>().add(
      FetchKaryakattasEvent(0, query.isNotEmpty ? query : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StatsGrid(visibleType: "KARYAKARTHA"),
            BlocBuilder<KaryakarthaBloc, KaryakarthaState?>(
              builder: (context, state) {
                switch (state?.status) {
                  case KaryakattaApiStatus.loading:
                    return ScreenLoader();
                  case KaryakattaApiStatus.error:
                    return Center(
                      child: ErrorCard(message: state?.errorMessage ?? ""),
                    );
                  case KaryakattaApiStatus.loaded:
                    return Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              // if (Vikasdb().getString("USER_TYPE") ==
                              //         "OFFICE_STAFF" ||
                              //     Vikasdb().getString("USER_TYPE") == "KARYAKARTHA")
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // const Text(
                                    //   "All Karyakarthas",
                                    //   style: TextStyle(
                                    //     fontSize: 18,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    Row(
                                      children: [
                                        const Text(
                                          "All Karyakarthas :",
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
                                          backgroundColor: Colors.grey.shade200,
                                        ),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   width: 250,
                                    //   child: TextFormField(
                                    //     controller: _searchController,

                                    //     onFieldSubmitted: (_) =>
                                    //         _callSearchApi(),

                                    //     onChanged: (_) {
                                    //       setState(() {});
                                    //     },

                                    //     decoration: InputDecoration(
                                    //       hintText: 'Search...',

                                    //       prefixIcon: IconButton(
                                    //         icon: Icon(Icons.search),
                                    //         onPressed: _callSearchApi,
                                    //       ),

                                    //       suffixIcon:
                                    //           _searchController.text.isNotEmpty
                                    //           ? IconButton(
                                    //               icon: Icon(
                                    //                 Icons.close,
                                    //                 size: 18,
                                    //               ),
                                    //               onPressed: () {
                                    //                 _searchController.clear();

                                    //                 context
                                    //                     .read<KaryakarthaBloc>()
                                    //                     .add(
                                    //                       FetchKaryakattasEvent(
                                    //                         0,
                                    //                         null,
                                    //                       ),
                                    //                     );

                                    //                 setState(() {});
                                    //               },
                                    //             )
                                    //           : null,

                                    //       filled: true,
                                    //       fillColor: Colors.white,

                                    //       border: OutlineInputBorder(
                                    //         borderRadius: BorderRadius.circular(
                                    //           40,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    CommonSearchBar(
                                      controller: _searchController,
                                      hintText: "Search karyakarthas...",
                                      onSearch: (value) {
                                        context.read<KaryakarthaBloc>().add(
                                          FetchKaryakattasEvent(
                                            0,
                                            value.isNotEmpty ? value : null,
                                          ),
                                        );
                                      },
                                    ),
                                    if (Vikasdb().getString("USER_TYPE") !=
                                        "GURUJI" && Vikasdb().getString("USER_TYPE") != "SUPER_ADMIN")
                                      AddButton().addButton(
                                        context: context,
                                        buttonText: "Add Karyakartha",
                                        onClicked: () {
                                          //Get.toNamed('/register');
                                          Get.to(
                                            () => RegistrationPage(
                                              title: "Add Karyakartha",
                                              type:
                                                  RegistrationType.karyakartha,
                                              user: null,
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    CommonList(
                                      users: state?.karyakarthas ?? [],
                                      currentPage: state?.currentPage ?? 0,
                                      screenType: 'KARYAKARTHA',
                                      onUserTap: (id) {
                                        if (state?.profileLoading == true)
                                          return;
                                        context.read<KaryakarthaBloc>().add(
                                          FetchKaryakarthaProfileEvent(id),
                                        );
                                      },
                                      onDelete: (id) {
                                        DeletionPopup.showDeleteConfirmation(
                                          context: context,
                                          title: "Delete User ?",
                                          message:
                                              "Are you sure you want to delete this user?\nThis action cannot be undone.",
                                          onConfirm: () {
                                            context.read<KaryakarthaBloc>().add(
                                              DeleteKaryakarthaEvent(id),
                                            );
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                      onUpdate: (id) {
                                        try {
                                          final user = state?.karyakarthas
                                              ?.firstWhere((u) => u.id == id);
                                          if (user != null) {
                                            Get.to(
                                              () => RegistrationPage(
                                                title: "Edit User",
                                                type: RegistrationType
                                                    .karyakartha,
                                                user: user,
                                                isEdit: true,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          debugPrint(
                                            'User not found with id: $id',
                                          );
                                        }
                                      },
                                    ),
                                    // const SizedBox(height: 16),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 50,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (state!.currentPage > 0) {
                                                context
                                                    .read<KaryakarthaBloc>()
                                                    .add(
                                                      FetchKaryakattasEvent(
                                                        state.currentPage - 1,
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
                                            icon: Icon(
                                              Icons.skip_previous_outlined,
                                            ),
                                          ),
                                          Text(
                                            "${(state?.currentPage ?? 0) + 1}/${(state?.totalpages ?? 0)}",
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (state!.currentPage <
                                                  state!.totalpages - 1) {
                                                context
                                                    .read<KaryakarthaBloc>()
                                                    .add(
                                                      FetchKaryakattasEvent(
                                                        state.currentPage + 1,
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
                                            icon: Icon(
                                              Icons.skip_next_outlined,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (state?.isProfileViewVisible == true &&
                            state?.profileLoading != null)
                          Expanded(
                            flex: 3, // 30%
                            child: AnimatedSwitcher(
                              duration: const Duration(seconds: 1),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,

                              layoutBuilder: (currentChild, previousChildren) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    ...previousChildren,
                                    if (currentChild != null) currentChild,
                                  ],
                                );
                              },

                              transitionBuilder: (child, animation) {
                                final slideAnimation = Tween<Offset>(
                                  begin: const Offset(
                                    0.05,
                                    0,
                                  ), // slight slide from right
                                  end: Offset.zero,
                                ).animate(animation);

                                final fadeAnimation = Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(animation);

                                return FadeTransition(
                                  opacity: fadeAnimation,
                                  child: SlideTransition(
                                    position: slideAnimation,
                                    child: child,
                                  ),
                                );
                              },

                              child: state?.profileLoading ?? false
                                  ? ScreenLoader(key: ValueKey('loader'))
                                  : state?.profileErrorMsg != null
                                  ? ErrorCard(
                                      key: ValueKey('error'),
                                      message: state?.profileErrorMsg ?? "",
                                    )
                                  : ListViewScreen(
                                      key: ValueKey('profile'),
                                      data: state?.karyakarthaProfile,
                                      screenType: "USER_PROFILE",
                                      onClose: () {
                                        context.read<KaryakarthaBloc>().add(
                                          CloseProfileView(),
                                        );
                                        // karyakartha-view
                                      },
                                      onDelete: () {
                                        DeletionPopup.showDeleteConfirmation(
                                          context: context,
                                          onConfirm: () {
                                            final karyakarthaId =
                                                state?.karyakarthaProfile?.id;
                                            if (karyakarthaId != null) {
                                              context
                                                  .read<KaryakarthaBloc>()
                                                  .add(
                                                    DeleteKaryakarthaEvent(
                                                      karyakarthaId,
                                                    ),
                                                  );
                                              Navigator.pop(context);
                                              context
                                                  .read<KaryakarthaBloc>()
                                                  .add(CloseProfileView());
                                            }
                                          },
                                          title: "Delete User ?",
                                          message:
                                              "Are you sure you want to delete this user?\nThis action cannot be undone.",
                                        );
                                      },
                                      onViewMore: () {
                                        final String? karyakarthaId =
                                            state?.karyakarthaProfile?.id;

                                        if (karyakarthaId != null &&
                                            karyakarthaId.isNotEmpty) {
                                          print(
                                            '🔵 Navigating with ID: $karyakarthaId',
                                          );
                                          Get.toNamed(
                                            '/karyakartha-view',
                                            arguments: karyakarthaId,
                                          );
                                        }

                                        //Get.toNamed('/karyakartha-view');
                                      },
                                    ),
                            ),
                          ),
                      ],
                    );
                  default:
                    return ScreenLoader();
                }
              },
              // child:
            ),
          ],
        ),
      ),
    );
  }
}
