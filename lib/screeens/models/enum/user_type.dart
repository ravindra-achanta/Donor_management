enum UserType {
  guruji('GURUJI'),
  superAdmin('SUPER_ADMIN'),
  admin('ADMIN'),
  karyakartha('KARYAKARTHA'),
  officeStaff('OFFICE_STAFF');

  final String value;

  const UserType(this.value);

  static UserType fromString(String value) {
    switch (value) {
      case 'GURUJI':
        return UserType.guruji;
      case 'SUPER_ADMIN':
        return UserType.superAdmin;
      case 'ADMIN':
        return UserType.admin;
      case 'KARYAKARTHA':
        return UserType.karyakartha;
      case 'OFFICE_STAFF':
        return UserType.officeStaff;
      default:
        throw ArgumentError('Unknown UserType: $value');
    }
  }

  String get displayName {
    switch (this) {
      case UserType.guruji:
        return 'Guruji';
      case UserType.superAdmin:
        return 'Super Admin';
      case UserType.admin:
        return 'Admin';
      case UserType.karyakartha:
        return 'Karyakartha';
      case UserType.officeStaff:
        return 'Office Staff';
    }
  }

  String get toPath {
    return value;
  }
}