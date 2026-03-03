import 'package:equatable/equatable.dart';
import 'user_view.dart';

class UsersResponse extends Equatable {
  final List<UserView> content;
  final int totalPages;
  final int totalElements;
  final int size;
  final int number;
  final bool first;
  final bool last;
  final int numberOfElements;

  const UsersResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.size,
    required this.number,
    required this.first,
    required this.last,
    required this.numberOfElements,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      content: (json['content'] as List)
          .map((e) => UserView.fromJson(e))
          .toList(),
      totalPages: json['totalPages'] as int,
      totalElements: json['totalElements'] as int,
      size: json['size'] as int,
      number: json['number'] as int,
      first: json['first'] as bool,
      last: json['last'] as bool,
      numberOfElements: json['numberOfElements'] as int,
    );
  }

  @override
  List<Object?> get props => [
    content,
    totalPages,
    totalElements,
    size,
    number,
    first,
    last,
    numberOfElements,
  ];
}