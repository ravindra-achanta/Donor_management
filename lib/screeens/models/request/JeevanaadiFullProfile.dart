class JeevanaadiFullProfile {
  final BasicDetails basicDetails;
  final ProfileDetails profileDetails;
  final List<RelationDetails> relationDetails;
  final OccupationDetails? occupationDetails;

  JeevanaadiFullProfile({
    required this.basicDetails,
    required this.profileDetails,
    required this.relationDetails,
    this.occupationDetails,
  });

  factory JeevanaadiFullProfile.fromJson(Map<String, dynamic> json) {
    return JeevanaadiFullProfile(
      basicDetails: BasicDetails.fromJson(json['basicDetails']),
      profileDetails: ProfileDetails.fromJson(json['profileDetails']),
      relationDetails: (json['relationDetails'] as List<dynamic>?)
              ?.map((e) => RelationDetails.fromJson(e))
              .toList() ??
          [],
      occupationDetails: json['occupationDetails'] != null
          ? OccupationDetails.fromJson(json['occupationDetails'])
          : null,
    );
  }
}

class BasicDetails {
  final int id;
  final String email;
  final String username;
  final bool isSuperuser;
  final bool isActive;
  final String jeevanadiNo;
  final bool bulkUpload;
  final String usertype;
  final int? role;
  final String? createdDate;
  final String? modifiedDate;

  BasicDetails({
    required this.id,
    required this.email,
    required this.username,
    required this.isSuperuser,
    required this.isActive,
    required this.jeevanadiNo,
    required this.bulkUpload,
    required this.usertype,
    this.role,
    this.createdDate,
    this.modifiedDate,
  });

  factory BasicDetails.fromJson(Map<String, dynamic> json) {
    return BasicDetails(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      isSuperuser: json['isSuperuser'] ?? false,
      isActive: json['isActive'] ?? false,
      jeevanadiNo: json['jeevanadiNo'] ?? '',
      bulkUpload: json['bulkUpload'] ?? false,
      usertype: json['usertype'] ?? '',
      role: json['role'],
      createdDate: json['createdDate'],
      modifiedDate: json['modifiedDate'],
    );
  }
}

class ProfileDetails {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String whatsappNumber;
  final String? gender;
  final String? maritalStatus;
  final String? profession;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? gothram;
  final String? nakshatram;
  final int? rashi;
  final int? paadam;
  final int fillPercentage;
  final String? communicationPref;
  final String? panNumber;
  final String userType;
  final String? joinedDate;
  final String? dateOfBirth;
  final String? annivDate;
  final int? referredById;
  final String? referredByCustom;

  ProfileDetails({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.whatsappNumber,
    this.gender,
    this.maritalStatus,
    this.profession,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.gothram,
    this.nakshatram,
    this.rashi,
    this.paadam,
    required this.fillPercentage,
    this.communicationPref,
    this.panNumber,
    required this.userType,
    this.joinedDate,
    this.dateOfBirth,
    this.annivDate,
    this.referredById,
    this.referredByCustom,
  });

  factory ProfileDetails.fromJson(Map<String, dynamic> json) {
    return ProfileDetails(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      whatsappNumber: json['whatsappNumber'] ?? '',
      gender: json['gender'],
      maritalStatus: json['maritalStatus'],
      profession: json['profession'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode'],
      gothram: json['gothram'],
      nakshatram: json['nakshatram'],
      rashi: json['rashi'],
      paadam: json['paadam'],
      fillPercentage: json['fillPercentage'] ?? 0,
      communicationPref: json['communicationPref'],
      panNumber: json['panNumber'],
      userType: json['userType'] ?? '',
      joinedDate: json['joinedDate'],
      dateOfBirth: json['dateOfBirth'],
      annivDate: json['annivDate'],
      referredById: json['referredById'],
      referredByCustom: json['referredByCustom'],
    );
  }
}

class RelationDetails {
  final int id;
  final String relation;
  final String name;
  final String? dob;
  final String? mobileNumber;
  final String? nakshatram;
  final int? rashi;
  final int? paadam;

  RelationDetails({
    required this.id,
    required this.relation,
    required this.name,
    this.dob,
    this.mobileNumber,
    this.nakshatram,
    this.rashi,
    this.paadam,
  });

  factory RelationDetails.fromJson(Map<String, dynamic> json) {
    return RelationDetails(
      id: json['id'] ?? 0,
      relation: json['relation'] ?? '',
      name: json['name'] ?? '',
      dob: json['dob'],
      mobileNumber: json['mobileNumber'],
      nakshatram: json['nakshatram'],
      rashi: json['rashi'],
      paadam: json['paadam'],
    );
  }
}

class OccupationDetails {
  final int id;
  final String occName;
  final String occDate;

  OccupationDetails({
    required this.id,
    required this.occName,
    required this.occDate,
  });

  factory OccupationDetails.fromJson(Map<String, dynamic> json) {
    return OccupationDetails(
      id: json['id'] ?? 0,
      occName: json['occName'] ?? '',
      occDate: json['occDate'] ?? '',
    );
  }
}