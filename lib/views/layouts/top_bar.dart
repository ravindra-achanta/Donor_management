import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
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
  // Hide TopBar if user is not logged in
  final userName = Vikasdb().getString("USER_NAME");
  if (userName == null || userName.isEmpty) {
    return const SizedBox.shrink();
  }

  return Material(
    color: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
              /// LEFT MENU ICON
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
              /// RIGHT SIDE
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// TEXT
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "Welcome "),
                          TextSpan(
                            text: userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: " ("),
                          TextSpan(text: _getUserDisplayName()),
                          const TextSpan(text: ")"),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    /// AVATAR & MENU
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
                        child: (Vikasdb().getString("USER_PROFILE")?.isEmpty ?? true)
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
            /// PROFILE
            // _buildMenuItem(
            //   icon: FeatherIcons.user,
            //   title: "Profile",
            //   onTap: () {
            //     Get.toNamed(
            //       "/profile",
            //       arguments: {"id": empId},
            //     );
            //   },
            // ),

            //const Divider(height: 1),

            /// SETTINGS
            // _buildMenuItem(
            //   icon: FeatherIcons.settings,
            //   title: "Settings",
            //   onTap: () {
            //     Get.toNamed("/settings");
            //   },
            // ),
            const Divider(height: 1),

            /// LOGOUT
            // _buildMenuItem(
            //   icon: FeatherIcons.logOut,
            //   title: "Logout",
            //   isDanger: true,
            //   onTap: () async {
            //     await Vikasdb.sharedPreferences!.clear();

            //     if (Get.isOverlaysOpen) {
            //       Get.back();
            //     }

            //     Get.offAll(() => const LoginPage());
            //   },
            // ),
            /// LOGOUT
            _buildMenuItem(
              icon: FeatherIcons.logOut,
              title: "Logout",
              isDanger: true,
              onTap: () async {
                while (Get.isOverlaysOpen) {
                  Get.back();
                }

                await Vikasdb.sharedPreferences!.clear();

                await Vikasdb.sharedPreferences!.reload();

                await Future.delayed(const Duration(milliseconds: 300));

                Get.offAll(
                  () => const LoginPage(),
                  transition: Transition.fade,
                );
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
