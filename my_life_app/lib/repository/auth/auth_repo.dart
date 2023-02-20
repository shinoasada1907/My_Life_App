// ignore_for_file: non_constant_identifier_names, prefer_function_declarations_over_variables, avoid_print
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:my_life_app/models/user.dart';
import 'package:my_life_app/view/screens/accounts/verify.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class AuthRepository {
  static FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  UserApp? userApp;
  static CollectionReference data =
      FirebaseFirestore.instance.collection('UserAccount');

  static ImagePicker imagePicker = ImagePicker();
  static List<String> imageUrlList = [];
  static XFile? imageFile;
  static dynamic pickedImageError;
  static late String uid;

  static Future<void> signUp(String name, int id, int numberPhone,
      String userId, var imageUrlList) async {
    uid = const Uuid().v4();
    await data.doc(uid).set({
      'id': uid,
      'name': name,
      'cccd': id,
      'numberphone': numberPhone,
      'image': imageUrlList,
      'uid': userId,
    });
  }

  static Future<void> upImage(List<XFile?> imageFileList) async {
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
  }

  static Future<void> loginOTPPhone(BuildContext context, var phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+84${phone.toString()}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        VerifySMS.verifyID = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static Future<void> verify(var code, var verifyID) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verifyID.toString(), smsCode: code.toString());
    await auth.signInWithCredential(credential);
  }

  Future<void> resendVerificationCode(
      String phoneNumber, String verificationId) async {
    // Yêu cầu Firebase gửi lại mã OTP mới
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    };
    PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
      print('Failed to automatically verify phone number: ${e.message}');
    };
    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) {};
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print(
          'Timeout for automatic SMS code retrieval expired: $verificationId');
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
