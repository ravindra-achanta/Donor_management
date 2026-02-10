import 'package:vikas_app/screeens/models/enum/user_type.dart';

class ApiConstants {
  static const String baseUrl = "http://172.235.18.48:8050";

  static const String IDM_URI = "/vikas/api/v1/idm";
  // Timeouts
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  // Endpoints
  static const String GET_KARYAKARTHAS = "${IDM_URI}/user/all";
  static const String GET_KARYAKARTHAS_BY_ID = "${IDM_URI}/user";

  //notices
  static const String NOTICES_BASE = "${IDM_URI}/notices";
  //login
  static const String LOGIN = "$IDM_URI/user/login";

}
