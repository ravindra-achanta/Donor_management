class ChangePasswordRequest {
  final String newPassword;
  final String mobileNumber;

  ChangePasswordRequest({
    required this.newPassword,
    required this.mobileNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "newPassword": newPassword,
      "mobileNumber": mobileNumber,
    };
  }
}
