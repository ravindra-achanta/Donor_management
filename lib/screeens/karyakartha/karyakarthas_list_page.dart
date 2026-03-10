import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_bloc.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_event.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_state.dart';
import 'package:vikas_app/screeens/authentication/registration_page.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/add_button.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/deletion_popup.dart';
import 'package:vikas_app/screeens/common/list_view.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/models/enum/RegistrationType.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class KaryakarthasListPage extends StatefulWidget {
  const KaryakarthasListPage({super.key});

  @override
  State<KaryakarthasListPage> createState() => _KaryakarthasListPageState();
}

class _KaryakarthasListPageState extends State<KaryakarthasListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<KaryakarthaBloc>().add(FetchKaryakattasEvent(0));
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<KaryakarthaBloc, KaryakarthaState?>(
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "All Karyakarthas",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (Vikasdb().getString("USER_TYPE") != "GURUJI")
                                AddButton().addButton(
                                  context: context,
                                  buttonText: "Add Karyakartha",
                                  onClicked: () {
                                    //Get.toNamed('/register');
                                    Get.to(
                                      () => RegistrationPage(
                                        title: "Add Karyakartha",
                                        type: RegistrationType.karyakartha,
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
                                  onUserTap: (id) {
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
                                        // deleteUserApi(user.id);
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
                                            type: RegistrationType.karyakartha,
                                            user: user,
                                            isEdit: true,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      debugPrint('User not found with id: $id');
                                    }
                                  },
                                ),
                                // const SizedBox(height: 16),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (state!.currentPage > 0) {
                                            context.read<KaryakarthaBloc>().add(
                                              FetchKaryakattasEvent(
                                                state.currentPage - 1,
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
                                            context.read<KaryakarthaBloc>().add(
                                              FetchKaryakattasEvent(
                                                state.currentPage + 1,
                                              ),
                                            );
                                          }
                                        },
                                        icon: Icon(Icons.skip_next_outlined),
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
                                      onConfirm: () {},
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
      ),
    );
  }
}
