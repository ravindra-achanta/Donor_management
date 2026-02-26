// lib/screeens/models/request/dharmasetu_model.dart

class DharmasetuModel {
  final String id;
  final String uid;
  final String type;
  final String name;
  final String feedback;
  final String date;
  final String referredBy;
  final String status;
  
  final String? phone;
  final String? communityName;
  final String? communityLocation;
  final String? communityOwner;
  final String? homeOwner;
  final String? homeAddress;

  DharmasetuModel({
    required this.id,
    required this.uid,
    required this.type,
    required this.name,
    required this.feedback,
    required this.date,
    required this.referredBy,
    required this.status,
    this.phone,
    this.communityName,
    this.communityLocation,
    this.communityOwner,
    this.homeOwner,
    this.homeAddress,
  });
}