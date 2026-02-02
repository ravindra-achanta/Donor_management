import 'package:http/http.dart';

abstract class NetworkResponseListener {
  void onNetworkCallInitiated(String typeOfRequest);

  void onSuccess(Response response, String typeOfRequest);

  void onFailure(int responsecode, Response response, String typeOfRequest);
}
