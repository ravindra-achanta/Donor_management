class Notice {
  final String id;
  final String title;
  final String message;
  final String audience;
  final String date;
  final String time;
  final String sender;
  final bool hasAttachment;
  final String? attachmentUrl;

  Notice({
    required this.id,
    required this.title,
    required this.message,
    required this.audience,
    required this.date,
    required this.time,
    required this.sender,
    this.hasAttachment = false,
    this.attachmentUrl,
  });
}