import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:vikas_app/images.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/localizations/language.dart';
import 'package:vikas_app/screeens/authentication/login.dart';
import 'package:vikas_app/themes/app_notifier.dart';
import 'package:vikas_app/themes/app_style.dart';
import 'package:vikas_app/themes/theme_customizer.dart';
import 'package:vikas_app/utils/mixins/ui_mixins.dart';
//import 'package:vikas_app/views/auth/login.dart';
import 'package:vikas_app/widgets/custom_pop_menu.dart';

class TopBar extends StatefulWidget {
  const TopBar({
    super.key, // this.onMenuIconTap,
  });

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar>
    with SingleTickerProviderStateMixin, UIMixin {
  Function? languageHideFn;

  bool isMenuVisible = true;

  String empId = "";
  String likeCount = LocalStorage().getString("HEART");
  String punchesCount = LocalStorage().getString("PUNCH");
  String rewardPoints = LocalStorage().getString("REWARD");

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var theme = Theme.of(context);
    bool isMobileView = width < 600;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        color: Colors.grey[200],
        child: FxCard(
          shadow: FxShadow(
            position: FxShadowPosition.bottomRight,
            elevation: 0.5,
          ),
          height: 75,
          borderRadiusAll: 0,
          padding: FxSpacing.x(24),
          color: topBarTheme.background.withAlpha(246),
          child: Row(
            children: [
              Row(
                children: [
                  InkWell(
                    splashColor: colorScheme.onSurface,
                    highlightColor: colorScheme.onSurface,
                    onTap: () {
                      ThemeCustomizer.toggleLeftBarCondensed();
                    },
                    child: Icon(
                      LucideIcons.menu,
                      color: topBarTheme.onBackground,
                    ),
                  ),
                  FxSpacing.width(24),
                  SizedBox(
                    width: 190,
                    child: Builder(
                      builder: (context) {
                        // Get the current theme
                        final isDarkMode =
                            Theme.of(context).brightness == Brightness.dark;

                        return TextFormField(
                          maxLines: 1,
                          style: FxTextStyle.bodyMedium(
                            color: isDarkMode
                                ? Colors.white
                                : Colors
                                      .black, // Adjust text color based on theme
                          ),
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: FxTextStyle.bodySmall(
                              xMuted: true,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey, // Adjust hint text color
                            ),
                            border: outlineInputBorder,
                            enabledBorder: outlineInputBorder,
                            focusedBorder: focusedInputBorder,

                            // Background color based on the current theme
                            filled: true,
                            fillColor: isDarkMode
                                ? const Color(
                                    0xFF333333,
                                  ) // Dark grey for dark mode
                                : const Color(
                                    0xFFF0F0F0,
                                  ), // Light grey for light mode
                            // Prefix icon for search field
                            prefixIcon: const Align(
                              alignment: Alignment.center,
                              child: Icon(FeatherIcons.search, size: 14),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 36,
                              maxWidth: 36,
                              minHeight: 32,
                              maxHeight: 32,
                            ),
                            contentPadding: FxSpacing.xy(16, 12),
                            isCollapsed: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // FxSpacing.width(6),
                    // CustomPopupMenu(
                    //   backdrop: true,
                    //   onChange: (_) {},
                    //   offsetX: -120,
                    //   menu: Padding(
                    //     padding: FxSpacing.xy(8, 8),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         GestureDetector(
                    //           onTap: () {
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) => HeartsPunches(),
                    //               ),
                    //             );
                    //           },
                    //           child: TimeBeatDB().getString("USER_TYPE") ==
                    //                   "ADMIN"
                    //               ? Icon(
                    //                   Icons.favorite, // Heart icon
                    //                   color: Colors.red,
                    //                   size: 18,
                    //                 )
                    //               : Row(
                    //                   children: [
                    //                     Icon(
                    //                       Icons.favorite, // Heart icon
                    //                       color: Colors.red,
                    //                       size: 18,
                    //                     ),
                    //                     const SizedBox(
                    //                         width:
                    //                             4), // Spacing between heart and count
                    //                     Text(
                    //                       likeCount
                    //                           .toString(), // Ensure likeCount is a string
                    //                       style: const TextStyle(
                    //                         fontSize: 14,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Colors.red,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   menuBuilder: (_) => buildNotifications(),
                    // ),
                    FxSpacing.width(12),
                    // CustomPopupMenu(
                    //   backdrop: true,
                    //   // hideFn: (_) => languageHideFn = _,
                    //   hideFn: (fn) => languageHideFn = fn,

                    //   onChange: (_) {},
                    //   offsetX: -36,
                    //   menu: Padding(
                    //     padding: FxSpacing.xy(8, 8),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         GestureDetector(
                    //           onTap: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => HeartsPunches(),
                    //                 ),
                    //               );
                    //           },
                    //           child: TimeBeatDB().getString("USER_TYPE") ==
                    //                   "ADMIN"
                    //               ? Icon(
                    //                   Icons.sports_mma, // Punch/Fist icon
                    //                   color: Color.fromARGB(255, 3, 3, 3),
                    //                   size: 23,
                    //                 )
                    //               : Row(
                    //                   children: [
                    //                     Icon(
                    //                       Icons
                    //                           .sports_mma, // Punch/Fist icon
                    //                       color: Color.fromARGB(255, 3, 3, 3),
                    //                       size: 18,
                    //                     ),
                    //                     const SizedBox(
                    //                         width:
                    //                             4), // Spacing between icon and count
                    //                     Text(
                    //                       punchesCount
                    //                           .toString(), // Ensure punchesCount is a string
                    //                       style: const TextStyle(
                    //                         fontSize: 14,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Color.fromARGB(255, 3, 3, 3),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   menuBuilder: (_) => buildLanguageSelector(),
                    // ),
                    //  FxSpacing.width(12),
                    // CustomPopupMenu(
                    //   backdrop: true,
                    //   // hideFn: (_) => languageHideFn = _,
                    //   hideFn: (fn) => languageHideFn = fn,

                    //   onChange: (_) {},
                    //   offsetX: -36,
                    //   menu: Padding(
                    //     padding: FxSpacing.xy(8, 8),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         GestureDetector(
                    //           onTap: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => HeartsPunches(),
                    //                 ),
                    //               );
                    //           },

                    //           child: TimeBeatDB().getString("USER_TYPE") ==
                    //                   "ADMIN"
                    //               ? Icon(
                    //                   Icons.military_tech, // Punch/Fist icon
                    //                   color: const Color.fromARGB(255, 1, 82, 28),
                    //                   size: 23,
                    //                 )
                    //               : Row(
                    //                   children: [
                    //                     Icon(
                    //                       Icons.military_tech, // Punch/Fist icon
                    //                       color: const Color.fromARGB(255, 1, 82, 28),
                    //                       size: 18,
                    //                     ),
                    //                     const SizedBox(
                    //                         width:
                    //                             4), // Spacing between icon and count

                    //                     Text(
                    //                       rewardPoints
                    //                           .toString(), // Ensure punchesCount is a string
                    //                       style: const TextStyle(
                    //                         fontSize: 14,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: const Color.fromARGB(255, 1, 82, 28),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   menuBuilder: (_) => buildLanguageSelector(),
                    // ),
                    // FxSpacing.width(12),
                    // InkWell(
                    //   onTap: () {
                    //     ThemeCustomizer.setTheme(
                    //         ThemeCustomizer.instance.theme == ThemeMode.dark
                    //             ? ThemeMode.light
                    //             : ThemeMode.dark);
                    //   },
                    //   child: Icon(
                    //     ThemeCustomizer.instance.theme == ThemeMode.dark
                    //         ? FeatherIcons.sun
                    //         : FeatherIcons.moon,
                    //     size: 18,
                    //     color: topBarTheme.onBackground,
                    //   ),
                    // ),
                    // FxSpacing.width(12),
                    FxSpacing.width(6),
                    // CustomPopupMenu(
                    //   backdrop: true,
                    //   onChange: (_) {},
                    //   offsetX: -120,
                    //   menu: Padding(
                    //     padding: FxSpacing.xy(8, 8),
                    //     child: const Center(
                    //       child: Icon(
                    //         FeatherIcons.bell,
                    //         size: 18,
                    //       ),
                    //     ),
                    //   ),
                    //   menuBuilder: (_) => buildNotifications(),
                    // ),
                    FxSpacing.width(4),
                    CustomPopupMenu(
                      backdrop: true,
                      onChange: (_) {},
                      offsetX: -60,
                      offsetY: 8,
                      menu: Padding(
                        padding: FxSpacing.xy(8, 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FxContainer.rounded(
                              paddingAll: 0,
                              child: Image.network(
                                LocalStorage().getString("USER_PROFILE"),
                                height: 28,
                                width: 28,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person, size: 28),
                              ),
                            ),
                            FxSpacing.width(8),
                            FxText.labelLarge(
                              LocalStorage().getString("USER_NAME"),
                            ),
                          ],
                        ),
                      ),
                      // menuBuilder: (_) => buildAccountMenu(),
                      menuBuilder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Visibility(
                              visible: isMenuVisible,
                              child: buildAccountMenu(),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLanguageSelector() {
    return FxText("");
    // FxContainer.bordered(
    //   padding: FxSpacing.xy(8, 8),
    //   width: 125,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: Language.languages
    //         .map((language) => FxButton.text(
    //               padding: FxSpacing.xy(8, 4),
    //               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //               splashColor: contentTheme.onBackground.withAlpha(20),
    //               onPressed: () async {
    //                 languageHideFn?.call();
    //                 // Language.changeLanguage(language);
    //                 await Provider.of<AppNotifier>(context, listen: false)
    //                     .changeLanguage(language, notify: true);
    //                 ThemeCustomizer.notify();
    //                 setState(() {});
    //               },
    //               child: Row(
    //                 children: [
    //                   ClipRRect(
    //                       clipBehavior: Clip.antiAliasWithSaveLayer,
    //                       borderRadius: BorderRadius.circular(2),
    //                       child: Image.asset(
    //                         "assets/lang/${language.locale.languageCode}.jpg",
    //                         width: 18,
    //                         height: 14,
    //                         fit: BoxFit.cover,
    //                       )),
    //                   FxSpacing.width(8),
    //                   FxText.labelMedium(language.languageName)
    //                 ],
    //               ),
    //             ))
    //         .toList(),
    //   ),
    // );
  }

  Widget buildNotifications() {
    Widget buildNotification(String title, String description) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.labelLarge(title),
          FxSpacing.height(4),
          FxText.bodySmall(description),
        ],
      );
    }

    return FxText("");
    // FxContainer.bordered(
    //   paddingAll: 0,
    //   width: 250,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Padding(
    //         padding: FxSpacing.xy(16, 12),
    //         child: FxText.titleMedium("Notification", fontWeight: 600),
    //       ),
    //       FxDashedDivider(
    //           height: 1, color: theme.dividerColor, dashSpace: 4, dashWidth: 6),
    //       Padding(
    //         padding: FxSpacing.xy(16, 12),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             buildNotification("Your order is received",
    //                 "Order #1232 is ready to deliver"),
    //             FxSpacing.height(12),
    //             buildNotification("Account Security ",
    //                 "Your account password changed 1 hour ago"),
    //           ],
    //         ),
    //       ),
    //       FxDashedDivider(
    //           height: 1, color: theme.dividerColor, dashSpace: 4, dashWidth: 6),
    //       Padding(
    //         padding: FxSpacing.xy(16, 0),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             FxButton.text(
    //               onPressed: () {},
    //               splashColor: contentTheme.primary.withAlpha(28),
    //               child: FxText.labelSmall(
    //                 "View All",
    //                 color: contentTheme.primary,
    //               ),
    //             ),
    //             FxButton.text(
    //               onPressed: () {},
    //               splashColor: contentTheme.danger.withAlpha(28),
    //               child: FxText.labelSmall(
    //                 "Clear",
    //                 color: contentTheme.danger,
    //               ),
    //             ),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  Widget buildAccountMenu() {
    (LocalStorage().getString("USER_TYPE") == "ADMIN")
        ? empId = LocalStorage().getString("ADMIN_ID")
        : LocalStorage().getString("ID");

    return FxContainer.bordered(
      paddingAll: 0,
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: FxSpacing.xy(8, 8),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // FxButton(
          //       //   // onPressed: () {
          //       //   //   Get.toNamed('/contacts/profile');
          //       //   //   setState(() {});
          //       //   // },

          //       //   // onPressed: () {
          //       //   //   print("ssssssssssssssss${empId}");
          //       //   //   setState(() {
          //       //   //     isMenuVisible = false; // Hide the menu
          //       //   //   });
          //       //   //   Get.toNamed(
          //       //   //     '/employee/view',
          //       //   //     arguments: {"id": empId}, // Pass arguments here
          //       //   //   );
          //       //   // },
          //       //   // onPressed: () =>
          //       //   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //       //   borderRadiusAll: AppStyle.buttonRadius.medium,
          //       //   padding: FxSpacing.xy(8, 4),
          //       //   splashColor: colorScheme.onSurface.withAlpha(20),
          //       //   backgroundColor: Colors.transparent,
          //       //   child: Row(
          //       //     // children: [
          //       //     //   Icon(
          //       //     //     FeatherIcons.user,
          //       //     //     size: 14,
          //       //     //     color: contentTheme.onBackground,
          //       //     //   ),
          //       //     //   FxSpacing.width(8),
          //       //     //   FxText.labelMedium(
          //       //     //     "My Profile",
          //       //     //     fontWeight: 600,
          //       //     //   )
          //       //     // ],
          //       //   ),
          //       // ),
          //       // FxSpacing.height(4),
          //       // FxButton(
          //       //   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //       //   // onPressed: () {
          //       //   //   Get.toNamed('/contacts/edit-profile');
          //       //   //   setState(() {});
          //       //   // },
          //       //   onPressed: () {
          //       //     print("ssssssssssssssss${empId}");
          //       //     setState(() {
          //       //       isMenuVisible = false; // Hide the menu
          //       //     });
          //       //     Get.toNamed(
          //       //       "/employee/update",
          //       //       arguments: {
          //       //         "update": true,
          //       //         "id": empId,
          //       //       },
          //       //     );
          //       //   },
          //       //   borderRadiusAll: AppStyle.buttonRadius.medium,
          //       //   padding: FxSpacing.xy(8, 4),
          //       //   splashColor: colorScheme.onSurface.withAlpha(20),
          //       //   backgroundColor: Colors.transparent,
          //       //   // child: Row(
          //       //   //   // children: [
          //       //   //   //   Icon(
          //       //   //   //     FeatherIcons.edit,
          //       //   //   //     size: 14,
          //       //   //   //     color: contentTheme.onBackground,
          //       //   //   //   ),
          //       //   //   //   FxSpacing.width(8),
          //       //   //   //   FxText.labelMedium(
          //       //   //   //     "Edit Profile",
          //       //   //   //     fontWeight: 600,
          //       //   //   //   )
          //       //   //   // ],
          //       //   // ),
          //       // ),
          //     ],
          //   ),
          // ),
          // const Divider(
          //   height: 1,
          //   thickness: 1,
          // ),
          Padding(
            padding: FxSpacing.xy(8, 8),
            child: FxButton(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // onPressed: () {
              //   Get.off(const LoginPage());
              //   setState(() {});
              // },
              onPressed: () {
                setState(() {
                  isMenuVisible = false; // Hide the menu
                  LocalStorage.sharedPreferences!.clear();
                });

                // Add a slight delay to ensure the UI updates
                Future.delayed(Duration(milliseconds: 100), () {
                  Get.offAll(const LoginPage());
                });
              },

              borderRadiusAll: AppStyle.buttonRadius.medium,
              padding: FxSpacing.xy(8, 4),
              splashColor: contentTheme.danger.withAlpha(28),
              backgroundColor: Colors.transparent,
              child: Row(
                children: [
                  Icon(
                    FeatherIcons.logOut,
                    size: 14,
                    color: contentTheme.danger,
                  ),
                  FxSpacing.width(8),
                  FxText.labelMedium(
                    "Log out",
                    fontWeight: 600,
                    color: contentTheme.danger,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
