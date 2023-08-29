import 'package:pokedex/features/auth/domain/entities/user.entity.dart';

abstract class UserRepository {
  Future<void> signUp(String email, String password,String name);
  Future<void> logIn(String email, String password);
  bool isLoggedIn();
  Future<void> logOut();
  UserEntity get getUser;
}