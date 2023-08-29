import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pokedex/features/auth/domain/repositories/user_repo.dart';
import 'package:pokedex/injector_container.dart';

part 'auth_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final UserRepository _auth = Injector.get<UserRepository>();

  AuthenticationCubit() : super(AuthenticationInitial());

  void login(String email, String password) async {
    try {
      emit(LoadingState());
      await _auth.logIn(email,password);
      emit(AuthenticationSuccess());
    } catch (e) {
      emit(StopLoadingState());
      emit(AuthenticationFailure(message: 'Login failed.'));
    }
  }

  void signup(String email, String password,String name) async {
    try {
      emit(LoadingState());
      await _auth.signUp(email,password,name);
      emit(AuthenticationSuccess());
    } catch (e) {
      emit(StopLoadingState());
      emit(AuthenticationFailure(message: 'Signup failed.'));
    }
  }
}
