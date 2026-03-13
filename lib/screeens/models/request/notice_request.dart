class NoticeRequest {
  final String? image;
  final String title;
  final String description;
  final DateTime sendDate;
  final String sendTo;
  //final List<String>? specificUsers;
  final List<Map<String, String>>? specificUsers;

  NoticeRequest({
    this.image,
    required this.title,
    required this.description,
    required this.sendDate,
    required this.sendTo,
    this.specificUsers,
  });

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "title": title,
      "description": description,
      "sendDate": sendDate.toUtc().toIso8601String(),
      "sendTo": sendTo,
      "specificUsers": specificUsers ?? [],
    };
  }
}