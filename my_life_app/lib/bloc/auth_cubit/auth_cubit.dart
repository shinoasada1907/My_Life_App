// ignore_for_file: depend_on_referenced_packages, avoid_print, avoid_single_cascade_in_expression_statements

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_app/repository/auth/auth_repo.dart';
import 'package:my_life_app/view/screens/main/home.dart';

import '../../view/screens/accounts/login.dart';
import '../../view/screens/accounts/verify.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> upLoadImage() async {
    try {
      AuthRepository.upImage();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signUp(
      BuildContext context, String name, int id, int numberPhone) async {
    await loginOTPPhone(context, numberPhone).whenComplete(() => upLoadImage()
        .whenComplete(() => AuthRepository.signUp(name, id, numberPhone)));
  }

  setimage(XFile image) {
    AuthRepository.set(image);
  }

  Future<void> loginOTPPhone(BuildContext context, var phone) async {
    await AuthRepository.loginOTPPhone(context, phone)
        .whenComplete(() => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VerifySMS(),
            )));
  }

  Future<void> verify(var code, BuildContext context) async {
    await AuthRepository.verify(code)
        .whenComplete(() => Navigator.pushNamedAndRemoveUntil(
              context,
              '/home_screen',
              (route) => false,
            ));
  }
}
