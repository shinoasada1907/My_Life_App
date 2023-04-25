// ignore_for_file: avoid_print, must_be_immutable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_life_app/view/screens/accounts/login.dart';
import 'package:my_life_app/view/screens/accounts/number_phone.dart';
import 'package:my_life_app/view/screens/accounts/signup.dart';
import 'package:my_life_app/view/screens/accounts/verify.dart';
import 'package:my_life_app/view/screens/accounts/welcome.dart';
import 'package:my_life_app/view/screens/main/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome_screen',
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/login_screen': (context) => const LoginScreen(),
        '/signup_screen': (context) => SignUpScreen(),
        '/verify_screen': (context) => VerifySMS(),
        '/home_screen': (context) => const HomeScreen(),
        '/number_phone_screen': (context) => const NumberPhone(),
      },
    );
  }
}
