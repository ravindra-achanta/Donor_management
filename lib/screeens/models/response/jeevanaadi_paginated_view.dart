import 'package:vikas_app/screeens/models/response/jeevanaadiView.dart';

class JeevanaadiPaginatedView {
  final int? totalElements;
  final int? totalPages;
  final List<JeevanaadiUser>? content;
  final int? currentPage;

  JeevanaadiPaginatedView({
    this.totalElements,
    this.totalPages,
    this.content,
    this.currentPage,
  });

  factory JeevanaadiPaginatedView.fromJson(Map<String, dynamic> json) {
    return JeevanaadiPaginatedView(
      totalElements: json['totalElements']?.toInt(),
      currentPage: json['currentPage']?.toInt(),
      totalPages: json['totalPages']?.toInt(),
      content: (json['content'] as List?)
          ?.map((x) => JeevanaadiUser.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'totalElements': totalElements,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'content': content,
    };
  }
}
