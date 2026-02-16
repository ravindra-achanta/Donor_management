class UnassignedUsersResponse {
  final List<UnassignedUser> content;
  final int totalPages;
  final int totalElements;
  final int currentPage;  // This will be 1-based from API

  UnassignedUsersResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.currentPage,
  });

  factory UnassignedUsersResponse.fromJson(Map<String, dynamic> json) {
    return UnassignedUsersResponse(
      content: (json['content'] as List? ?? [])
          .map((item) => UnassignedUser.fromJson(item))
          .toList(),
      totalPages: json['totalPages'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }
}

class UnassignedUser {
  final String userName;
  final String id;
  final String email;
  final double profileCompletionPercentage;
  final String jeevanaadiNo;

  UnassignedUser({
    required this.userName,
    required this.id,
    required this.email,
    required this.profileCompletionPercentage,
    required this.jeevanaadiNo,
  });

  factory UnassignedUser.fromJson(Map<String, dynamic> json) {
    return UnassignedUser(
      userName: json['userName'] ?? '',
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      profileCompletionPercentage: (json['profileCompletionPercentage'] as num?)?.toDouble() ?? 0.0,
      jeevanaadiNo: json['jeevanaadiNo'] ?? '',
    );
  }
}