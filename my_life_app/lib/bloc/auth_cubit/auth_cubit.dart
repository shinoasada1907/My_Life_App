// ignore_for_file: depend_on_referenced_packages, avoid_print, avoid_single_cascade_in_expression_statements

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_app/repository/auth/auth_repo.dart';
import 'package:my_life_app/view/screens/accounts/signup.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../view/screens/accounts/verify.dart';
import 'package:path/path.dart' as path;

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  int? phoneNumber;
  List<String> imageUrlList = [];

  Future<void> upLoadImage(List<XFile?> imageFileList) async {
    try {
      if (imageFileList.isNotEmpty) {
        for (var images in imageFileList) {
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('user_image/${path.basename(images!.path)}');

          await ref.putFile(File(images.path)).whenComplete(() async {
            await ref.getDownloadURL().then((value) {
              imageUrlList.add(value);
            });
          });
        }
      } else {
        print('Mảng rỗng');
      }
      AuthRepository.upImage(imageFileList);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signUp(BuildContext context, String name, int id,
      int numberPhone, List<XFile?> imageFileList, String userId) async {
    await upLoadImage(imageFileList)
        .whenComplete(() =>
            AuthRepository.signUp(name, id, numberPhone, userId, imageUrlList))
        .whenComplete(
            () => Navigator.pushReplacementNamed(context, '/home_screen'));
  }

  Future<void> loginOTPPhone(
      BuildContext context, var phone, bool processing) async {
    await AuthRepository.loginOTPPhone(context, phone)
        .whenComplete(() => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifySMS(
                processing: processing,
              ),
            )));
  }

  Future<void> verify(var code, BuildContext context, String verifyID,
      bool processing, String uid) async {
    try {
      await AuthRepository.verify(code, verifyID).whenComplete(() {
        FirebaseFirestore.instance
            .collection('UserAccount')
            .doc(uid)
            .get()
            .then((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            Navigator.pushReplacementNamed(context, '/home_screen');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpScreen(
                  numberPhone: FirebaseAuth.instance.currentUser!.phoneNumber,
                ),
              ),
            );
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }

    // try {
    //   await AuthRepository.verify(code, verifyID)
    //       .whenComplete(() => processing == true
    //           ? Navigator.pushReplacementNamed(context, '/home_screen')
    //           : Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => SignUpScreen(
    //                   numberPhone:
    //                       FirebaseAuth.instance.currentUser!.phoneNumber,
    //                 ),
    //               ),
    //             ));
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    await AuthRepository.signInWithGoogle().whenComplete(() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        )));
  }

  // Future<bool> checkNumberPhone(String numberPhone) async {
  //   await FirebaseFirestore.instance
  //       .collection('UserAccount')
  //       .where('numberphone', isEqualTo: numberPhone)
  //       .get()
  //       .then((value) {
  //     if (value.docs.isNotEmpty) {
  //       return true;
  //     } else
  //       return false;
  //   });
  // }
}
