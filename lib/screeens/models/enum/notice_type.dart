enum NoticeType {
  toAll('TO_ALL'),
  toSpecific('TO_SPECIFIC'),
  toAdmins('TO_ADMINS'),
  tosuperadmins('TO_SUPERADMINS'),
  toKaryakarthas('TO_KARYAKARTHAS'),
  toOfficeStaff('TO_OFFICESTAFF');

  final String value;

  const NoticeType(this.value);

  static NoticeType fromString(String value) {
    switch (value) {
      case 'TO_ALL':
        return NoticeType.toAll;
      case 'TO_SPECIFIC':
        return NoticeType.toSpecific;
      case 'TO_ADMINS':
        return NoticeType.toAdmins;
      case 'TO_SUPERADMINS':
        return NoticeType.tosuperadmins;
      case 'TO_KARYAKARTHAS':
        return NoticeType.toKaryakarthas;
      case 'TO_OFFICESTAFF':
        return NoticeType.toOfficeStaff;
      default:
        throw ArgumentError('Unknown NoticeType: $value');
    }
  }

  String get displayName {
    switch (this) {
      case NoticeType.toAll:
        return 'All';
      case NoticeType.toSpecific:
        return 'Specific';
      case NoticeType.toAdmins:
        return 'Admins';
      case NoticeType.tosuperadmins:
        return 'Super Admins';
      case NoticeType.toKaryakarthas:
        return 'Karyakartha';
      case NoticeType.toOfficeStaff:
        return 'Office Staff';
    }
  }

  String get toPath {
    return value;
  }
}