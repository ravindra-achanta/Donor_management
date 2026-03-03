class NoticeResponse {
  final String id;
  final String title;
  final String message;
  final String audience;
  final String date;
  final String time;
  final String sender;
  final String? attachmentUrl;
  final DateTime createdAt;

  NoticeResponse({
    required this.id,
    required this.title,
    required this.message,
    required this.audience,
    required this.date,
    required this.time,
    required this.sender,
    this.attachmentUrl,
    required this.createdAt,
  });

  factory NoticeResponse.fromJson(Map<String, dynamic> json) {
    return NoticeResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      audience: json['audience'] ?? 'All Users',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      sender: json['sender'] ?? 'Admin',
      attachmentUrl: json['attachmentUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class PaginatedNotices {
  final List<NoticeResponse> content;
  final int totalElements;
  final int totalPages;
  final int currentPage;

  PaginatedNotices({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
  });

  factory PaginatedNotices.fromJson(Map<String, dynamic> json) {
    return PaginatedNotices(
      content: (json['content'] as List)
          .map((item) => NoticeResponse.fromJson(item))
          .toList(),
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }
}