part of 'auth.cubit.dart';



class AuthenticationState {
  const AuthenticationState();

}

abstract class ActionState extends AuthenticationState{

}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends ActionState {}

class AuthenticationFailure extends ActionState {
  final String message;

  AuthenticationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadingState extends AuthenticationState{

}

class StopLoadingState extends AuthenticationState{

}
