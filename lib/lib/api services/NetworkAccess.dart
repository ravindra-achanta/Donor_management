import 'package:vikas_app/apiServices/NetworkApiEndpoints.dart';
import 'package:vikas_app/apiServices/NetworkRequestService.dart';
import 'package:vikas_app/apiServices/NetworkResponseListener.dart';
import 'package:vikas_app/apiServices/local_storage/VikasDB.dart';

class NetworkAccess {
  Map<String, String>? headers;
  NetworkAccess() {
    headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    String? token = LocalStorage().getString('TOKEN');

    // Conditionally add the Authorization header if the token is not null or empty
    if (token.isNotEmpty) {
      headers!["Authorization"] = "Bearer $token";
    }
  }

  void createAdminLogin(
    NetworkResponseListener networkResponseListener,
    Map<String, dynamic> body,
    String typeOfRequest,
  ) {
    print("CORS ACCESSSSSS");
    NetowrkRequestService().postRequest(
      NetworkApiEndPoints().adminLoginCreation,
      body,
      headers!,
      networkResponseListener,
      typeOfRequest,
    );
  }

  // void fetchCustomersCN(
  //   NetworkResponseListener networkResponseListener,
  //   String typeOfRequest,
  // ) {
  //   NetowrkRequestService().getRequest(
  //     "${NetworkApiEndPoints.PM_URI}cn/task/customers",
  //     headers!,
  //     networkResponseListener,
  //     typeOfRequest,
  //   );
  // }

  // void fetchCustomerBS(
  //   NetworkResponseListener networkResponseListener,
  //   String typeOfRequest,
  // ) {
  //   NetowrkRequestService().getRequest(
  //     "${NetworkApiEndPoints.PM_URI}bs/task/customers",
  //     headers!,
  //     networkResponseListener,
  //     typeOfRequest,
  //   );
  // }

  // void fetchTasksBS(
  //   NetworkResponseListener networkResponseListener,
  //   String typeOfRequest,
  //   String sortOrder,
  // ) {
  //   String sortParam = sortOrder == "NEWEST" ? "desc" : "asc";

  //   NetowrkRequestService().getRequest(
  //     "${NetworkApiEndPoints.PM_URI}bs/task/blueswan?sortOrder=$sortParam",
  //     headers!,
  //     networkResponseListener,
  //     typeOfRequest,
  //   );
  //   print(
  //     "Prrint url bs:${NetworkApiEndPoints.PM_URI}bs/task/blueswan?sortOrder=$sortParam",
  //   );
  // }

  // void postCustomer(
  //   NetworkResponseListener networkResponseListener,
  //   id,
  //   iscn,
  //   String typeOfRequest,
  // ) {
  //   NetowrkRequestService().postRequest(
  //     "${NetworkApiEndPoints.IDM_URI}client/$id?isCN=$iscn",
  //     {},
  //     headers!,
  //     networkResponseListener,
  //     typeOfRequest,
  //   );
  // }

  // void fetchRolesList(
  //   NetworkResponseListener networkResponseListener,
  //   String typeOfRequest,
  //   int pageCount,
  //   int size,
  // ) {
  //   NetowrkRequestService().getRequest(
  //     "${NetworkApiEndPoints().fetchRolesList}?page=$pageCount&size=$size",
  //     headers!,
  //     networkResponseListener,
  //     typeOfRequest,
  //   );
  // }

  // void createRole(
  //   NetworkResponseListener networkResponseListener,
  //   Map<String, dynamic> body,
  //   String typeOfRequest,
  // ) {
  //   NetowrkRequestService().postRequest(
  //     NetworkApiEndPoints().createRole,
  //     body,
  //     headers!,
  //     networkResponseListener,
  //     typeOfRequest,
  //   );
  // }

  // void fetchRoleById(
  //   NetworkResponseListener networkResponseListener,
  //   String typeOfRequest,
  //   String id,
  // ) {
  //   NetowrkRequestService().getRequest(
  //     "${NetworkApiEndPoints().fetchRoleById}$id",
  //     headers!,
  //     networkResponseListener,
  //     typeOfRequest,
  //   );
  // }

  void updateRole(
    NetworkResponseListener networkResponseListener,
    Map<String, dynamic> body,
    String typeOfRequest,
    String id,
  ) {
    print("Network Accesss: $id"); // Add this line
    NetowrkRequestService().patchRequest(
      "${NetworkApiEndPoints().updateRole}$id",
      body,
      headers!,
      networkResponseListener,
      typeOfRequest,
    );
  }

  void deleteRole(
    NetworkResponseListener networkResponseListener,
    String typeOfRequest,
    String id,
  ) {
    // Perform DELETE request using the endpoint with the provided role ID
    NetowrkRequestService().deleteMethod2(
      "${NetworkApiEndPoints().deleteRole}$id", // Assuming 'deleteRole' is the endpoint for roles
      headers!,
      networkResponseListener,
      typeOfRequest,
    );
  }

  
}
