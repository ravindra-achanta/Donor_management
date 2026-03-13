class UpdateNoticeRequest {
  final String? image;
  final String title;
  final String description;
  final String status; // or enum

  UpdateNoticeRequest({this.image, required this.title, required this.description, required this.status});

  Map<String, dynamic> toJson() => {
    'image': image,
    'title': title,
    'description': description,
    'status': status,
  };
}