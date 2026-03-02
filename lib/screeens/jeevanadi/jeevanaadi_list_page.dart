import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/add_button.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/list_view.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadiView.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/screeens/models/request/JeevanaadiFullProfile.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class JeevanaadiListPage extends StatefulWidget {
  const JeevanaadiListPage({super.key});

  @override
  State<JeevanaadiListPage> createState() => _JeevanaadiListPageState();
}

class _JeevanaadiListPageState extends State<JeevanaadiListPage> {
  @override
  void initState() {
    super.initState();
    context.read<JeevanaadiBloc>().add(FetchJeevanaadisEvent(0));
  }

  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<JeevanaadiBloc, JeevanaadiState?>(
          builder: (context, state) {
            switch (state?.status) {
              case JeevanaadiApiStatus.loading:
                return ScreenLoader();
              case JeevanaadiApiStatus.error:
                return Center(
                  child: ErrorCard(message: state?.errorMessage ?? ""),
                );
              case JeevanaadiApiStatus.loaded:
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
                                  "All Jeevanaadi Members",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // AddButton().addButton(
                                //   context: context,
                                //   buttonText: "Add Karyakartha",
                                //   onClicked: () {
                                //     Get.toNamed('/register');
                                //   },
                                // ),
                              ],
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                CommonList<JeevanaadiUser>(
                                  currentPage: state?.currentPage ?? 0,
                                  users: state!.jeevanaadisMems,
                                  onUserTap: (id) {
                                    context.read<JeevanaadiBloc>().add(
                                      FetchJeevanaadiProfileEvent(id),
                                    );
                                  },
                                  screenType: "JEEVANADI",
                                  onDelete: (id) {},
                                  onUpdate: (id) {},
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
                                            context.read<JeevanaadiBloc>().add(
                                              FetchJeevanaadisEvent(
                                                (state.currentPage ?? 0) - 1,
                                              ),
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          Icons.skip_previous_outlined,
                                        ),
                                      ),
                                      Text(
                                        "${(state.currentPage ?? 0) + 1}/${state.totalpages}",
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (state!.currentPage <
                                              state!.totalpages - 1) {
                                            context.read<JeevanaadiBloc>().add(
                                              FetchJeevanaadisEvent(
                                                (state.currentPage ?? 0) + 1,
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
                    if (state.isProfileViewVisible == true &&
                        state.profileLoading != null)
                      //if (state.isProfileViewVisible == true)
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
                              begin: const Offset(0.05, 0),
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

                          child: state.profileLoading ?? false
                              ? ScreenLoader(key: ValueKey('loader'))
                              : state.profileErrorMsg != null
                              ? ErrorCard(
                                  key: ValueKey('error'),
                                  message: state.profileErrorMsg ?? "",
                                )
                              : ListViewScreen(
                                  key: ValueKey('profile'),
                                  //user: state?.jeevanaadiProfile,
                                  user: _convertJeevanaadiProfileToUser(
                                    state?.jeevanaadiProfileFull,
                                  ),
                                  onClose: () {
                                    context.read<JeevanaadiBloc>().add(
                                      CloseProfileView(),
                                    );
                                  },
                                  screenType: "JEEVANADI",
                                  onDelete: () {},

                                  // onViewMore: () {
                                  //   Get.toNamed('/jeevandiview');
                                  // },
                                  onViewMore: () {
                                    final String? jeevanadiId = state
                                        ?.jeevanaadiProfileFull
                                        ?.basicDetails
                                        .id
                                        ?.toString();

                                    if (jeevanadiId != null &&
                                        jeevanadiId.isNotEmpty) {
                                      Get.toNamed(
                                        '/jeevandiview',
                                        arguments: jeevanadiId,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Cannot load view: Member ID not found',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
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

  User? _convertJeevanaadiProfileToUser(JeevanaadiFullProfile? profile) {
    if (profile == null) return null;

    return User(
      id: profile.basicDetails.id.toString(),
      name: profile.profileDetails.fullName,
      email: profile.basicDetails.email,
      mobileNumber: profile.profileDetails.phoneNumber,
      userType: profile.basicDetails.usertype,
      status: profile.basicDetails.isActive ? 'active' : 'inactive',
      city: profile.profileDetails.city,
      state: profile.profileDetails.state,
      country: profile.profileDetails.country,
      pincode: profile.profileDetails.pincode,
      uniqueId: profile.basicDetails.jeevanadiNo,
    );
  }
}
