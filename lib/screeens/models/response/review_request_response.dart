import 'package:vikas_app/screeens/models/response/review_request.dart';

class ReviewRequestResponse {
  final List<ReviewRequest> content;
  final int totalPages;
  final int totalElements;
  final int currentPage;

  ReviewRequestResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.currentPage,
  });

  factory ReviewRequestResponse.fromJson(Map<String, dynamic> json) {
    var list = json['content'] as List? ?? [];
    List<ReviewRequest> contentList = list
        .map((i) => ReviewRequest.fromJson(i))
        .toList();

    return ReviewRequestResponse(
      content: contentList,
      totalPages: json['totalPages'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }
}