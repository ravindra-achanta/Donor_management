import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/screeens/Activity/ActivityDashboardScreen.DART';
import 'package:vikas_app/screeens/Activity/ActivityListScreen.dart';
import 'package:vikas_app/screeens/Activity/ActivityScreen.dart';
import 'package:vikas_app/screeens/assignmembers/assign_members_page.dart';
import 'package:vikas_app/screeens/authentication/login.dart';
import 'package:vikas_app/screeens/authentication/password_change_screen.dart';
import 'package:vikas_app/screeens/authentication/registration_page.dart';
import 'package:vikas_app/screeens/dasboard/ActivityScorePage.dart';
import 'package:vikas_app/screeens/dasboard/DonationsReportScreen.dart';
import 'package:vikas_app/screeens/dasboard/dashboard.dart';
import 'package:vikas_app/screeens/dasboard/profile_analytics_screen.dart';
import 'package:vikas_app/screeens/dharmasetu/AddDharmasetu.dart';
import 'package:vikas_app/screeens/dharmasetu/dharmaset.dart';
import 'package:vikas_app/screeens/dharmasetu/ViewDharmasetu.dart';
import 'package:vikas_app/screeens/dharmasetu/editDharmasetu.dart';
import 'package:vikas_app/screeens/jeevanadi/jeevanaadi_list_page.dart';
import 'package:vikas_app/screeens/jeevanadi/view_jeevanadi_screen.dart';
import 'package:vikas_app/screeens/karyakartha/KaryakarthaViewPage.dart';
import 'package:vikas_app/screeens/karyakartha/karyakarthas_list_page.dart';
import 'package:vikas_app/screeens/logout/LogoutScreen.dart';
import 'package:vikas_app/screeens/models/enum/RegistrationType.dart';
import 'package:vikas_app/screeens/models/response/notice_response.dart';
import 'package:vikas_app/screeens/notices/NoticesListScreen.dart';
import 'package:vikas_app/screeens/notices/notice_detail_screen.dart';
import 'package:vikas_app/screeens/notices/notices.dart';
import 'package:vikas_app/screeens/profile/profile.dart';
import 'package:vikas_app/screeens/profile/profile_edit.dart';
import 'package:vikas_app/screeens/requests/review_requests.dart';
import 'package:vikas_app/screeens/users/users_list_page.dart';
import 'package:vikas_app/screeens/visits/visits.dart';
import 'package:vikas_app/screeens/visits/AddVisit.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    print('Checking route: $route');

    if (route == '/login') return null;

    if (isAuthorizationExpired()) {
      print('Redirecting to login');
      Vikasdb().clearSharedPref();
      return RouteSettings(name: '/login', arguments: route);
    }

    return null;
  }

  bool isAuthorizationExpired() {
    String token = Vikasdb().getString("TOKEN") ?? "";

    if (token.isEmpty) return true;

    return isExpired(token);
  }

  bool isExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
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
    GetPage(
      name: '/password-change',
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return PasswordChangeScreen(
          mobileNumber: args['mobileNumber'] ?? '',
          userId: args['userId'] ?? '',
          token: args['token'] ?? '',
        );
      },
    ),
    GetPage(name: '/dashboard', page: () => const Dashboard()),

    GetPage(
      name: '/karyakarthas',
      page: () => const KaryakarthasListPage(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/jeevanadi',
      page: () => JeevanaadiListPage(),
      middlewares: [AuthMiddleware()], // optional if you need auth
    ),

    GetPage(
      name: '/assign-members',
      page: () => const AssignMembersPage(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/register',
      page: () => const RegistrationPage(
        title: "Add new User",
        type: RegistrationType.user,
        user: null,
      ),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/profile',
      page: () => const MyProfile(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/dharmasetu',
      page: () => const DharmasetuListScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/add/dharmasetu',
      page: () => const AddDharmasetu(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/view/dharmasetu',
      page: () => const ViewDharmasetu(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/notices/list',
      page: () => const NoticesListScreen(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/notices',
      page: () {
        final args = Get.arguments;
        final notice = args is NoticeResponse ? args : null;
        return Notices(noticeData: notice);
      },
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/view/notice',
      page: () => NoticeDetailPage(notice: Get.arguments as NoticeResponse),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
  name: '/profile-edit',
  page: () {
    final userId = Get.arguments as String? ?? '';
    return ProfileEditScreen(userId: userId);
  },
  middlewares: [AuthMiddleware()],
),
    GetPage(
      name: '/visits',
      page: () => const VisitsListScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/add/visit',
      page: () => const AddVisit(),
      middlewares: [AuthMiddleware()],
    ),
//     GetPage(
//   name: '/activity-dashboard',
//   page: () {
//     final String userId = Get.arguments as String? ?? '';
//     return ActivityDashboardScreen(id: userId);
//   },
 
//   middlewares: [AuthMiddleware()],
// ),

    GetPage(
      name: '/users',
      page: () => const Users(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/requests',
      page: () => const ReviewRequests(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/karyakartha-view',
      page: () {
        //=> const KaryaKarthaViewScreen(memberId: ""),
        final String karyakarthaId = Get.arguments as String? ?? '';
        return KaryaKarthaViewScreen(karyakarthaId: karyakarthaId);
      },
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/activity-list',
      page: () => const ActivityListScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/activity',
      page: () => const CreateActivityScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/logout',
      page: () => const LogoutScreen(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/jeevandiview',
      page: () => ViewJeevanadiScreen.withArguments(),
      middlewares: [AuthMiddleware()],
    ),
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
