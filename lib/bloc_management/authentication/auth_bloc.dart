import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/api_services/network_repos/auth_repository.dart';
import 'package:vikas_app/screeens/models/enum/user_type.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthState()) {
    on<LoginEvent>(_onLogin);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<CreateUserEvent>(_onCreateUser);
    //on<FetchAllUsersEvent>(_onFetchAllUsers);
 on<FetchRolesEvent>(_onFetchRoles);
 on<ChangePasswordEvent>(_onChangePassword);
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: ''));

    final response = await authRepository.login(
      event.mobileNumber,
      event.password,
      event.roleName,

    );

    if (response.isSuccess) {
      final loginResponse = response.data!;
      
      // Check if password needs to be changed
      if (loginResponse.isPasswordChanged == false || loginResponse.isPasswordChanged == null) {
        // Store login data temporarily and emit password change required state
        emit(
          state.copyWith(
            status: AuthStatus.passwordChangeRequired,
            userId: loginResponse.id,
            token: loginResponse.token,
            userType: UserType.values.firstWhere(
              (type) => type.toString().split('.').last == loginResponse.userType,
              orElse: () => UserType.karyakartha,
            ),
            errorMessage: '',
          ),
        );
        // Note: Token will be saved after successful password change
      } else {
        // Normal login flow - save credentials and navigate
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            userId: loginResponse.id,
            token: loginResponse.token,
            userType: UserType.values.firstWhere(
              (type) => type.toString().split('.').last == loginResponse.userType,
              orElse: () => UserType.karyakartha,
            ),
            errorMessage: '',
          ),
        );
        print("saving token in login screen");
        print(state.token);
        print(state.userId);
        print(state.userId);
        await Vikasdb().setString("TOKEN", loginResponse.token);
        await Vikasdb().setString("USER_ID", loginResponse.id.toString());
        await Vikasdb().setUserType("USER_TYPE", loginResponse.userType.toString());
      }
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: response.error?.message ?? "Login failed",
        ),
      );
    }
  }

  Future<void> _onCreateUser(
    CreateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      status: AuthStatus.creatingUser,
      errorMessage: '',
      creationMessage: '',
    ));

    final response = await authRepository.createUser(
      event.request,
    );

    if (response.isSuccess) {
      final result = response.data!;
      emit(
        state.copyWith(
          status: AuthStatus.userCreated,
          creationMessage: result.message ?? "User created successfully",
          errorMessage: '',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: response.error?.message ?? "User creation failed",
          creationMessage: '',
        ),
      );
    }
  }


   Future<void> _onFetchRoles(
    FetchRolesEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoadingRoles: true));

    final response = await authRepository.getRoles();

    if (response.isSuccess) {
      emit(state.copyWith(
        roles: response.data!,
        isLoadingRoles: false,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: response.error?.message ?? "Failed to fetch roles",
        isLoadingRoles: false,
      ));
    }
  }
  

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.changingPassword, errorMessage: ''));

    // Debug prints to check state values
    print("DEBUG: Current state in _onChangePassword");
    print("DEBUG: token: ${state.token}");
    print("DEBUG: userId: ${state.userId}");
    print("DEBUG: userType: ${state.userType}");

    final response = await authRepository.changePassword(
      event.newPassword,
      event.mobileNumber,
    );

    if (response.isSuccess) {
      // Save token after successful password change
      // Use state values if available, otherwise they should already be set from login
      if (state.token != null && state.userId != null && state.userType != null) {
        print("saving token in change password screen");
        print(state.token);
        print(state.userId);
        print(state.userId);
        await Vikasdb().setString("TOKEN", state.token!);
        await Vikasdb().setString("USER_ID", state.userId!);
        await Vikasdb().setUserType("USER_TYPE", state.userType!.toString());
      } else {
        print("ERROR: Missing token, userId, or userType in state");
        print("token is null: ${state.token == null}");
        print("userId is null: ${state.userId == null}");
        print("userType is null: ${state.userType == null}");
        
        // As a fallback, try to get the values from the password change screen widget
        // This is a workaround - the real fix is using the global AuthBloc
        print("This should not happen if using global AuthBloc instance");
      }
      
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          errorMessage: '',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.passwordChangeRequired,
          errorMessage: response.error?.message ?? "Password change failed",
        ),
      );
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.checking));

    final isAuthenticated = await authRepository.isAuthenticated();
    
    if (isAuthenticated) {
      final authData = await authRepository.getStoredAuthData();
      
      UserType? userType; 
      if (authData['userType'] != null) {
        final typeString = authData['userType']!.replaceFirst('UserType.', '');
        userType = UserType.values.firstWhere(
          (e) => e.toString() == 'UserType.$typeString',
          orElse: () => UserType.karyakartha,
        );
      }

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          token: authData['token'],
          userId: authData['userId'],
          userType: userType,
          errorMessage: '',
        ),
      );
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }
}

