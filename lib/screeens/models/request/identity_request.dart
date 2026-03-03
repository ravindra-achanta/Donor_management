class IdentityRequest {
  final String name;
  final String email;
  final String mobileNumber;
  final List<int> roles;
  final String startedDate;
  final String pincode;
  final String city;
  final String area;
  final String state;
  final String country;

  IdentityRequest({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.roles,
    required this.startedDate,
    required this.pincode,
    required this.city,
    required this.area,
    required this.state,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'roles': roles,
      'startedDate': startedDate,
      'pincode': pincode,
      'city': city,
      'area': area,
      'state': state,
      'country': country,
    };
  }

  factory IdentityRequest.fromJson(Map<String, dynamic> json) {
    return IdentityRequest(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      roles: (json['roles'] as List<dynamic>).map((e) => e as int).toList(),
      startedDate: json['startedDate'] ?? '',
      pincode: json['pincode'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }
}