import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  UserEntity({
    this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });

}
