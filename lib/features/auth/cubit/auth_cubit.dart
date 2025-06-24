import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    print('AuthCubit: Login started');
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(email, password);
      print('AuthCubit: Login successful, user: $user');
      emit(AuthAuthenticated(user));
    } catch (e) {
      print('AuthCubit: Login failed: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signup(String name, String email, String password) async {
    print('AuthCubit: Signup started');
    emit(AuthLoading());
    try {
      final user = await _authRepository.signup(name, email, password);
      print('AuthCubit: Signup successful, user: $user');
      emit(AuthAuthenticated(user));
    } catch (e) {
      print('AuthCubit: Signup failed: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    print('AuthCubit: Logout started');
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      print('AuthCubit: Logout successful');
      emit(AuthUnauthenticated());
    } catch (e) {
      print('AuthCubit: Logout failed: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> checkAuth() async {
    print('AuthCubit: CheckAuth started');
    emit(AuthLoading());
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      print('AuthCubit: isLoggedIn = $isLoggedIn');
      if (isLoggedIn) {
        final user = await _authRepository.getCurrentUser();
        print('AuthCubit: Current user = $user');
        if (user != null) {
          print('AuthCubit: Emitting AuthAuthenticated');
          emit(AuthAuthenticated(user));
        } else {
          print('AuthCubit: Emitting AuthUnauthenticated (user is null)');
          emit(AuthUnauthenticated());
        }
      } else {
        print('AuthCubit: Emitting AuthUnauthenticated (not logged in)');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print('AuthCubit: CheckAuth failed: $e');
      emit(AuthError(e.toString()));
    }
  }
} 