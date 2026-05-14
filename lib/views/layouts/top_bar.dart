import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/bloc_management/authentication/auth_bloc.dart';
import 'package:vikas_app/bloc_management/authentication/auth_event.dart';
import 'package:vikas_app/bloc_management/authentication/auth_state.dart';
import 'package:vikas_app/screeens/authentication/login.dart';
import 'package:vikas_app/screeens/models/enum/user_type.dart';
import 'package:vikas_app/themes/app_style.dart';
import 'package:vikas_app/themes/theme_customizer.dart';
import 'package:vikas_app/utils/mixins/ui_mixins.dart';
import 'package:vikas_app/widgets/custom_pop_menu.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar>
    with SingleTickerProviderStateMixin, UIMixin {
  bool isMenuVisible = true;
  String empId = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // Hide TopBar on logout success
        if (authState.status == AuthStatus.logoutSuccess) {
          return const SizedBox.shrink();
        }

        //final userName = Vikasdb().getString("USER_NAME");
        final userName = authState.status == AuthStatus.logoutSuccess
            ? null
            : Vikasdb().getString("USER_NAME");
        if (userName == null || userName.isEmpty) {
          return const SizedBox.shrink();
        }

        return Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Container(
              color: Colors.grey[200],
              child: FxCard(
                shadow: FxShadow(
                  position: FxShadowPosition.bottomRight,
                  elevation: 0.5,
                ),
                height: 75,
                padding: FxSpacing.x(24),
                color: topBarTheme.background.withAlpha(246),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        ThemeCustomizer.toggleLeftBarCondensed();
                      },

                      child: Icon(
                        LucideIcons.menu,
                        color: topBarTheme.onBackground,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: "Welcome "),
                                TextSpan(
                                  text: userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: " ("),
                                TextSpan(text: _getUserDisplayName()),
                                const TextSpan(text: ")"),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          CustomPopupMenu(
                            backdrop: true,
                            offsetX: -140,
                            offsetY: 10,
                            menu: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                Vikasdb().getString("USER_PROFILE") ?? "",
                              ),
                              onBackgroundImageError: (_, __) {},
                              child:
                                  (Vikasdb()
                                          .getString("USER_PROFILE")
                                          ?.isEmpty ??
                                      true)
                                  ? const Icon(Icons.person, size: 18)
                                  : null,
                            ),
                            menuBuilder: (context) => buildAccountMenu(),
                            onChange: (value) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// ================= DROPDOWN =================
  Widget buildAccountMenu() {
    empId = (Vikasdb().getString("USER_TYPE") == "ADMIN")
        ? Vikasdb().getString("ADMIN_ID")
        : Vikasdb().getString("ID");

    return Material(
      child: FxContainer.bordered(
        width: 160,
        paddingAll: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 1),

            _buildMenuItem(
              icon: FeatherIcons.logOut,
              title: "Logout",
              isDanger: true,
              onTap: () {
                while (Get.isOverlaysOpen) {
                  Get.back();
                }
                if (context.mounted) {
                  context.read<AuthBloc>().add(LogoutEvent());
                  Get.offAll(() => const LoginPage());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ================= MENU ITEM =================
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isDanger ? Colors.red : contentTheme.onBackground,
            ),
            const SizedBox(width: 10),
            FxText.labelMedium(
              title,
              fontWeight: 600,
              color: isDanger ? Colors.red : contentTheme.onBackground,
            ),
          ],
        ),
      ),
    );
  }

  /// ================= USER TYPE =================
  String _getUserDisplayName() {
    final String? typeStr = Vikasdb().getString("USER_TYPE");

    if (typeStr == null || typeStr.isEmpty) {
      return "User";
    }

    try {
      final UserType userType = UserType.fromString(typeStr);
      return userType.displayName;
    } catch (e) {
      return "User";
    }
  }
}
