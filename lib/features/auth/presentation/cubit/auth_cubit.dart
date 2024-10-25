/*
Auth Cubit: State Management implementation
*/
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/domain/repository/auth_repo.dart';
import 'package:social_media_app/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  //check if user is already authenticated
  Future<void> checkAuth() async {
    final user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  //get current user
  AppUser? get currentUser => _currentUser;

  //login with email and password
  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (exception) {
      emit(AuthError(exception.toString()));
      emit(Unauthenticated());
    }
  }

  //register with email and password
  Future<void> register(
      {required String email,
      required String password,
      required String name}) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailAndPassword(
          email: email, password: password, name: name);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (exception) {
      emit(AuthError(exception.toString()));
      emit(Unauthenticated());
    }
  }

  //logout
  Future<void> logout() async {
    try {
      emit(AuthLoading());
      authRepo.logout();
      emit(Unauthenticated());
    } catch (exception) {
      emit(AuthError(exception.toString()));
    }
  }
}
