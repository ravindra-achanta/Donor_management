import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/enum/user_type.dart';

enum AuthStatus {
  initial,     
  checking,   
  loading,    
  authenticated, 
  unauthenticated, 
  error,       
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? userId;
  final String? token;
  final UserType? userType;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userId,
    this.token,
    this.userType,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? token,
    UserType? userType,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      userType: userType ?? this.userType,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userId,
    token,
    userType,
    errorMessage,
  ];

  // Helper methods
  bool get isChecking => status == AuthStatus.checking;
  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isError => status == AuthStatus.error;
}