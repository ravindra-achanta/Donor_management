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
 on<FetchRolesEvent>(_onFetchRoles);  }

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
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          userId: loginResponse.id,
          token: loginResponse.token,
          errorMessage: '',
        ),
      );
      await Vikasdb().setString("TOKEN", loginResponse.token);
      await Vikasdb().setString("USER_ID", loginResponse.id.toString());
      await Vikasdb().setUserType("USER_TYPE", loginResponse.userType.toString());
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

  // Future<void> _onFetchAllUsers(
  //   FetchAllUsersEvent event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(state.copyWith(
  //     status: AuthStatus.fetchingUsers,
  //     errorMessage: '',
  //   ));

  //   final response = await authRepository.getAllUsers(
  //     page: event.page,
  //     size: event.size,
  //   );

  //   if (response.isSuccess) {
  //     final result = response.data!;
  //     final newUsers = event.page == 0 
  //         ? result.content 
  //         : [...state.users, ...result.content];
      
  //     emit(
  //       state.copyWith(
  //         status: AuthStatus.usersFetched,
  //         users: newUsers,
  //         currentPage: event.page,
  //         totalPages: result.totalPages,
  //         hasMoreUsers: event.page < result.totalPages - 1,
  //         errorMessage: '',
  //       ),
  //     );
  //   } else {
  //     emit(
  //       state.copyWith(
  //         status: AuthStatus.error,
  //         errorMessage: response.error?.message ?? "Failed to fetch users",
  //       ),
  //     );
  //   }
  // }

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


// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
// import 'package:vikas_app/api_services/network_repos/auth_repository.dart';
// import 'package:vikas_app/screeens/models/enum/user_type.dart';
// import 'auth_event.dart';
// import 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthRepository authRepository;

//   AuthBloc({required this.authRepository}) : super(const AuthState()) {
//     on<LoginEvent>(_onLogin);
//     on<CheckAuthStatusEvent>(_onCheckAuthStatus);
//     on<CreateUserEvent>(_onCreateUser); // New handler
//     on<FetchAllUsersEvent>(_onFetchAllUsers); 
//   }

//   Future<void> _onLogin(
//     LoginEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading, errorMessage: ''));

//     final response = await authRepository.login(
//       event.mobileNumber,
//       event.password,
//       event.userType,
//     );

//     if (response.isSuccess) {
//       final loginResponse = response.data!;
//       emit(
//         state.copyWith(
//           status: AuthStatus.authenticated,
//           userId: loginResponse.id,
//           token: loginResponse.token,
//           userType: event.userType,
//           errorMessage: '',
//         ),
//       );
//       await Vikasdb().setString("TOKEN", loginResponse.token);
//         await Vikasdb().setString("USER_ID", loginResponse.id.toString());
//         await Vikasdb().setUserType("USER_TYPE", event.userType.toString());
//     } else {
//       emit(
//         state.copyWith(
//           status: AuthStatus.error,
//           errorMessage: response.error?.message ?? "Login failed",
//         ),
//       );
//     }
//   }

//    Future<void> _onCreateUser(
//     CreateUserEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(
//       status: AuthStatus.creatingUser,
//       errorMessage: '',
//       creationMessage: '',
//     ));

//     // Get token from state or storage
//     final token = state.token ?? await Vikasdb().getString("TOKEN");
    
//     if (token == null || token.isEmpty) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: "Authentication required. Please login first.",
//         creationMessage: '',
//       ));
//       return;
//     }

//     final response = await authRepository.createUser(
//       event.request,
//       token,
//     );

//     if (response.isSuccess) {
//       final result = response.data!;
//       emit(
//         state.copyWith(
//           status: AuthStatus.userCreated,
//           creationMessage: result.message ?? "User created successfully",
//           errorMessage: '',
//         ),
//       );


//       //3
//       Future<void> _onFetchAllUsers(
//     FetchAllUsersEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(
//       status: AuthStatus.fetchingUsers,
//       errorMessage: '',
//     ));

//     final token = state.token ?? await Vikasdb().getString("TOKEN");
    
//     if (token == null || token.isEmpty) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: "Authentication required. Please login first.",
//       ));
//       return;
//     }

//     final response = await authRepository.getAllUsers(
//       token: token,
//       page: event.page,
//       size: event.size,
//     );

//     if (response.isSuccess) {
//       final result = response.data!;
//       final newUsers = event.page == 0 
//           ? result.content 
//           : [...state.users, ...result.content];
      
//       emit(
//         state.copyWith(
//           status: AuthStatus.usersFetched,
//           users: newUsers,
//           currentPage: event.page,
//           totalPages: result.totalPages,
//           hasMoreUsers: event.page < result.totalPages - 1,
//           errorMessage: '',
//         ),
//       );
//     } else {
//       emit(
//         state.copyWith(
//           status: AuthStatus.error,
//           errorMessage: response.error?.message ?? "Failed to fetch users",
//         ),
//       );
//     }
//   }

      
      
//       /*
//       emit(
//         state.copyWith(
//           status: AuthStatus.authenticated,
//           userId: result.id,
//           token: result.token,
//           userType: result.userType,
//           creationMessage: result.message,
//           errorMessage: '',
//         ),
//       );
//       await Vikasdb().setString("TOKEN", result.token);
//       await Vikasdb().setString("USER_ID", result.id.toString());
//       await Vikasdb().setUserType("USER_TYPE", result.userType.toString());
//       */
//     } else {
//       emit(
//         state.copyWith(
//           status: AuthStatus.error,
//           errorMessage: response.error?.message ?? "User creation failed",
//           creationMessage: '',
//         ),
//       );
//     }
//   }


// Future<void> _onFetchAllUsers(
//     FetchAllUsersEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(
//       status: AuthStatus.fetchingUsers,
//       errorMessage: '',
//     ));

//     final token = state.token ?? await Vikasdb().getString("TOKEN");
    
//     if (token == null || token.isEmpty) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: "Authentication required. Please login first.",
//       ));
//       return;
//     }

//     final response = await authRepository.getAllUsers(
//       token: token,
//       page: event.page,
//       size: event.size,
//     );

//     if (response.isSuccess) {
//       final result = response.data!;
//       final newUsers = event.page == 0 
//           ? result.content 
//           : [...state.users, ...result.content];
      
//       emit(
//         state.copyWith(
//           status: AuthStatus.usersFetched,
//           users: newUsers,
//           currentPage: event.page,
//           totalPages: result.totalPages,
//           hasMoreUsers: event.page < result.totalPages - 1,
//           errorMessage: '',
//         ),
//       );
//     } else {
//       emit(
//         state.copyWith(
//           status: AuthStatus.error,
//           errorMessage: response.error?.message ?? "Failed to fetch users",
//         ),
//       );
//     }
//   }

//   Future<void> _onCheckAuthStatus(
//     CheckAuthStatusEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.checking));

//     final isAuthenticated = await authRepository.isAuthenticated();
    
//     if (isAuthenticated) {
//       final authData = await authRepository.getStoredAuthData();
      
//       UserType? userType;
//       if (authData['userType'] != null) {
//         final typeString = authData['userType']!.replaceFirst('UserType.', '');
//         userType = UserType.values.firstWhere(
//           (e) => e.toString() == 'UserType.$typeString',
//           orElse: () => UserType.karyakartha,
//         );
//       }

//       emit(
//         state.copyWith(
//           status: AuthStatus.authenticated,
//           token: authData['token'],
//           userId: authData['userId'],
//           userType: userType,
//           errorMessage: '',
//         ),
//       );
//     } else {
//       emit(state.copyWith(status: AuthStatus.unauthenticated));
//     }
//   }
// }