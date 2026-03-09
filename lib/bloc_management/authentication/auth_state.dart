import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/enum/user_type.dart';
import 'package:vikas_app/screeens/models/response/role_response.dart';
import 'package:vikas_app/screeens/models/response/user_view.dart';

enum AuthStatus {
  initial,
  checking,
  loading,
  authenticated,
  unauthenticated,
  error,
  creatingUser,
  userCreated,
  fetchingUsers,
  usersFetched,
  changingPassword,
  passwordChanged,
  passwordChangeRequired,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? userId;
  final String? token;
  final UserType? userType;
  final String? errorMessage;
  final List<UserView> users;
  final int currentPage;
  final int totalPages;
  final bool hasMoreUsers;
  final String? creationMessage;
  final List<Role> roles;
  final List<Role> typeBasedRoles;
  final bool isLoadingRoles;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userId,
    this.token,
    this.userType,
    this.errorMessage,
    this.users = const [],
    this.currentPage = 0,
    this.totalPages = 0,

    this.hasMoreUsers = false,
    this.creationMessage,
    this.roles = const [],
    this.typeBasedRoles = const [],
    this.isLoadingRoles = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? token,
    UserType? userType,
    String? errorMessage,
    List<UserView>? users,
    int? currentPage,
    int? totalPages,
    bool? hasMoreUsers,
    String? creationMessage,
    List<Role>? roles,
    List<Role>? typeBasedRoles,
    bool? isLoadingRoles,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      userType: userType ?? this.userType,
      errorMessage: errorMessage ?? this.errorMessage,
      users: users ?? this.users,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMoreUsers: hasMoreUsers ?? this.hasMoreUsers,
      creationMessage: creationMessage ?? this.creationMessage,
      roles: roles ?? this.roles,
      typeBasedRoles: typeBasedRoles ?? this.typeBasedRoles,
      isLoadingRoles: isLoadingRoles ?? this.isLoadingRoles,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userId,
    token,
    userType,
    errorMessage,
    users,
    currentPage,
    typeBasedRoles,
    totalPages,
    hasMoreUsers,
    creationMessage,
    roles,
    isLoadingRoles,
  ];

  // Helper methods
  bool get isChecking => status == AuthStatus.checking;
  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isError => status == AuthStatus.error;
  bool get isCreatingUser => status == AuthStatus.creatingUser;
  bool get isUserCreated => status == AuthStatus.userCreated;
  bool get isFetchingUsers => status == AuthStatus.fetchingUsers;
  bool get areUsersFetched => status == AuthStatus.usersFetched;
  bool get isChangingPassword => status == AuthStatus.changingPassword;
  bool get isPasswordChanged => status == AuthStatus.passwordChanged;
  bool get isPasswordChangeRequired =>
      status == AuthStatus.passwordChangeRequired;
  // bool get isFetchingUsers => status == AuthStatus.fetchingUsers;
  // bool get areUsersFetched => status == AuthStatus.usersFetched;
}
