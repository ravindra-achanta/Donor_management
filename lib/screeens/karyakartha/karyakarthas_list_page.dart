import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_bloc.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_event.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_state.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/NoDataFound.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/common/list_view.dart';
import 'package:vikas_app/screeens/common/loader.dart';
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
    context.read<KaryakarthaBloc>().add(FetchKaryakattasEvent());
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
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            CommonList(
                              users: state?.karyakarthas ?? [],
                              onUserTap: (id) {
                                context.read<KaryakarthaBloc>().add(
                                  FetchKaryakarthaProfileEvent(id),
                                );
                              },
                              onDelete: (id) {},
                              onUpdate: (id) {},
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.skip_previous_outlined),
                                  ),
                                  Text("1/10"),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.skip_next_outlined),
                                  ),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                                  user: state?.karyakarthaProfile,
                                  onClose: () {
                                    context.read<KaryakarthaBloc>().add(
                                      CloseProfileView(),
                                    );
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
