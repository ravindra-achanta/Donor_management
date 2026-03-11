import 'package:vikas_app/screeens/models/response/donations.dart';

class JeevanaadiDonationView {
  final int? totalElements;
  final int? totalPages;
  final List<DonationEvent>? content;
  final int? currentPage;

  JeevanaadiDonationView({
    this.totalElements,
    this.totalPages,
    this.content,
    this.currentPage,
  });

  factory JeevanaadiDonationView.fromJson(Map<String, dynamic> json) {
    return JeevanaadiDonationView(
      totalElements: json['totalElements']?.toInt(),
      currentPage: json['currentPage']?.toInt(),
      totalPages: json['totalPages']?.toInt(),
      content: (json['content'] as List?)
          ?.map((x) => DonationEvent.fromJson(x as Map<String, dynamic>))
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
