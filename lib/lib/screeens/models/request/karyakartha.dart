class Karyakartha {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String role;
  final String address;
  final String dob;
  final String status;

  Karyakartha({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.role,
    required this.address,
    required this.dob,
    required this.status,
  });

  bool get isActive => status == 'Active';

  Karyakartha copyWith({String? status}) {
    return Karyakartha(
      id: id,
      name: name,
      mobile: mobile,
      email: email,
      role: role,
      address: address,
      dob: dob,
      status: status ?? this.status,
    );
  }
}
