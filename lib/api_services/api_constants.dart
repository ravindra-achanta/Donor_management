import 'package:vikas_app/screeens/models/enum/user_type.dart';

class ApiConstants {
  static const String baseUrl = "http://172.235.18.48:8050";
  static const String VIKAS = "/vikas/api/v1/vikas";
  static const String IDM_URI = "/vikas/api/v1/idm";
  static const String JEEVANADI_URI = "/vikas/api/v1/jeevanaadi";
  static const String role_URI = "/vikas/api/v1/role";

  // Timeouts
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  // Endpoints
  static const String GET_KARYAKARTHAS = "${IDM_URI}/users/all";
  static const String GET_KARYAKARTHAS_BY_ID = "${IDM_URI}/user";

  
  //login
  static const String LOGIN = "$IDM_URI/user/login";
  static const String CREATE_USER = "$IDM_URI/user/create";
  static const String CHANGE_PASSWORD = "$IDM_URI/user/changePassword";
  static const String GET_USERS = "$IDM_URI/users/all";
  static const String GET_USER_BY_ID = "$IDM_URI/user";
  static const String UPDATE_PROFILE = "$IDM_URI/user";
  //roles
  static const String GET_ROLES = "${role_URI}/roles";

  //jeevanadi
  static const String GET_JEEVANAADIS = "${JEEVANADI_URI}/users";
  static const String jeevanadi_fullview = "${JEEVANADI_URI}/";
  static const String jeevanadi_nonallocated_users =
      "${JEEVANADI_URI}/nonallocaed/users";
  static const String jeevanadi_allocate_user = "${JEEVANADI_URI}/assignees";
  static const String jeevanadi_allocate_assignees =
      "${JEEVANADI_URI}/allocate/assignees/karyakartha";
  static const String jeevanadi_deallocate_assignees =
      "${JEEVANADI_URI}/deallocate/assignees/karyakartha";

static String getJeevanaadiUpdate = "$VIKAS/jeevanaadi/";
static String getrequestview = "$VIKAS/jeevanaadi";

 
    
  //notices
  static const String NOTICES_BASE = "${IDM_URI}/notices";

  //review 
  static const String REVIEW_REQUESTS = "$VIKAS/jeevanaadi";
}
