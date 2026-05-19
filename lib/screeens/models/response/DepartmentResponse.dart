import 'package:equatable/equatable.dart';

class DepartmentResponse extends Equatable {
  final String? id; 
  final String? departmentName;
  final String? description;
  final String? status; 

  const DepartmentResponse({
    this.id,
    this.departmentName,
    this.description,
    this.status,
  });

  factory DepartmentResponse.fromJson(Map<String, dynamic> json) =>
      DepartmentResponse(
        id: json['id'],
        departmentName: json['departmentName'],
        description: json['description'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'departmentName': departmentName,
    'description': description,
    'status': status,
  };

  @override
  List<Object?> get props => [id, departmentName, description, status];
}