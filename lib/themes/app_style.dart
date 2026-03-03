/*
* File : App Theme
* Version : 1.0.0
* Flutter 3.27+ Compatible
* */

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:google_fonts/google_fonts.dart';

class MaterialRadius {
  double xs, small, medium, large;

  MaterialRadius({
    this.xs = 2,
    this.small = 4,
    this.medium = 6,
    this.large = 8,
  });
}

class ColorGroup {
  final Color color, onColor;

  ColorGroup(this.color, this.onColor);
}

class AppTheme {
  static ThemeData theme = AppTheme.getThemeFromThemeMode();
  static TextDirection textDirection = TextDirection.ltr;

  static Color primaryColor = const Color(0xff3874ff);

  // Simple manual theme mode
  static ThemeMode currentThemeMode = ThemeMode.light;

  static ThemeData getThemeFromThemeMode() {
    return currentThemeMode == ThemeMode.light ? lightTheme : darkTheme;
  }

  /// -------------------------- Light Theme  -------------------------------------------- ///

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    primaryColor: AppTheme.primaryColor,

    scaffoldBackgroundColor: const Color(0xffF5F5F5),
    canvasColor: Colors.transparent,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffF5F5F5),
      iconTheme: IconThemeData(color: Color(0xff495057)),
      actionsIconTheme: IconThemeData(color: Color(0xff495057)),
    ),

    cardTheme: const CardThemeData(color: Color(0xffffffff)),
    cardColor: const Color(0xffffffff),

    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xff3874ff),
      brightness: Brightness.light,
    ),

    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.white),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppTheme.primaryColor,
      splashColor: const Color(0xffeeeeee).withAlpha(100),
      highlightElevation: 8,
      elevation: 4,
      focusColor: AppTheme.primaryColor,
      hoverColor: AppTheme.primaryColor,
      foregroundColor: const Color(0xffeeeeee),
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xffdddddd),
      thickness: 1,
    ),
    dividerColor: const Color(0xffdddddd),

    bottomAppBarTheme: const BottomAppBarThemeData(
      color: Color(0xffeeeeee),
      elevation: 2,
    ),

    tabBarTheme: TabBarThemeData(
      unselectedLabelColor: const Color(0xff495057),
      labelColor: AppTheme.primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2.0),
      ),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: AppTheme.primaryColor,
      inactiveTrackColor: AppTheme.primaryColor.withAlpha(140),
      trackShape: const RoundedRectSliderTrackShape(),
      trackHeight: 4.0,
      thumbColor: AppTheme.primaryColor,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(color: Color(0xffeeeeee)),
    ),

    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      checkColor: WidgetStateProperty.all(const Color(0xffffffff)),
      fillColor: WidgetStateProperty.all(AppTheme.primaryColor),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppTheme.primaryColor
            : Colors.white,
      ),
    ),

    splashColor: Colors.white.withAlpha(100),
    indicatorColor: const Color(0xffeeeeee),
    highlightColor: const Color(0xffeeeeee),
  );

  /// -------------------------- Dark Theme  -------------------------------------------- ///

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xff262729),
    canvasColor: Colors.transparent,

    primaryColor: const Color(0xff4ddada),

    appBarTheme: const AppBarTheme(backgroundColor: Color(0xff262729)),

    cardTheme: const CardThemeData(color: Color(0xff1b1b1c)),
    cardColor: const Color(0xff1b1b1c),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff3874ff),
      background: const Color(0xff262729),
      onBackground: const Color(0xFFD7D7D7),
      brightness: Brightness.dark,
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xff393A41),
      thickness: 1,
    ),
    dividerColor: const Color(0xff393A41),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppTheme.primaryColor,
      splashColor: Colors.white.withAlpha(100),
      highlightElevation: 8,
      elevation: 4,
      focusColor: AppTheme.primaryColor,
      hoverColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
    ),

    bottomAppBarTheme: const BottomAppBarThemeData(
      color: Color(0xff464c52),
      elevation: 2,
    ),

    tabBarTheme: TabBarThemeData(
      unselectedLabelColor: const Color(0xff495057),
      labelColor: AppTheme.primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2.0),
      ),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: AppTheme.primaryColor,
      inactiveTrackColor: AppTheme.primaryColor.withAlpha(100),
      trackShape: const RoundedRectSliderTrackShape(),
      trackHeight: 4.0,
      thumbColor: AppTheme.primaryColor,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(color: Colors.white),
    ),

    indicatorColor: Colors.white,
    disabledColor: const Color(0xffa3a3a3),
    highlightColor: const Color(0xff47484b),
    splashColor: Colors.white.withAlpha(100),
  );

  static ThemeData createTheme(ThemeMode themeType, Color seedColor) {
    if (themeType == ThemeMode.light) {
      return lightTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
      );
    }
    return darkTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
        onBackground: const Color(0xFFDAD9CA),
      ),
    );
  }
}

class AppStyle {
  static void init() {
    initFxStyle();
  }

  static void changeFxTheme() {
    Fx.changeTheme(AppTheme.theme);
  }

  static void initFxStyle() {
    FxTextStyle.resetFontStyles();
    FxTextStyle.changeFontFamily(GoogleFonts.spaceGrotesk);
    Fx.changeTheme(AppTheme.theme);

    Fx.setConstant(
      FxConstantData(
        containerRadius: AppStyle.containerRadius.medium,
        cardRadius: AppStyle.cardRadius.medium,
        buttonRadius: AppStyle.buttonRadius.medium,
      ),
    );

    bool isMobile = true;
    try {
      isMobile = Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      isMobile = false;
    }
    Fx.setFlexSpacing(isMobile ? 16 : 24);
  }

  static MaterialRadius buttonRadius = MaterialRadius(
    small: 2,
    medium: 4,
    large: 8,
  );
  static MaterialRadius cardRadius = MaterialRadius(
    xs: 2,
    small: 4,
    medium: 4,
    large: 8,
  );
  static MaterialRadius containerRadius = MaterialRadius(
    xs: 2,
    small: 4,
    medium: 4,
    large: 8,
  );
  static MaterialRadius imageRadius = MaterialRadius(
    xs: 2,
    small: 4,
    medium: 4,
    large: 8,
  );
}

class AppColors {
  static const Color star = Color(0xffFFC233);
  static Color ratingStarColor = const Color(0xFFF9A825);
  static Color success = const Color(0xff1abc9c);

  static ColorGroup pink = ColorGroup(
    const Color(0xffFFC2D9),
    const Color(0xffF5005E),
  );
  static ColorGroup violet = ColorGroup(
    const Color(0xffD0BADE),
    const Color(0xff4E2E60),
  );
  static ColorGroup blue = ColorGroup(
    const Color(0xffADD8FF),
    const Color(0xff004A8F),
  );
  static ColorGroup green = ColorGroup(
    const Color(0xffAFE9DA),
    const Color(0xff165041),
  );
  static ColorGroup orange = ColorGroup(
    const Color(0xffFFCEC2),
    const Color(0xffFF3B0A),
  );
  static ColorGroup skyBlue = ColorGroup(
    const Color(0xffC2F0FF),
    const Color(0xff0099CC),
  );
  static ColorGroup lavender = ColorGroup(
    const Color(0xffEAE2F3),
    const Color(0xff7748AD),
  );
  static ColorGroup blueViolet = ColorGroup(
    const Color(0xffC5C6E7),
    const Color(0xff3B3E91),
  );

  static List<ColorGroup> list = [
    orange,
    violet,
    blue,
    green,
    skyBlue,
    lavender,
    blueViolet,
  ];

  static ColorGroup get random => list[Random().nextInt(list.length)];

  static ColorGroup get(int index) {
    return list[index % list.length];
  }
}
