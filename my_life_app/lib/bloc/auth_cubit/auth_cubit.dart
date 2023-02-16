// ignore_for_file: depend_on_referenced_packages, avoid_print, avoid_single_cascade_in_expression_statements

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_app/models/user.dart';
import 'package:my_life_app/repository/auth/auth_repo.dart';
import '../../view/screens/accounts/verify.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  int? phoneNumber;

  setphone(String phone) => UserApp.setphone(phone);
  getphone() => UserApp.getPhone();

  Future<void> upLoadImage(List<XFile?> imageFileList) async {
    try {
      AuthRepository.upImage(imageFileList);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signUp(BuildContext context, String name, int id,
      int numberPhone, List<XFile?> imageFileList, String userId) async {
    await upLoadImage(imageFileList)
        .whenComplete(
            () => AuthRepository.signUp(name, id, numberPhone, userId))
        .whenComplete(
            () => Navigator.pushReplacementNamed(context, '/home_screen'));
  }

  setimage(XFile image) {
    AuthRepository.set(image);
  }

  Future<void> loginOTPPhone(BuildContext context, var phone) async {
    await AuthRepository.loginOTPPhone(context, phone)
        .whenComplete(() => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifySMS(
                processing: false,
              ),
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
