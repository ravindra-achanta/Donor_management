import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:vikas_app/admin_theme.dart';
import 'package:vikas_app/views/auth_layout_controller.dart';

class AuthLayout extends StatelessWidget {
  final Widget? child;

  final AuthLayoutController controller = AuthLayoutController();

  AuthLayout({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return FxResponsive(builder: (BuildContext context, _, screenMT) {
      return GetBuilder(
          init: controller,
          builder: (controller) {
            return screenMT.isMobile
                ? mobileScreen(context)
                : largeScreen(context);
          });
    });
  }

  Widget mobileScreen(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      body: Container(
        padding: FxSpacing.top(FxSpacing.safeAreaTop(context) + 20),
        height: MediaQuery.of(context).size.height,
        color: theme.cardTheme.color,
        child: SingleChildScrollView(
          key: controller.scrollKey,
          child: child,
        ),
      ),
    );
  }

 Widget largeScreen(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                 
                  Color.fromARGB(255, 244, 235, 235).withOpacity(0.6),
                   Color.fromARGB(255, 75, 16, 16).withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Opacity(
                opacity: 0.2,
                child: BlurHash(hash: "LDLz?TMI00%N00I=M{%M00Rj~qRP"),
              ),
            ),
          ),
          Container(
            margin: FxSpacing.only(top: 40),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: FxFlex(
                wrapAlignment: WrapAlignment.center,
                wrapCrossAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.center,
                spacing: 0,
                runSpacing: 0,
                children: [
                  FxFlexItem(
                    sizes: "xxl-8 lg-8 md-9 sm-10",
                    child: FxContainer(
                      color: AdminTheme.theme.contentTheme.background.withAlpha(230),
                      child: child ?? Container(),
                    ),
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
