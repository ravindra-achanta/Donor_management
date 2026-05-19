import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/api_services/network_repos/activity_repository.dart';
import 'package:vikas_app/api_services/network_repos/auth_repository.dart';
import 'package:vikas_app/api_services/network_repos/darmasetu_repository.dart';
import 'package:vikas_app/api_services/network_repos/department_repo.dart';
import 'package:vikas_app/api_services/network_repos/office_staff_repo.dart';
import 'package:vikas_app/api_services/network_repos/visits_repo.dart';
import 'package:vikas_app/bloc_management/Activity/activity_bloc.dart';
import 'package:vikas_app/bloc_management/Officestaff/office_staff_bloc.dart';
import 'package:vikas_app/bloc_management/authentication/auth_bloc.dart';
import 'package:vikas_app/bloc_management/dashboard/dashboard_bloc.dart';
import 'package:vikas_app/bloc_management/department/department_bloc.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_bloc.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_bloc.dart';
import 'package:vikas_app/bloc_management/notices/notice_bloc.dart';
import 'package:vikas_app/bloc_management/profile/profile_bloc.dart';
import 'package:vikas_app/bloc_management/users/user_bloc.dart';
import 'package:vikas_app/bloc_management/visits/visit_bloc.dart';
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

  await Vikasdb.init();
  AppStyle.init();
  await ThemeCustomizer.init();

  runApp(
    MultiProvider(
      providers: [
        // 🔸 Theme Provider
        ChangeNotifierProvider<AppNotifier>(create: (_) => AppNotifier()),
      ],
      child: MultiBlocProvider(
        providers: [
          // 🔹 Karyakartha Bloc
          BlocProvider<KaryakarthaBloc>(create: (_) => KaryakarthaBloc()),
BlocProvider<OfficeStaffBloc>(
  create: (_) => OfficeStaffBloc(OfficeStaffRepo()),
),
           BlocProvider<DashboardBloc>(
      create: (_) => DashboardBloc(),
    ),

          // 🔹 Jeevanadi Bloc
          BlocProvider<JeevanaadiBloc>(create: (_) => JeevanaadiBloc()),

          // 🔹 profile Bloc
          BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
          BlocProvider<DharmasetuBloc>(
            create: (_) => DharmasetuBloc(DharmasetuRepository()),
          ),

          BlocProvider<VisitBloc>(
            create: (_) => VisitBloc(visitRepository: VisitRepository()),
            
          ),
          BlocProvider<NoticeBloc>(create: (_) => NoticeBloc()),
          BlocProvider<ActivityBloc>(
            create: (_) => ActivityBloc(repo: ActivityRepository()),
          ),
          BlocProvider<DepartmentBloc>(
            create: (_) => DepartmentBloc(DepartmentRepo()),
          ),
        

        BlocProvider<UserBloc>(create: (_) => UserBloc()),
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(authRepository: AuthRepository()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  getInitialRoute() {
    String? token = Vikasdb().getString("TOKEN");
    return token.isNotEmpty ? '/dashboard' : '/login';
  }

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
          initialRoute: getInitialRoute(),
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
