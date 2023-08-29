import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedex/features/auth/domain/entities/user.entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String? uid,
    required String? email,
    required String? displayName,
    required String? photoURL,
  }) : super(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
  );

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }
}
