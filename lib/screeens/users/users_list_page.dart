import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/users/user_bloc.dart';
import 'package:vikas_app/bloc_management/users/user_event.dart';
import 'package:vikas_app/bloc_management/users/user_state.dart';
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

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUsersEvent(page: 0, size: 10));
  }

  void _callSearchApi() {
    final query = _searchController.text.trim();
    context.read<UserBloc>().add(
      FetchUsersEvent(
        page: 0,
        size: 10,
        searchQuery: query.isNotEmpty ? query : null,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StatsGrid(visibleType: "USERS"),
            BlocBuilder<UserBloc, UserState?>(
              builder: (context, state) {
                switch (state?.status) {
                  case UserScreenState.loading:
                    return const ScreenLoader();
                  case UserScreenState.error:
                    return Center(
                      child: ErrorCard(message: state?.errorMessage ?? ""),
                    );
                  case UserScreenState.loaded:
                    return Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Count chip
                                    Row(
                                      children: [
                                        const Text(
                                          "All Users",
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
                                    // Search bar
                                    CommonSearchBar(
                                      controller: _searchController,
                                      hintText: "Search users...",
                                      onSearch: (value) {
                                        context.read<UserBloc>().add(
                                          FetchUsersEvent(
                                            page: 0,
                                            size: 10,
                                            searchQuery: value.isNotEmpty
                                                ? value
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                    // Add button
                                    AddButton().addButton(
                                      context: context,
                                      buttonText: "Add New User",
                                      onClicked: () {
                                        Get.to(
                                          () => RegistrationPage(
                                            title: "Add New User",
                                            type: RegistrationType.user,
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
                                      currentPage: state?.currentPage ?? 0,
                                      users: state?.users ?? [],
                                      onUserTap: (id) {
                                        context.read<UserBloc>().add(
                                          FetchUsersProfileEvent(userId: id),
                                        );
                                      },
                                      onDelete: (id) {
                                        DeletionPopup.showDeleteConfirmation(
                                          context: context,
                                          title: "Delete User?",
                                          message:
                                              "Are you sure you want to delete this user?\nThis action cannot be undone.",
                                          confirmText: "Delete",
                                          onConfirm: () {
                                            context.read<UserBloc>().add(
                                              DeleteUserEvent(userId: id),
                                            );
                                          },
                                        );
                                      },
                                      onUpdate: (id) {
                                        Get.to(
                                          () => RegistrationPage(
                                            title: "Edit User",
                                            type: RegistrationType.user,
                                            user: null, // not needed anymore
                                            isEdit: true,
                                            userId: id,
                                          ),
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (state!.currentPage > 0) {
                                                final query = _searchController
                                                    .text
                                                    .trim();
                                                context.read<UserBloc>().add(
                                                  FetchUsersEvent(
                                                    page: state.currentPage - 1,
                                                    size: 10,
                                                    searchQuery:
                                                        query.isNotEmpty
                                                        ? query
                                                        : null,
                                                  ),
                                                );
                                              }
                                            },
                                            icon: const Icon(
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
                                                final query = _searchController
                                                    .text
                                                    .trim();
                                                context.read<UserBloc>().add(
                                                  FetchUsersEvent(
                                                    page: state.currentPage + 1,
                                                    size: 10,
                                                    searchQuery:
                                                        query.isNotEmpty
                                                        ? query
                                                        : null,
                                                  ),
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.skip_next_outlined,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
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
                            flex: 3,
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
                              child: state?.profileLoading ?? false
                                  ? const ScreenLoader(key: ValueKey('loader'))
                                  : state?.profileErrorMsg != null
                                  ? ErrorCard(
                                      key: const ValueKey('error'),
                                      message: state?.profileErrorMsg ?? "",
                                    )
                                  : ListViewScreen(
                                      key: const ValueKey('profile'),
                                      data: state?.user,
                                      screenType: "USER_PROFILE",
                                      onClose: () {
                                        context.read<UserBloc>().add(
                                          CloseProfileView(),
                                        );
                                      },
                                      onDelete: () {},
                                      onViewMore: () {},
                                    ),
                            ),
                          ),
                      ],
                    );
                  default:
                    return const ScreenLoader();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
