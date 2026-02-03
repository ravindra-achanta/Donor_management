class User {
  final String id;
  final String name;
  final String uniqueId;
  final String email;
  final String? mobileNumber;
  final String? password;
  final String userType;
  final String status;
  final String? pincode;
  final String? city;
  final String? area;
  final String? state;
  final String? country;

  User({
    required this.id,
    required this.uniqueId,
    required this.name,
    required this.email,
    this.mobileNumber,
    this.password,
    required this.userType,
    required this.status,
    this.pincode,
    this.city,
    this.area,
    this.state,
    this.country,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      uniqueId:json['uniqueId'] ?? "",
      name: json['name'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      password: json['password'] ?? "",
      userType: json['userType'],
      status: json['status'],
      pincode: json['pincode'],
      city: json['city'],
      area: json['area'],
      state: json['state'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'uniqueId':uniqueId,
      'email': email,
      'mobileNumber': mobileNumber,
      'password': password,
      'userType': userType,
      'status': status,
      'pincode': pincode,
      'city': city,
      'area': area,
      'state': state,
      'country': country,
    };
  }
}
