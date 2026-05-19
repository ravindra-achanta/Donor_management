class DepartmentRequest {
  final String? departmentName;
  final String? description;

  DepartmentRequest({
    this.departmentName,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'departmentName': departmentName,
    'description': description,
  };

  factory DepartmentRequest.fromJson(Map<String, dynamic> json) =>
      DepartmentRequest(
        departmentName: json['departmentName'],
        description: json['description'],
      );
}