
// class JeevanaadiUser  {
//   final String id;
//   final String userName;
//   final String? email;
//   final String? userType;

//   const JeevanaadiUser({
//     required this.id,
//     required this.userName,
//     this.email,
//     this.userType,
//   });

//   factory JeevanaadiUser.fromJson(Map<String, dynamic> json) {
//     return JeevanaadiUser(
//       id: json['id']?.toString() ?? '',
//       userName: json['userName']?.toString() ?? '',
//       email: json['email']?.toString(), 
//       userType: json['userType']?.toString(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'userName': userName,
//       'email': email,
//       'userType': userType,
//     };
//   }

// }

class JeevanaadiUser {
  final String id;
  final String userName;
  final String? email;
  final double? profileCompletionPercentage;
  final String? jeevanaadiNo;

  const JeevanaadiUser({
    required this.id,
    required this.userName,
    this.profileCompletionPercentage,
    this.email,
    this.jeevanaadiNo,
  });

  factory JeevanaadiUser.fromJson(Map<String, dynamic> json) {
    return JeevanaadiUser(
      id: json['id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      profileCompletionPercentage: json['profileCompletionPercentage'] != null 
          ? (json['profileCompletionPercentage'] as num).toDouble() 
          : null,
      jeevanaadiNo: json['jeevanaadiNo']?.toString(),
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'profileCompletionPercentage': profileCompletionPercentage,
      'jeevanaadiNo': jeevanaadiNo,
    };
  }
}
