class NetworkApiEndPoints {
  // Single base URL for all environments
  //static const String BASE_URL = "https://test.vyavastha.bytesedge.com";

  // // Localhost (uncomment when needed)
  static const String BASE_URL1 = "http://172.105.35.110:8085";
  static const String BASE_URL2 = "http://172.105.35.110:8086";
  static const String BASE_URL3 = "http://172.105.35.110:8087";
  static const String CLIENT_URL = "http://172.105.35.110:5000";

  // static const String BASE_URL1 = "https://vyavastha.bytesedge.com";
  // static const String BASE_URL2 = "https://vyavastha.bytesedge.com";
  // static const String BASE_URL3 = "https://vyavastha.bytesedge.com";
  // static const String CLIENT_URL = "https://vyavastha.bytesedge.com";

  // Common base URIs
  static const String IDM_URI = "$BASE_URL1/idm/api/v1/";
  static const String CM_URI = "$CLIENT_URL/clientmanagement/api/v1/";
  static const String PM_URI = "$BASE_URL2/project/api/v1/";
  static const String AT = "$BASE_URL3/attendance"; // 👈 added
  static const String AT_URI = "$AT/api/v1/"; // 👈 updated to reuse AT

  // ================= EMPLOYEE ONBOARDING =================

final String adminLoginCreation = "${IDM_URI}authenticate";

  final String addempexperience = "${IDM_URI}experience/";
  final String getFilteredProjects = "${PM_URI}projects";
  final String personalinfoProfile = "${IDM_URI}upload";
  final String updateprofile = "${IDM_URI}employee/";
  final String updatePersonalInfoEndpoint = "${IDM_URI}employee/";
  final String addEmployeePersonalInformation = "${IDM_URI}employee";
  final String addpersonaldocuments = "${IDM_URI}documents/";
  final String addEmployeeAddress = "${IDM_URI}employee/";
  final String addEmployeeEducationInfo = "${IDM_URI}education/";
  final String fetchEmployeePersonalDetailsByDept =
      "${IDM_URI}employee/department/";

  // final String activeClients = "${IDM_URI}client/customers";
  // final String fetchEmployeeList = "${IDM_URI}employee";
  // final String updateEmployeeContactAddress = "${IDM_URI}employee/";

  // ================= EMPLOYEE VIEW =================
  // final String fetchEmployeePersonalDetailsall = "${IDM_URI}employee/status";
  // final String fetchEmployeePersonalDetails = "${IDM_URI}employee/";
  // final String fetchEmployeeaddressdetails = "${IDM_URI}employee/";
  // final String fetchEmployeeContactAddress = "${IDM_URI}employee/";
  // final String fetchEmployeeExperience = "${IDM_URI}experience/";
  // final String fetchEmployeeDocuments = "${IDM_URI}documents/";
  // final String fetchEmployeeEducationalDetails = "${IDM_URI}education/";
  // final String fetchEmployeeExperienceDetails = "${IDM_URI}experience/";

  // final String UpdateEmployeeExperience = "${IDM_URI}experience/";
  // final String updatepersonaldocuments = "${IDM_URI}documents/";

  // final String deleteEmployee = "${IDM_URI}employee/";
  // final String versionHistory = "${PM_URI}scrumteam/";

  // ================= AUTH & ROLES =================
  //final String adminLoginCreation = "${IDM_URI}authenticate";
  final String fetchRolesList = "${IDM_URI}roles";
  final String createRole = "${IDM_URI}roles";
  final String deleteRole = "${IDM_URI}roles/";
  final String updateRole = "${IDM_URI}roles/";
  final String fetchRoleById = "${IDM_URI}roles/";

  // ================= DEPARTMENT =================
  // final String fetchDepartmentList = "${IDM_URI}department";
  // final String fetchSchemesList = "${IDM_URI}schemes";
  // final String fetchStagesList = "${PM_URI}stages/department";
  // final String createDepartment = "${IDM_URI}department";

  // final String deleteDepartment = "${IDM_URI}department/";
  // final String updateDepartment = "${IDM_URI}department/";
  // final String fetchDepartmentById = "${IDM_URI}department/";
















  // Optional placeholder
  get getLeaveCount => null;
}
