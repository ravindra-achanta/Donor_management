import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vikas_app/apiServices/local_storage/VikasDB.dart';
import 'package:vikas_app/screeens/dasboard/dashboard.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:vikas_app/routes.dart';
import 'localizations/app_localization_delegate.dart';
import 'navigation_service.dart';
import 'themes/app_notifier.dart';
import 'themes/app_style.dart';
import 'themes/theme_customizer.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  await LocalStorage.init();
  AppStyle.init();
  await ThemeCustomizer.init();

  runApp(
    ChangeNotifierProvider<AppNotifier>(
      create: (_) => AppNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
   @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (_, notifier, ___) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeCustomizer.instance.theme,
          navigatorKey: NavigationService.navigatorKey,
          initialRoute: "/login",
          getPages: getPageRoute(),
          localizationsDelegates: [
            AppLocalizationsDelegate(context),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // home: DashboardPage(),
          // home: ButtonsPage(),
        );
      },
    );
  }
}
