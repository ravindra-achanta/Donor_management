import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';

class BaseController {
  void showDialogue(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          const Center(child: CircularProgressIndicator()),
    );
  }

  void hideProgressDialogue(BuildContext context) {
    Navigator.of(context).pop(const Center(child: CircularProgressIndicator()));
  }

  bool isAuthorizationExpired() {
    String token = Vikasdb().getString("TOKEN");

    if (!token.isEmptyOrNull) {
      // Decode the JWT token
      Map<String, dynamic>? decodedToken = JwtDecoder.decode(token);

      // Check if the token has expired
      bool isExpired = JwtDecoder.isExpired(token);

      // Get the expiration date
      DateTime expirationDate = JwtDecoder.getExpirationDate(token);

      if (isExpired) {
        print('Token is expired');
        return true;
      } else {
        print('Token is valid until: $expirationDate');
        return false;
      }
    } else {
      return true;
    }
  }

  // Future<void> addDeviceToken() async {
  //   String deviceId = "", deviceType = "";
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     deviceId = iosDeviceInfo.identifierForVendor!;
  //     deviceType = "IOS"; // unique ID on iOS
  //   } else if (Platform.isAndroid) {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     deviceId = androidDeviceInfo.id; // unique ID on Android
  //     deviceType = "ANDROID";
  //   }
  //   String token = HrmsDB().getString("FCM_TOKEN");
  //   DeviceTokenRequest deviceTokensRequest = DeviceTokenRequest(
  //       deviceId: deviceId, deviceType: deviceType, deviceToken: token);
  //   Response apiResponseData =
  //       await ApiService().addDeviceToken(deviceTokensRequest);
  //   if (apiResponseData.statusCode == 200) {
  //     print("added device token");
  //   }
  // }

  // void handleNotificationPayload(NotificationResponse notificationResponse) {
  //   if (notificationResponse.payload!.isNotEmpty) {
  //     String notificationType =
  //         json.decode(notificationResponse.payload!)['notificationType'];
  //     String actionId =
  //         notificationResponse.actionId! == "APPROVE" ? "APPROVED" : "REJECTED";
  //     print(notificationType);
  //     print(actionId);
  //     if (notificationType == "LEAVE_APPROVAL_REQUEST") {
  //       String leaveId = json.decode(notificationResponse.payload!)['data'];
  //       print(leaveId);
  //       NotificationResponseHandler().updateLeaveRequest(leaveId, actionId);
  //     }
  //     if (notificationType == "CHECKOUT_APPROVAL_REQUEST") {
  //       String timingsId = json.decode(notificationResponse.payload!)['data'];
  //       String checkoutTime =
  //           json.decode(notificationResponse.payload!)['checkOutTime'];
  //       String checkoutStatus =
  //           json.decode(notificationResponse.payload!)['checkOutStatus'];
  //       print(timingsId);
  //       NotificationResponseHandler().updateApprovalTimings(
  //           timingsId, actionId, checkoutTime, checkoutStatus);
  //     }
  //   }
  // }

  String getCurrentUserType() {
    String userType = Vikasdb().getString('USER_TYPE');
    print("PRINT USER TYPE-----$userType");
    if (!userType.isEmptyOrNull) {
      return userType;
    } else {
      return "";
    }
  }

  Widget searchNotFound(BuildContext context) {
    return Column(
      children: [
        //20.height,
        const SizedBox(height: 20),
        Image.asset('images/emp1.png', width: 200, height: 200),
        //20.height,
        const SizedBox(height: 20),

        const Text(
          'No results found',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // bool isAuthorizationExpired() {
  //   String token = NustarDB().getString("TOKEN");

  //   if (!token.isEmptyOrNull) {
  //     // Decode the JWT token
  //     Map<String, dynamic>? decodedToken = JwtDecoder.decode(token);

  //     // Check if the token has expired
  //     bool isExpired = JwtDecoder.isExpired(token);

  //     // Get the expiration date
  //     DateTime expirationDate = JwtDecoder.getExpirationDate(token);

  //     if (isExpired) {
  //       print('Token is expired');
  //       return true;
  //     } else {
  //       print('Token is valid until: $expirationDate');
  //       return false;
  //     }
  //   } else {
  //     return true;
  //   }
  // }

  // Future<bool> checkImage(File pickedImage) async {
  //   final bytes = await pickedImage.readAsBytes();
  //   final lengthInBytes = bytes.length;
  //   final mb = lengthInBytes / (1024 * 1024);
  //   if (mb > 6) {
  //     await successDialog(
  //         "Please upload an image with a file size of less than 6 MB.");
  //     return false;
  //   } else {
  //     var decodedImage = await decodeImageFromList(bytes);
  //     if (decodedImage.width != 500 || decodedImage.height != 500) {
  //       await successDialog(
  //           "Please upload an image with dimensions of 500x500 pixels.");
  //       return false;
  //     } else {
  //       return true;
  //     }
  //   }
}

  // Future<List<MediaData>> fetchAllImages(String selectedCategory) async {
  //   try {
  //     dynamic apiResponse = await ApiService().getAllMedia(selectedCategory);
  //     if (apiResponse is List<dynamic>) {
  //       List<MediaData> allImages = [];
  //       for (dynamic data in apiResponse) {
  //         if (data is Map<String, dynamic>) {
  //           MediaData image = MediaData.fromJson(data);
  //           allImages.add(image);
  //         } else {
  //           print('Warning: API response item is not a valid JSON object');
  //         }
  //       }
  //       return allImages;
  //     } else {
  //       print('Error: API response is not a valid JSON list');
  //       return [];
  //     }
  //   } catch (e) {
  //     print('Error fetching images: $e');
  //     return [];
  //   }
  // }

