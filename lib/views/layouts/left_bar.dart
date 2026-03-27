import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/themes/theme_customizer.dart';
import 'package:vikas_app/api_services/url_service.dart';
import 'package:vikas_app/utils/mixins/ui_mixins.dart';
import 'package:vikas_app/widgets/custom_pop_menu.dart';

typedef LeftbarMenuFunction = void Function(String key);

class LeftbarObserver {
  static Map<String, LeftbarMenuFunction> observers = {};

  static attachListener(String key, LeftbarMenuFunction fn) {
    observers[key] = fn;
  }

  static detachListener(String key) {
    observers.remove(key);
  }

  static notifyAll(String key) {
    for (var fn in observers.values) {
      fn(key);
    }
  }
}

class LeftBar extends StatefulWidget {
  final bool isCondensed;

  const LeftBar({super.key, this.isCondensed = false});

  @override
  _LeftBarState createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar>
    with SingleTickerProviderStateMixin, UIMixin {
  final ThemeCustomizer customizer = ThemeCustomizer.instance;

  bool isCondensed = false;
  String path = UrlService.getCurrentUrl();
  String empId = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isCondensed = widget.isCondensed;
    return FxCard(
      paddingAll: 0,
      shadow: FxShadow(position: FxShadowPosition.centerRight, elevation: 0.2),
      child: AnimatedContainer(
        color: leftBarTheme.background,
        width: isCondensed ? 70 : 254,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.isCondensed ? 50 : 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed('/dashboard');
                    },
                    child: widget.isCondensed
                        ? Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white, // dummy color for logo box
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.dashboard, // dummy icon
                              color: Colors.white,
                              size: 24,
                            ),
                          )
                        : Image.asset(
                            // "assets/images/icons/VyavasthaLogo.png",
                            "assets/vidyaaranayam_logo.png", // full logo

                            height: 100,
                            fit: BoxFit.contain,
                          ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Get.toNamed('/dashboard');
                  //   },
                  //   child: widget.isCondensed
                  //       ? Image.asset(
                  //           "assets/images/icons/Vyavasthaicon.png", // condensed logo icon
                  //           height: 32, // smaller size for condensed
                  //           width: 32,
                  //           fit: BoxFit.contain,
                  //         )
                  //       : Image.asset(
                  //           "assets/images/icons/VyavasthaLogo.png", // full logo
                  //           height: 100,
                  //           fit: BoxFit.contain,
                  //         ),
                  // ),
                  if (!widget.isCondensed)
                    Flexible(
                      fit: FlexFit.loose,
                      child: FxText.labelLarge(
                        "",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.red,
                          // color: colorScheme.primary,
                          letterSpacing: 1,
                        ),
                        maxLines: 1,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics:
                    //const PageScrollPhysics(),
                    // const ClampingScrollPhysics(),
                    const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavigationItem(
                      iconData: LucideIcons.layoutDashboard,
                      title: "Dashboard",
                      isCondensed: isCondensed,
                      route: '/dashboard',
                    ),
                    labelWidget("Apps"),

                    if (Vikasdb().getString("USER_TYPE") != "OFFICE_STAFF" &&
                        Vikasdb().getString("USER_TYPE") != "KARYAKARTHA")
                      NavigationItem(
                        iconData: LucideIcons.badgeCheck,
                        title: "Karyakarthas",
                        isCondensed: isCondensed,
                        route: '/karyakarthas',
                      ),
                    NavigationItem(
                      iconData: LucideIcons.heartHandshake,
                      title: "Jeevanadi Members",
                      isCondensed: isCondensed,
                      route: '/jeevanadi',
                    ),
                    if (Vikasdb().getString("USER_TYPE") != "OFFICE_STAFF" &&
                        Vikasdb().getString("USER_TYPE") != "KARYAKARTHA")
                      NavigationItem(
                        iconData: LucideIcons.users,
                        title: "Users",
                        isCondensed: isCondensed,
                        route: '/users',
                      ),
                    if (Vikasdb().getString("USER_TYPE") == "OFFICE_STAFF")
                      NavigationItem(
                        iconData: LucideIcons.fileClock,
                        title: "Requests",
                        isCondensed: isCondensed,
                        route: '/requests',
                      ),
                    NavigationItem(
                      iconData: LucideIcons.arrowLeftRight,
                      title: "Dharmasetu",
                      isCondensed: isCondensed,
                      route: '/dharmasetu',
                    ),
                    NavigationItem(
                      iconData: LucideIcons.info,
                      title: "Notices",
                      isCondensed: isCondensed,
                      route: '/notices/list',
                    ),

                    NavigationItem(
                      iconData: LucideIcons.eye,
                      title: "Visits",
                      isCondensed: isCondensed,
                      route: '/visits',
                    ),

                    NavigationItem(
                      iconData: LucideIcons.userCog,
                      title: "Profile",
                      isCondensed: isCondensed,
                      route: '/profile',
                    ),

                    NavigationItem(
                      iconData: LucideIcons.logOut,
                      title: "Logout",
                      isCondensed: isCondensed,
                      route: '/logout',
                    ),


                    // NavigationItem(
                    //   iconData: LucideIcons.userCog,
                    //   title: "jeevandi view",
                    //   isCondensed: isCondensed,
                    //   route: '/jeevandiview',
                    // ),

                    //-----------------employees-----------------//

                    // if (TimeBeatDB().getString("USER_TYPE") == "EMPLOYEE" ||
                    //     TimeBeatDB().getString("USER_TYPE") == "TEAM_LEAD" ||
                    //     TimeBeatDB().getString("USER_TYPE") == "ADMIN")

                    // MenuWidget(
                    //   iconData: LucideIcons.users,
                    //   isCondensed: isCondensed,
                    //   title: "Profile",
                    //   children: [
                    //     MenuItem(
                    //       title: "My Profile",
                    //       route: '/employee/view', // Define the route
                    //       onTap: () {
                    //         Get.toNamed(
                    //           '/employee/view',
                    //           arguments: {
                    //             "id": empId
                    //           }, // Pass arguments correctly
                    //         );
                    //       },
                    //       isCondensed: widget.isCondensed,
                    //     ),

                    //     // MenuItem(
                    //     //   title: "Edit Profile",
                    //     //   route: '/employee/update/',
                    //     //   isCondensed: widget.isCondensed,
                    //     //   onTap: () {
                    //     //     Get.toNamed(
                    //     //       "/employee/update",
                    //     //       arguments: {
                    //     //         "update": true,
                    //     //         "id": empId,
                    //     //       },
                    //     //     );
                    //     //   },
                    //     // ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget labelWidget(String label) {
    return isCondensed
        ? FxSpacing.empty()
        : Container(
            padding: FxSpacing.xy(24, 8),
            child: FxText.labelSmall(
              label.toUpperCase(),
              color: leftBarTheme.labelColor,
              muted: true,
              maxLines: 1,
              overflow: TextOverflow.clip,
              fontWeight: 700,
            ),
          );
  }
}

class MenuWidget extends StatefulWidget {
  final IconData iconData;
  final String title;
  final bool isCondensed;
  final bool active;
  final List<MenuItem> children;

  const MenuWidget({
    super.key,
    required this.iconData,
    required this.title,
    this.isCondensed = false,
    this.active = false,
    this.children = const [],
  });

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget>
    with UIMixin, SingleTickerProviderStateMixin {
  bool isHover = false;
  bool isActive = false;
  late Animation<double> _iconTurns;
  late AnimationController _controller;
  bool popupShowing = true;
  Function? hideFn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = _controller.drive(
      Tween<double>(
        begin: 0.0,
        end: 0.5,
      ).chain(CurveTween(curve: Curves.easeIn)),
    );
    LeftbarObserver.attachListener(widget.title, onChangeMenuActive);
  }

  void onChangeMenuActive(String key) {
    if (key != widget.title) {
      // onChangeExpansion(false);
    }
  }

  void onChangeExpansion(value) {
    isActive = value;
    if (isActive) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var route = UrlService.getCurrentUrl();
    isActive = widget.children.any((element) => element.route == route);
    onChangeExpansion(isActive);
    if (hideFn != null) {
      hideFn!();
    }
    // popupShowing = false;
  }

  @override
  Widget build(BuildContext context) {
    // var route = Uri.base.fragment;
    // isActive = widget.children.any((element) => element.route == route);

    if (widget.isCondensed) {
      return CustomPopupMenu(
        backdrop: true,
        show: popupShowing,
        // hideFn: (_) => hideFn = _,
        hideFn: (fn) => hideFn = fn,

        onChange: (_) {
          // popupShowing = _;
        },
        placement: CustomPopupMenuPlacement.right,
        menu: MouseRegion(
          cursor: SystemMouseCursors.click,
          onHover: (event) {
            setState(() {
              isHover = true;
            });
          },
          onExit: (event) {
            setState(() {
              isHover = false;
            });
          },
          child: FxContainer.transparent(
            margin: FxSpacing.fromLTRB(16, 0, 16, 8),
            color: isActive || isHover
                ? leftBarTheme.activeItemBackground
                : Colors.transparent,
            padding: FxSpacing.xy(8, 8),
            child: Center(
              child: Icon(
                widget.iconData,
                color: (isHover || isActive)
                    ? leftBarTheme.activeItemColor
                    : leftBarTheme.onBackground,
                size: 20,
              ),
            ),
          ),
        ),
        menuBuilder: (_) => FxContainer.bordered(
          paddingAll: 8,
          width: 190,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: widget.children,
          ),
        ),
      );
    } else {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: FxContainer.transparent(
          margin: FxSpacing.fromLTRB(24, 0, 16, 0),
          paddingAll: 0,
          child: ListTileTheme(
            contentPadding: const EdgeInsets.all(0),
            dense: true,
            horizontalTitleGap: 0.0,
            minLeadingWidth: 0,
            child: ExpansionTile(
              tilePadding: FxSpacing.zero,
              initiallyExpanded: isActive,
              maintainState: true,
              // onExpansionChanged: (_) {
              //   LeftbarObserver.notifyAll(widget.title);
              //   onChangeExpansion(_);
              // },
              onExpansionChanged: (expanded) {
                onChangeExpansion(expanded);
              },

              trailing: RotationTransition(
                turns: _iconTurns,
                child: Icon(
                  LucideIcons.chevronDown,
                  size: 18,
                  color: leftBarTheme.onBackground,
                ),
              ),
              iconColor: leftBarTheme.activeItemColor,
              childrenPadding: FxSpacing.x(12),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    widget.iconData,
                    size: 20,
                    color: isHover || isActive
                        ? leftBarTheme.activeItemColor
                        : leftBarTheme.onBackground,
                  ),
                  FxSpacing.width(18),
                  Expanded(
                    child: FxText.labelLarge(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      color: isHover || isActive
                          ? leftBarTheme.activeItemColor
                          : leftBarTheme.onBackground,
                    ),
                  ),
                ],
              ),
              collapsedBackgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
              ),
              backgroundColor: Colors.transparent,
              children: widget.children,
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    // LeftbarObserver.detachListener(widget.title);
  }
}

class MenuItem extends StatefulWidget {
  final IconData? iconData;
  final String title;
  final bool isCondensed;
  final String? route;

  const MenuItem({
    super.key,
    this.iconData,
    required this.title,
    this.isCondensed = false,
    this.route,
    required Null Function() onTap,
  });

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> with UIMixin {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    bool isActive = UrlService.getCurrentUrl() == widget.route;
    return GestureDetector(
      onTap: () {
        if (widget.route != null) {
          Get.toNamed(widget.route!);

          // FxRouter.pushReplacementNamed(context, widget.route!, arguments: 1);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: FxContainer.transparent(
          margin: FxSpacing.fromLTRB(4, 0, 8, 4),
          color: isActive || isHover
              ? leftBarTheme.activeItemBackground
              : Colors.transparent,
          width: MediaQuery.of(context).size.width,
          padding: FxSpacing.xy(18, 7),
          child: FxText.bodySmall(
            "${widget.isCondensed ? "" : "- "}  ${widget.title}",
            overflow: TextOverflow.clip,
            maxLines: 1,
            textAlign: TextAlign.left,
            fontSize: 12.5,
            color: isActive || isHover
                ? leftBarTheme.activeItemColor
                : leftBarTheme.onBackground,
            fontWeight: isActive || isHover ? 600 : 500,
          ),
        ),
      ),
    );
  }
}

class NavigationItem extends StatefulWidget {
  final IconData? iconData;
  final String title;
  final bool isCondensed;
  final String? route;

  const NavigationItem({
    super.key,
    this.iconData,
    required this.title,
    this.isCondensed = false,
    this.route,
  });

  @override
  _NavigationItemState createState() => _NavigationItemState();
}

class _NavigationItemState extends State<NavigationItem> with UIMixin {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    bool isActive = UrlService.getCurrentUrl() == widget.route;
    return GestureDetector(
      onTap: () {
        if (widget.route != null) {
          Get.toNamed(widget.route!);

          // FxRouter.pushReplacementNamed(context, widget.route!, arguments: 1);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: FxContainer.transparent(
          margin: FxSpacing.fromLTRB(16, 0, 16, 8),
          color: isActive || isHover
              ? leftBarTheme.activeItemBackground
              : Colors.transparent,
          padding: FxSpacing.xy(8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.iconData != null)
                Center(
                  child: Icon(
                    widget.iconData,
                    color: (isHover || isActive)
                        ? leftBarTheme.activeItemColor
                        : leftBarTheme.onBackground,
                    size: 20,
                  ),
                ),
              if (!widget.isCondensed)
                Flexible(fit: FlexFit.loose, child: FxSpacing.width(16)),
              if (!widget.isCondensed)
                Expanded(
                  flex: 3,
                  child: FxText.labelLarge(
                    widget.title,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    color: isActive || isHover
                        ? leftBarTheme.activeItemColor
                        : leftBarTheme.onBackground,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
