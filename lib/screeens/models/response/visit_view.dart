// lib/screeens/models/response/visit_view.dart

class VisitView {
  final String id;
  final String jeevandNum;
  final String name;
  final String phone;
  final String email;
  final String visitPurpose;
  final int noOfGuests;
  final String date;
  final String status;

  VisitView({
    required this.id,
    required this.jeevandNum,
    required this.name,
    required this.phone,
    required this.email,
    required this.visitPurpose,
    required this.noOfGuests,
    required this.date,
    required this.status,
  });

  // Factory method to convert from VisitModel
  factory VisitView.fromVisitModel(dynamic model) {
    return VisitView(
      id: model.id,
      jeevandNum: model.jeevandNum,
      name: model.name,
      phone: model.phone,
      email: model.email,
      visitPurpose: model.visitPurpose,
      noOfGuests: model.noOfGuests,
      date: model.date,
      status: model.status,
    );
  }
}