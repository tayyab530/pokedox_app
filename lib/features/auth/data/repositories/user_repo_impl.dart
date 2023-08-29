import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedex/features/auth/data/models/user.model.dart';
import 'package:pokedex/features/auth/domain/entities/user.entity.dart';

import '../../domain/repositories/user_repo.dart';

class FirebaseAuthRepository implements UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> signUp(String email, String password,String name) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _auth.currentUser!.updateDisplayName(name);
  }

  @override
  Future<void> logIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  bool isLoggedIn() {
    final user = _auth.currentUser;
    return user != null;
  }

  @override
  Future<void> logOut() async {
    await _auth.signOut();
  }

  @override
  UserEntity get getUser => UserModel.fromFirebaseUser(_auth.currentUser!);
}
