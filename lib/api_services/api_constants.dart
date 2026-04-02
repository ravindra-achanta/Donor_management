class ApiConstants {
    static const String baseUrl = "http://172.235.18.48:8050";
   //static const String baseUrl = "https://vikas.vidyaranyam.in";
   

  static const String VIKAS = "/vikas/api/v1";
  static const String IDM_URI = "/vikas/api/v1/idm";
  static const String JEEVANADI_URI = "/vikas/api/v1/jeevanaadi";
  static const String role_URI = "/vikas/api/v1/role";
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
  //static const String UPDATE_PROFILE = "$IDM_URI/update/user";
   static const String UPDATE_USER = "$IDM_URI/update/user";           
  static const String UPDATE_PROFILE = "$IDM_URI/update/user/profile"; // Profile-specific 
  //roles
  static const String GET_ROLES = "${role_URI}/roles";
   static const String CHECK_LOGIN = "$IDM_URI/user";
  static const String LOGIN_WITH_ROLE = "$IDM_URI/user";
static const String jeevandi_search = "${JEEVANADI_URI}/users/";

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

  static String getJeevanaadiUpdate = "$VIKAS/vikas/jeevanaadi/";
  static String getrequestview = "$VIKAS/vikas/jeevanaadi/staff/requests";
  static String getrequestviewbyid = "$VIKAS/vikas/jeevanaadi/staff/requests";
 static String approverequest = "$VIKAS/vikas/jeevanaadi/";

  //notices
  static const String NOTICES_BASE = "${IDM_URI}/notices";
  //visits
  static const String visitsList = "$VIKAS/visits/list";
  static const String visitsCreate = "$VIKAS/visits/create";
  static const String visitsUpdate = "$VIKAS/visits";
  static const String visitsDetails = "$VIKAS/visits";
  static const String visitsDelete = "$VIKAS/visits";
   static const String visitMetrics = "$VIKAS/visits/charts/metric";
  static const String ACTIVITY_DASHBOARD = "$VIKAS/activity/dashboard";


  static const String DHARMASETU_LIST = "$VIKAS/dharmasetu/list";
  static const String DHARMASETU_GET_BY_ID = "$VIKAS/dharmasetu";
  static const String DHARMASETU_CREATE = "$VIKAS/dharmasetu";
  static const String DHARMASETU_UPDATE = "$VIKAS/dharmasetu/{id}";
  static const String DHARMASETU_DELETE = "$VIKAS/dharmasetu/{id}/delete";


  // Notices APIs

static const String unReadNoticesList = "$VIKAS/notice/unread";
static const String allNotices = "$VIKAS/notice/all";
static const String noticesCreate = "$VIKAS/notice/create";
//static const String noticesUpdate = "$VIKAS/notice/{id}/update"; 
static const String noticesUpdate = "$VIKAS/notice/{id}/update";
static const String noticesRead = "$VIKAS/notice/{id}/read";


//
static const String metrics = "$IDM_URI/metrics/user";

static const String uploadimage = "$IDM_URI/image";

//activity/callLogs
static const String ACTIVITY_LIST = "$VIKAS/callLogs/list";
static const String ACTIVITY_CREATE = "$VIKAS/callLogs/create";

static const String DELETE_USER = "$IDM_URI/delete/user";





  //review
  //static const String REVIEW_REQUESTS = "$VIKAS/jeevanaadi";
}
