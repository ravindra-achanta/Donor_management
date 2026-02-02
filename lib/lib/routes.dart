import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/screeens/assignmembers/assign_members_page.dart';
import 'package:vikas_app/screeens/authentication/login.dart';
import 'package:vikas_app/screeens/dasboard/dashboard.dart';
import 'package:vikas_app/screeens/donations/DonationsScreen.dart';
import 'package:vikas_app/screeens/jeevanadi/jeevanadilist.dart';
import 'package:vikas_app/screeens/karyakartha/karyakarthas_list_page.dart';

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
    Get.offNamed(
      redirectRoute,
    ); 
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
  page: () => JeevanadiMembersPage(),
  // middlewares: [AuthMiddleware()], // optional if you need auth
),

GetPage(
      name: '/assign-members',
      page: () => const AssignMembersPage(),
      // middlewares: [AuthMiddleware()],
    ),

   GetPage(
  name: '/donations',
  page: () => DonationsScreen(),
),

    
    // GetPage(
    //   name: '/dashboard',
    //   page: () => const AdminDashboardPage(),
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
