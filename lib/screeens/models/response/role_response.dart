import 'package:equatable/equatable.dart';

class Role extends Equatable {
  final String id;
  final String roleName;
  final String? createdTime;
  final String? updatedTime;
  final String? createdUserID;
  final String? updatedUserID;
  final String status;

  Role({
    required this.id,
    required this.roleName,
     this.createdTime,
     this.updatedTime,
    this.createdUserID,
    this.updatedUserID,
    required this.status,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id']?.toString() ?? '',
      roleName: json['roleName']?.toString() ?? '',
      createdTime: json['createdTime']?.toString() ?? '',
      updatedTime: json['updatedTime']?.toString() ?? '',
      createdUserID: json['createdUserID']?.toString(),
      updatedUserID: json['updatedUserID']?.toString(),
      status: json['status']?.toString() ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roleName': roleName,
      'createdTime': createdTime,
      'updatedTime': updatedTime,
      'createdUserID': createdUserID,
      'updatedUserID': updatedUserID,
      'status': status,
    };
  }

  int? get userTypeValue {
    switch (roleName) {
      case 'SUPER_ADMIN':
        return 0;
      case 'ADMIN':
        return 1;
      case 'KARYAKARTHA':
        return 2;
      case 'OFFICE_STAFF':
        return 3;
      case 'GURUJI':
        return 4;
      default:
        return null;
    }
  }

  String get displayName {
    switch (roleName) {
      case 'SUPER_ADMIN':
        return 'Super Admin';
      case 'ADMIN':
        return 'Admin';
      case 'KARYAKARTHA':
        return 'Karyakartha';
      case 'OFFICE_STAFF':
        return 'Office Staff';
      case 'GURUJI':
        return 'Guruji';
      default:
        return roleName.replaceAll('_', ' ');
    }
  }

  @override
  List<Object?> get props => [
        id,
        roleName,
        createdTime,
        updatedTime,
        createdUserID,
        updatedUserID,
        status,
      ];
}