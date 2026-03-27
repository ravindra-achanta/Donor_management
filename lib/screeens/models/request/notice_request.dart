class NoticeRequest {
  final String? image;
  final String title;
  final String description;
  //final DateTime sendDate;
   final String sendDate;
   final String sendTime;
  
  final String sendTo;
  //final List<String>? specificUsers;
  final List<Map<String, String>>? specificUsers;

  NoticeRequest({
    this.image,
    required this.title,
    required this.description,
    required this.sendDate,
    required this.sendTime,
    required this.sendTo,
    this.specificUsers,
  });

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "title": title,
      "description": description,
      "sendDate": sendDate,
      "sendTime": sendTime,
      "sendTo": sendTo,
      "specificUsers": specificUsers ?? [],
    };
  }
}