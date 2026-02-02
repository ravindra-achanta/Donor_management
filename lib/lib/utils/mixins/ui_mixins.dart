import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:vikas_app/admin_theme.dart';

mixin UIMixin {
  // ThemeData get theme => AppStyle.theme;
  LeftBarTheme get leftBarTheme => AdminTheme.theme.leftBarTheme;

  TopBarTheme get topBarTheme => AdminTheme.theme.topBarTheme;

  RightBarTheme get rightBarTheme => AdminTheme.theme.rightBarTheme;

  ContentTheme get contentTheme => AdminTheme.theme.contentTheme;

  VisualDensity get getCompactDensity =>
      const VisualDensity(horizontal: -4, vertical: -4);

  // ColorScheme get colorScheme => theme.colorScheme;

  OutlineInputBorder get outlineInputBorder => OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(
            width: 1,
            strokeAlign: 0,
            color: colorScheme.onSurface.withAlpha(80)),
      );

  OutlineInputBorder focusedInputBorder = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(width: 1, color: colorScheme.primary),
  );

  OutlineInputBorder generateOutlineInputBorder({double radius = 4}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
      );

  OutlineInputBorder generateFocusedInputBorder({double radius = 4}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: BorderSide(width: 1, color: colorScheme.primary),
      );

  Widget getBackButton(FxNavigationMixin navigationMixin) {
    return InkWell(
      onTap: navigationMixin.goBack,
      child: Center(
        child: Icon(
          Icons.chevron_left_rounded,
          size: 26,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget getDashedDivider() {
    return FxDashedDivider(
        dashWidth: 6,
        dashSpace: 4,
        color: colorScheme.onSurface.withAlpha(64),
        height: 0.5);
  }
}
