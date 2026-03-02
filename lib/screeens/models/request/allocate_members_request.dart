class AllocateMembersRequest {
  final List<String> membersList;

  AllocateMembersRequest({
    required this.membersList,
  });

  Map<String, dynamic> toJson() {
    return {
      'membersList': membersList,
    };
  }
}