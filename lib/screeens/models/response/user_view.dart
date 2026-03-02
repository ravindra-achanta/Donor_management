import 'package:equatable/equatable.dart';

class UserView extends Equatable {
  final String id;
  final String name;
  final String email;
  final String mobileNumber;
  final List<String> roles;
  final String status;
  final String? startedDate;
  final String? pincode;
  final String? city;
  final String? area;
  final String? state;
  final String? country;

  const UserView({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.roles,
    required this.status,
    this.startedDate,
    this.pincode,
    this.city,
    this.area,
    this.state,
    this.country,
  });

  factory UserView.fromJson(Map<String, dynamic> json) {
    return UserView(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      mobileNumber: json['mobileNumber'] as String,
      roles: List<String>.from(json['roles'] ?? []),
      status: json['status'] as String,
      startedDate: json['startedDate'] as String?,
      pincode: json['pincode'] as String?,
      city: json['city'] as String?,
      area: json['area'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'roles': roles,
      'status': status,
      'startedDate': startedDate,
      'pincode': pincode,
      'city': city,
      'area': area,
      'state': state,
      'country': country,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    mobileNumber,
    roles,
    status,
    startedDate,
    pincode,
    city,
    area,
    state,
    country,
  ];
}