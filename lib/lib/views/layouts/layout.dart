import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:vikas_app/admin_theme.dart';
import 'package:vikas_app/views/layout_controller.dart';
import 'package:vikas_app/images.dart';
import 'package:vikas_app/themes/app_style.dart';
import 'package:vikas_app/themes/theme_customizer.dart';
import 'package:vikas_app/views/layouts/left_bar.dart';
import 'package:vikas_app/views/layouts/top_bar.dart';
import 'package:vikas_app/widgets/custom_pop_menu.dart';

class Layout extends StatelessWidget {
  final Widget? child;

  final LayoutController controller = LayoutController();
  final topBarTheme = AdminTheme.theme.topBarTheme;
  final contentTheme = AdminTheme.theme.contentTheme;

  Layout({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return FxResponsive(builder: (BuildContext context, _, screenMT) {
      return FxBuilder(
          controller: controller,
          builder: (controller) {
            return screenMT.isMobile ? mobileScreen() : largeScreen();
          });
    });
  }

  Widget mobileScreen() {
    final topBarBackgroundColor = ThemeCustomizer.instance.theme == ThemeMode.dark
      ? const Color(0xFF333333) 
      : const Color(0xFFF0F0F0);
    return Scaffold(
      //key: controller.scaffoldKey,
      drawer: const LeftBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: topBarBackgroundColor,
              title: Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 16.0),
                child: TextFormField(
                  //maxLines: 1,
                  style: FxTextStyle.bodyMedium(
                    color: ThemeCustomizer.instance.theme == ThemeMode.dark
                        ? const Color.fromARGB(213, 255, 255, 255)
                        : const Color.fromARGB(
                            117, 0, 0, 0), 
                  ),
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: FxTextStyle.bodySmall(
                      xMuted: true,
                      color: ThemeCustomizer.instance.theme == ThemeMode.dark
                          ? Colors.grey[400]
                          : Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                          width: 1,
                          strokeAlign: 0,
                          color: colorScheme.onSurface.withAlpha(80)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                          width: 1,
                          strokeAlign: 0,
                          color: colorScheme.onSurface.withAlpha(80)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide:
                          BorderSide(width: 1, color: colorScheme.primary),
                    ),

                    // Background color based on the current theme
                    filled: true,
                    fillColor: ThemeCustomizer.instance.theme == ThemeMode.dark
                        ? const Color(0xFF333333) 
                        : const Color(0xFFF0F0F0), 

                    // Prefix icon for search field
                    prefixIcon: const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        FeatherIcons.search,
                        size: 12,
                      ),
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
                ),
              ),
              iconTheme: IconThemeData(
                  color: ThemeCustomizer.instance.theme == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: topBarBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxSpacing.width(6),
                  CustomPopupMenu(
                    backdrop: true,
                    onChange: (_) {},
                    offsetX: -120,
                    menu: Padding(
                      padding: FxSpacing.xy(8, 8),
                      child: const Center(
                        child: Icon(
                          FeatherIcons.heart,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                    menuBuilder: (_) => buildNotifications(),
                  ),
                  FxSpacing.width(6),
                  CustomPopupMenu(
                    backdrop: true,
                    onChange: (_) {},
                    offsetX: -36,
                    menu: Padding(
                      padding: FxSpacing.xy(8, 8),
                      child: Center(
                        child: ClipRRect(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          borderRadius: BorderRadius.circular(2),
                          child: Image.asset(
                            "assets/fist.png",
                            width: 24,
                            height: 18,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    menuBuilder: (_) => buildNotifications(),
                  ),
                  FxSpacing.width(6),
                  InkWell(
                    onTap: () {
                      ThemeCustomizer.setTheme(
                          ThemeCustomizer.instance.theme == ThemeMode.dark
                              ? ThemeMode.light
                              : ThemeMode.dark);
                    },
                    child: Icon(
                      ThemeCustomizer.instance.theme == ThemeMode.dark
                          ? FeatherIcons.sun
                          : FeatherIcons.moon,
                      size: 18,
                      color: topBarTheme.onBackground,
                    ),
                  ),
                  FxSpacing.width(8),
                  CustomPopupMenu(
                    backdrop: true,
                    onChange: (_) {},
                    offsetX: -180,
                    menu: Padding(
                      padding: FxSpacing.xy(8, 8),
                      child: const Center(
                        child: Icon(
                          FeatherIcons.bell,
                          size: 18,
                        ),
                      ),
                    ),
                    menuBuilder: (_) => buildNotifications(),
                  ),
                  FxSpacing.width(8),
                  CustomPopupMenu(
                    backdrop: true,
                    onChange: (_) {},
                    offsetX: -90,
                    offsetY: 4,
                    menu: Padding(
                      padding: FxSpacing.xy(8, 8),
                      child: FxContainer.rounded(
                          paddingAll: 0,
                          child: Image.asset(
                            Images.avatars[0],
                            height: 28,
                            width: 28,
                            fit: BoxFit.cover,
                          )),
                    ),
                    menuBuilder: (_) => buildAccountMenu(),
                  ),
                  FxSpacing.width(20)
                ],
              ),
            ),
          ],
        ),
      ), // endDrawer: RightBar(),
      // extendBodyBehindAppBar: true,
      // appBar: TopBar(

      body: SingleChildScrollView(
        //key: controller.scrollKey,
        child: child,
      ),
    );
  }

  Widget largeScreen() {
    return Scaffold(
      //key: controller.scaffoldKey,
      //endDrawer: RightBar(),
      body: Row(
        children: [
          LeftBar(isCondensed: ThemeCustomizer.instance.leftBarCondensed),
          Expanded(
              child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  padding:
                      FxSpacing.fromLTRB(0, 58 + flexSpacing, 0, flexSpacing),
                 // key: controller.scrollKey,
                  child: child,
                ),
              ),
              const Positioned(top: 0, left: 0, right: 0, child: TopBar()),
            ],
          )),
          // Expanded(
          //     child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     TopBar(),
          //     Expanded(
          //         child: SingleChildScrollView(
          //       padding: FxSpacing.y(flexSpacing),
          //       key: controller.scrollKey,
          //       child: child,
          //     )),
          //   ],
          // ))
        ],
      ),
    );
  }

  Widget buildNotifications() {
    Widget buildNotification(String title, String description) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.labelLarge(title),
          FxSpacing.height(4),
          FxText.bodySmall(description)
        ],
      );
    }

    return FxContainer.bordered(
      paddingAll: 0,
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: FxSpacing.xy(16, 12),
            child: FxText.titleMedium("Notification", fontWeight: 600),
          ),
          FxDashedDivider(
              height: 1, color: theme.dividerColor, dashSpace: 4, dashWidth: 6),
          Padding(
            padding: FxSpacing.xy(16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildNotification("Your order is received",
                    "Order #1232 is ready to deliver"),
                FxSpacing.height(12),
                buildNotification("Account Security ",
                    "Your account password changed 1 hour ago"),
              ],
            ),
          ),
          FxDashedDivider(
              height: 1, color: theme.dividerColor, dashSpace: 4, dashWidth: 6),
          Padding(
            padding: FxSpacing.xy(16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxButton.text(
                  onPressed: () {},
                  splashColor: contentTheme.primary.withAlpha(28),
                  child: FxText.labelSmall(
                    "View All",
                    color: contentTheme.primary,
                  ),
                ),
                FxButton.text(
                  onPressed: () {},
                  splashColor: contentTheme.danger.withAlpha(28),
                  child: FxText.labelSmall(
                    "Clear",
                    color: contentTheme.danger,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildAccountMenu() {
    return FxContainer.bordered(
      paddingAll: 0,
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: FxSpacing.xy(8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxButton(
                  onPressed: () => {},
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  borderRadiusAll: AppStyle.buttonRadius.medium,
                  padding: FxSpacing.xy(8, 4),
                  splashColor: colorScheme.onSurface.withAlpha(20),
                  backgroundColor: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        FeatherIcons.user,
                        size: 14,
                        color: contentTheme.onBackground,
                      ),
                      FxSpacing.width(8),
                      FxText.labelMedium(
                        "My Account",
                        fontWeight: 600,
                      )
                    ],
                  ),
                ),
                FxSpacing.height(4),
                FxButton(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () => {},
                  borderRadiusAll: AppStyle.buttonRadius.medium,
                  padding: FxSpacing.xy(8, 4),
                  splashColor: colorScheme.onSurface.withAlpha(20),
                  backgroundColor: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        FeatherIcons.settings,
                        size: 14,
                        color: contentTheme.onBackground,
                      ),
                      FxSpacing.width(8),
                      FxText.labelMedium(
                        "Settings",
                        fontWeight: 600,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: FxSpacing.xy(8, 8),
            child: FxButton(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () => {},
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
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
