import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/screeens/assignmembers/assign_members_page.dart';
import 'package:vikas_app/screeens/authentication/login.dart';
import 'package:vikas_app/screeens/authentication/registration_page.dart';
import 'package:vikas_app/screeens/dasboard/ActivityScorePage.dart';
import 'package:vikas_app/screeens/dasboard/DonationsReportScreen.dart';
import 'package:vikas_app/screeens/dasboard/dashboard.dart';
import 'package:vikas_app/screeens/dasboard/profile_analytics_screen.dart';
import 'package:vikas_app/screeens/dharmasetu/dharmaset.dart';
import 'package:vikas_app/screeens/dharmasetu/AddDharmasetu.dart';
import 'package:vikas_app/screeens/dharmasetu/ViewDharmasetu.dart';
import 'package:vikas_app/screeens/dharmasetu/editDharmasetu.dart';
import 'package:vikas_app/screeens/jeevanadi/jeevanaadi_list_page.dart';
import 'package:vikas_app/screeens/jeevanadi/view_jeevanadi_screen.dart';
import 'package:vikas_app/screeens/karyakartha/KaryakarthaViewPage.dart';
import 'package:vikas_app/screeens/karyakartha/karyakarthas_list_page.dart';
import 'package:vikas_app/screeens/models/enum/RegistrationType.dart';
import 'package:vikas_app/screeens/notices/NoticesListScreen.dart';
import 'package:vikas_app/screeens/notices/notice_detail_screen.dart';
import 'package:vikas_app/screeens/notices/notices.dart';
import 'package:vikas_app/screeens/profile/profile.dart';
import 'package:vikas_app/screeens/requests/review_requests.dart';
import 'package:vikas_app/screeens/users/users_list_page.dart';
import 'package:vikas_app/screeens/visits/EditVisit.dart';
import 'package:vikas_app/screeens/visits/visits.dart';
import 'package:vikas_app/screeens/visits/AddVisit.dart';
import 'package:vikas_app/screeens/visits/ViewVisit.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // print('Middleware: Checking authorization for route: $route');
    // bool isAuthorizationExpired = BaseController().isAuthorizationExpired();
    // if (isAuthorizationExpired) {
    //   print('Authorization expired, redirecting to login.');
    //   return RouteSettings(name: '/auth/login', arguments: route);
    // } else {
    //   print('Authorization not expired, redirecting to login.');
    // }
    // return null;
    // return AuthService.isLoggedIn
    //     ? null
    //     : const RouteSettings(name: '/auth/login');
  }
}

onLoginSuccess() {
  String? redirectRoute = Get.arguments;
  if (redirectRoute != null) {
    Get.offNamed(redirectRoute);
  } else {
    Get.offNamed('/dashboard'); // Default to dashboard if no specific redirect
  }
}

getPageRoute() {
  var routes = [
    // GetPage(
    //   name: '/',
    //   page: () => const AdminDashboardPage(),
    //   middlewares: [AuthMiddleware()],
    // ),
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/dashboard', page: () => const Dashboard()),

    GetPage(
      name: '/karyakarthas',
      page: () => const KaryakarthasListPage(),
      //middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/jeevanadi',
      page: () => JeevanaadiListPage(),
      // middlewares: [AuthMiddleware()], // optional if you need auth
    ),

    GetPage(
      name: '/assign-members',
      page: () => const AssignMembersPage(),
      // middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/register',
      page: () => const RegistrationPage(
        title: "Add new User",
        type: RegistrationType.user,
        user: null,
      ),
    ),

    GetPage(name: '/profile', page: () => const MyProfile()),
    GetPage(name: '/dharmasetu', page: () => const DharmasetuListScreen()),
    GetPage(name: '/add/dharmasetu', page: () => const AddDharmasetu()),
    GetPage(name: '/view/dharmasetu', page: () => const ViewDharmasetu()),
    GetPage(name: '/edit/dharmasetu', page: () => const EditDharmasetu()),

    GetPage(name: '/notices', page: () => const Notices()),
    GetPage(name: '/notices/list', page: () => const NoticesListScreen()),
    GetPage(
      name: '/view/notice',
      page: () => NoticeDetailScreen(notice: Get.arguments),
    ),
    GetPage(name: '/visits', page: () => const VisitsListScreen()),
    GetPage(name: '/add/visit', page: () => const AddVisit()),
    //GetPage(name: '/edit/visit', page: () => const EditVisit()),
    GetPage(
      name: '/edit/visit',
      page: () => EditVisit(visitData: Get.arguments),
    ),
    GetPage(name: '/view/visit', page: () => const ViewVisit()),
    GetPage(name: '/users', page: () => const Users()),
    GetPage(name: '/requests', page: () => const ReviewRequests()),
    GetPage(
      name: '/karyakartha-view',
      page: () {
        //=> const KaryaKarthaViewScreen(memberId: ""),
        final String karyakarthaId = Get.arguments as String? ?? '';
        return KaryaKarthaViewScreen(karyakarthaId: karyakarthaId);
      },
    ),

    GetPage(
      name: '/profile-analytics',
      page: () => const ProfileAnalyticsScreen(),
    ),

    GetPage(
      name: '/profile-analytics',
      page: () => const ActivityScoreScreen(),
    ),

    GetPage(
      name: '/profile-analytics',
      page: () => const DonationsReportScreen(),
    ),

    //GetPage(name: '/jeevandiview', page: () => ViewJeevanadiScreen(userId: '',)),
    // GetPage(
    //   name: '/jeevandiview',
    //   page: () {
    //     final String userId = Get.arguments as String? ?? '';
    //     return ViewJeevanadiScreen(userId: userId);
    //   },
    // ),
    //GetPage(name: '/jeevandiview', page: () => ViewJeevanadiScreen()),
    GetPage(
  name: '/jeevandiview', 
  page: () {
    final args = Get.arguments;
    return ViewJeevanadiScreen.fromArguments(args);
  },
),

    // GetPage(
    //   name: '/dashboard',
    //   page: () => const AdminDashboardPage()
    //   middlewares: [AuthMiddleware()],
    // ),
    // GetPage(
    //   name: '/dashboard',
    //   page: () => const AdminDashboardPage(),
    //   middlewares: [AuthMiddleware()],
    // ),

    // GetPage(
    //   name: '/admin/dashboard',
    //   page: () => AdminDashboardPage(),
    //   middlewares: [AuthMiddleware()],
    // ),

    //        GetPage(
    //   name: '/karyakarthas',
    //   page: () => BlocProvider(
    //     create: (context) => KaryakarthasBloc(KaryakarthasRepository()),
    //     child: const KaryakarthasListPage(),
    //   ),
    //   middlewares: [AuthMiddleware()],
    //   //transition: Transition.noTransition,
    // ),

    // GetPage(name: '/auth/forgot_password', page: () => const ForgotPassword()),
    // GetPage(name: '/auth/reset_password', page: () => const ResetPassword()),
  ];

  return routes
      .map(
        (e) => GetPage(
          name: e.name,
          page: e.page,
          middlewares: e.middlewares,
          //transition: Transition.noTransition,
        ),
      )
      .toList();
}
