// lib/screeens/models/response/dharmasetu_view.dart

class DharmasetuView {
  final String id;
  final String uid;
  final String type;
  final String name;
  final String feedback;
  final String date;
  final String referredBy;
  final String status;

  DharmasetuView({
    required this.id,
    required this.uid,
    required this.type,
    required this.name,
    required this.feedback,
    required this.date,
    required this.referredBy,
    required this.status,
  });

  // Factory method to convert from DharmasetuModel
  factory DharmasetuView.fromDharmasetuModel(dynamic model) {
    return DharmasetuView(
      id: model.id,
      uid: model.uid,
      type: model.type,
      name: model.name,
      feedback: model.feedback,
      date: model.date,
      referredBy: model.referredBy,
      status: model.status,
    );
  }
}