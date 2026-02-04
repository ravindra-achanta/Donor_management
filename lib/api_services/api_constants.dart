class ApiConstants {
  static const String baseUrl = "http://localhost:8050";

  static const String IDM_URI = "/vikas/api/v1/idm";
  // Timeouts
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  // Endpoints
  static const String GET_KARYAKARTHAS = "${IDM_URI}/user/all";
  static const String GET_KARYAKARTHAS_BY_ID = "${IDM_URI}/user";
}
