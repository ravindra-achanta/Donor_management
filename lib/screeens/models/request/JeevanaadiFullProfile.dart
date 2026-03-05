class JeevanaadiFullProfile {
  final BasicDetails basicDetails;
  final ProfileDetails profileDetails;
  final List<RelationDetails> relationDetails;
  final OccupationDetails? occupationDetails;
  final JeevanaadiDemoGraphicDetails jeevanaadiDemoGraphicDetails;

  JeevanaadiFullProfile({
    required this.basicDetails,
    required this.profileDetails,
    required this.relationDetails,
    this.occupationDetails,
    required this.jeevanaadiDemoGraphicDetails,
  });

  factory JeevanaadiFullProfile.fromJson(Map<String, dynamic> json) {
    return JeevanaadiFullProfile(
      basicDetails: BasicDetails.fromJson(
        (() {
          final bd = json['basicDetails'];
          if (bd is Map<String, dynamic>) return bd;
          if (bd is List && bd.isNotEmpty && bd.first is Map<String, dynamic>) {
            return bd.first as Map<String, dynamic>;
          }
          return <String, dynamic>{};
        })(),
      ),
      profileDetails: ProfileDetails.fromJson(
        (() {
          final pd = json['profileDetails'];
          if (pd is Map<String, dynamic>) return pd;
          if (pd is List && pd.isNotEmpty && pd.first is Map<String, dynamic>) {
            return pd.first as Map<String, dynamic>;
          }
          return <String, dynamic>{};
        })(),
      ),
      relationDetails: (json['relationDetails'] as List<dynamic>?)
              ?.map((e) => RelationDetails.fromJson(e))
              .toList() ??
          [],
      occupationDetails: () {
        final occ = json['occupationDetails'];
        if (occ == null) return null;
        if (occ is Map<String, dynamic>) {
          return OccupationDetails.fromJson(occ);
        }
        if (occ is List && occ.isNotEmpty && occ.first is Map<String, dynamic>) {
          return OccupationDetails.fromJson(occ.first as Map<String, dynamic>);
        }
        return null;
      }(),
      jeevanaadiDemoGraphicDetails:
          JeevanaadiDemoGraphicDetails.fromJson(json['jeevanaadiDemoGraphicDetails'] ?? {}),
    );
  }
}

class BasicDetails {
  final String id;
  final String? lastLogin;
  final bool isSuperuser;
  final String email;
  final String username;
  final String? otp;
  final String? otpExpiresAt;
  final int role;
  final bool isActive;
  final bool isDeleted;
  final String createdDate;
  final String modifiedDate;
  final String createdBy;
  final String modifiedBy;
  final bool isStaff;
  final bool isAdmin;
  final String jeevanadiNo;
  final bool bulkUpload;
  final String usertype;

  BasicDetails({
    required this.id,
    this.lastLogin,
    required this.isSuperuser,
    required this.email,
    required this.username,
    this.otp,
    this.otpExpiresAt,
    required this.role,
    required this.isActive,
    required this.isDeleted,
    required this.createdDate,
    required this.modifiedDate,
    required this.createdBy,
    required this.modifiedBy,
    required this.isStaff,
    required this.isAdmin,
    required this.jeevanadiNo,
    required this.bulkUpload,
    required this.usertype,
  });

  factory BasicDetails.fromJson(Map<String, dynamic> json) {
    return BasicDetails(
      id: json['id']?.toString() ?? '',
      lastLogin: json['lastLogin'],
      isSuperuser: json['isSuperuser'] ?? false,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      otp: json['otp'],
      otpExpiresAt: json['otpExpiresAt'],
      role: json['role'] ?? 0,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdDate: json['createdDate'] ?? '',
      modifiedDate: json['modifiedDate'] ?? '',
      createdBy: json['createdBy'] ?? '',
      modifiedBy: json['modifiedBy'] ?? '',
      isStaff: json['isStaff'] ?? false,
      isAdmin: json['isAdmin'] ?? false,
      jeevanadiNo: json['jeevanadiNo'] ?? '',
      bulkUpload: json['bulkUpload'] ?? false,
      usertype: json['usertype'] ?? '',
    );
  }
}

class ProfileDetails {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String whatsappNumber;
  final String? dateOfBirth;
  final String gender;
  final String maritalStatus;
  final String profession;
  final String address;
  final String country;
  final String state;
  final String city;
  final String pincode;
  final String? annivDate;
  final String gothram;
  final String nakshatram;
  final int rashi;
  final double fillPercentage;
  final String communicationPref;
  final int? referredById;
  final int userId;
  final String joinedDate;
  final dynamic paadam;
  final dynamic panNumber;
  final String userType;
  final dynamic referredByCustom;

  ProfileDetails({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.whatsappNumber,
    this.dateOfBirth,
    required this.gender,
    required this.maritalStatus,
    required this.profession,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.pincode,
    this.annivDate,
    required this.gothram,
    required this.nakshatram,
    required this.rashi,
    //required this.fillPercentage,
    this.fillPercentage = 0.0,
    required this.communicationPref,
    this.referredById,
    required this.userId,
    required this.joinedDate,
    this.paadam,
    this.panNumber,
    required this.userType,
    this.referredByCustom,
  });

  factory ProfileDetails.fromJson(Map<String, dynamic> json) {
    return ProfileDetails(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      whatsappNumber: json['whatsappNumber'] ?? '',
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'] ?? '',
      maritalStatus: json['maritalStatus'] ?? '',
      profession: json['profession'] ?? '',
      address: json['address'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
      annivDate: json['annivDate'],
      gothram: json['gothram'] ?? '',
      nakshatram: json['nakshatram'] ?? '',
      rashi: json['rashi'] ?? 0,
      fillPercentage: json['fillPercentage']?.toDouble() ?? 0.0,
      communicationPref: json['communicationPref'] ?? '',
      referredById: json['referredById'] is int ? json['referredById'] : (int.tryParse(json['referredById']?.toString() ?? '') ?? null),
      userId: json['userId'] is int ? json['userId'] : (int.tryParse(json['userId']?.toString() ?? '') ?? 0),
      joinedDate: json['joinedDate']?.toString() ?? '',
      paadam: json['paadam'],
      panNumber: json['panNumber'],
      userType: json['userType'] ?? '',
      referredByCustom: json['referredByCustom'],
    );
  }
}

class RelationDetails {
  final int id;
  final String relation;
  final String name;
  final String? dob;
  final String? mobilenum;
  final int? userId;
  final String? nakshatramRel;
  final int? paadamRel;
  final int? rashiRel;

  RelationDetails({
    required this.id,
    required this.relation,
    required this.name,
    this.dob,
    this.mobilenum,
    this.userId,
    this.nakshatramRel,
    this.paadamRel,
    this.rashiRel,
  });

  factory RelationDetails.fromJson(Map<String, dynamic> json) {
    return RelationDetails(
      id: json['id'] ?? 0,
      relation: json['relation'] ?? '',
      name: json['name'] ?? '',
      dob: json['dob'],
      mobilenum: json['mobilenum'],
      userId: json['userId'],
      nakshatramRel: json['nakshatramRel'],
      paadamRel: json['paadamRel'],
      rashiRel: json['rashiRel'],
    );
  }
}

class OccupationDetails {
  final int id;
  final String occName;
  final String occDate;
  final int? userId;
  final String? nakshatram;
  final int? paadam;
  final int? rashi;

  OccupationDetails({
    required this.id,
    required this.occName,
    required this.occDate,
    this.userId,
    this.nakshatram,
    this.paadam,
    this.rashi,
  });

  factory OccupationDetails.fromJson(Map<String, dynamic> json) {
    return OccupationDetails(
      id: json['id'] ?? 0,
      occName: json['occName'] ?? '',
      occDate: json['occDate'] ?? '',
      userId: json['userId'],
      nakshatram: json['nakshatram'],
      paadam: json['paadam'],
      rashi: json['rashi'],
    );
  }
}

class JeevanaadiDemoGraphicDetails {
  final double profileCompletionPercentage;

  JeevanaadiDemoGraphicDetails({
    required this.profileCompletionPercentage,
  });

  factory JeevanaadiDemoGraphicDetails.fromJson(Map<String, dynamic> json) {
    return JeevanaadiDemoGraphicDetails(
      profileCompletionPercentage:
          //(json['profileCompletionPercentage'] as num?)?.toDouble() ?? 0.0,
          json['profileCompletionPercentage']?.toDouble() ?? 0.0,
    );
  }
}