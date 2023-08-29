import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/features/auth/domain/repositories/user_repo.dart';
import 'package:pokedex/features/auth/presentation/pages/login.dart';
import 'package:pokedex/features/home/presentation/pages/home.dart';

import 'firebase_options.dart';
import 'injector_container.dart';

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF173EA5),
      ),
      home: FlutterSplashScreen.gif(
        backgroundColor: Colors.white,
        onInit: () async {
          var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
          Injector.setup();
        },
        gifHeight: 100,
        gifWidth: 100,
        gifPath: "assets/images/giphy.gif",
        defaultNextScreen: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserRepository _userRepo = Injector.get<UserRepository>();
    return _userRepo.isLoggedIn() ? const HomeScreen() : LoginScreen();
  }
}
