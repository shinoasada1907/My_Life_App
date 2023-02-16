// ignore_for_file: non_constant_identifier_names, prefer_function_declarations_over_variables, avoid_print
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:my_life_app/models/user.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import '../../view/screens/accounts/login.dart';

class AuthRepository {
  static FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  UserApp? userApp;
  static CollectionReference data =
      FirebaseFirestore.instance.collection('UserAccount');

  static ImagePicker imagePicker = ImagePicker();
  static List<XFile>? imageFileList = [];
  static List<String> imageUrlList = [];
  static XFile? imageFile;
  static dynamic pickedImageError;
  static late String uid;

  static void set(XFile image) {
    imageFileList!.add(image);
  }

  static List<XFile?> getimage() {
    return imageFileList!;
  }

  static Future<void> pickImageFromCamera() async {
    try {
      final pickedImage = await imagePicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      imageFileList!.add(pickedImage!);
    } catch (e) {
      pickedImageError = e;
      print(pickedImageError);
    }
  }

  static Future<void> signUp(String name, int id, int numberPhone,String userId) async {
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
        LoginScreen.verifyID = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static Future<void> verify(var code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: LoginScreen.verifyID, smsCode: code);
    await auth.signInWithCredential(credential);
  }
}
