// ignore_for_file: avoid_print, must_be_immutable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_app/models/location.dart';
import '../../../../models/style.dart';
import '../../widgets/auth_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class SignUpScreen extends StatefulWidget {
  SignUpScreen({this.numberPhone, super.key});
  String? numberPhone = '';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  XFile? image, image1;
  ImagePicker imagePicker = ImagePicker();
  dynamic pickedImageError;
  LocationAddress? address;
  List<XFile>? imageFileList = [];
  List<String> imageUrlList = [];

  TextEditingController? name;
  TextEditingController? numberPhone;
  TextEditingController? cccd;

  final formkey = GlobalKey<FormState>();

  CollectionReference data =
      FirebaseFirestore.instance.collection('UserAccount');
  CollectionReference profile =
      FirebaseFirestore.instance.collection('Profile');

  //Get location device
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getLocation() async {
    final location = await _determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    print(placemarks);
    Placemark place = placemarks[2];
    print(place.toJson());
    address = LocationAddress(
      name: place.name.toString(),
      street: place.thoroughfare.toString(),
      ward: '',
      district: place.subAdministrativeArea.toString(),
      city: place.administrativeArea.toString(),
      latitude: location.latitude.toString(),
      longitude: location.longitude.toString(),
    );
  }

  //Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final pickedImage = await imagePicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      image == null
          ? setState(() {
              image = pickedImage;
              imageFileList!.add(image!);
            })
          : setState(() {
              image1 = pickedImage;
              imageFileList!.add(image1!);
            });
    } catch (e) {
      pickedImageError = e;
      print(pickedImageError);
    }
  }

  //Upload image to firebase storage
  Future<void> upLoadImage() async {
    try {
      if (imageFileList!.isNotEmpty) {
        for (var images in imageFileList!) {
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('user_image/${path.basename(images.path)}');

          await ref.putFile(File(images.path)).whenComplete(() async {
            await ref.getDownloadURL().then((value) {
              imageUrlList.add(value);
            });
          });
        }
      } else {
        print('Mảng rỗng');
      }
      // AuthRepository.upImage(imageFileList!);
    } catch (e) {
      print(e.toString());
    }
  }

  //SignUp account on firebase
  Future<void> signUp(String name, String id, String numberPhone, String userId,
      var imageUrlList) async {
    await data.doc(userId).set({
      'id': userId,
      'name': name,
      'numberphone': numberPhone,
      'uid': userId,
    });
    await profile.doc(userId).set({
      'avatar': '',
      'id': userId,
      'name': name,
      'cccd': id,
      'numberphone': numberPhone,
      'image': imageUrlList ?? '',
      'uid': userId,
    });
  }

  //SignUp Account
  Future<void> signUpAccount(
      String name, String id, String numberPhone, String userId) async {
    await upLoadImage()
        .whenComplete(() => signUp(name, id, numberPhone, userId, imageUrlList))
        .whenComplete(
            () => Navigator.pushReplacementNamed(context, '/home_screen'));
  }

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    cccd = TextEditingController();
    numberPhone = TextEditingController(text: widget.numberPhone);
    setState(() {
      image = null;
      image1 = null;
    });
    imageFileList = [];
    imageUrlList = [];
    isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    name!.dispose();
    cccd!.dispose();
    numberPhone!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Form(
      key: formkey,
      child: Scaffold(
        backgroundColor: AppStyle.mainColor,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      top: size.height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Đăng ký tài khoản',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/welcome_screen');
                        },
                        icon: const Icon(
                          Icons.home,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.02),
                  width: size.width * 0.8,
                  height: size.height * 0.83,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 7,
                        blurRadius: 7,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: size.width * 0.7,
                        margin: EdgeInsets.only(top: size.height * 0.02),
                        child: TextFormField(
                          controller: name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Xin nhập họ tên';
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Họ và Tên',
                            hintText: 'Nhập Họ và Tên',
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.7,
                        margin: EdgeInsets.only(top: size.height * 0.02),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: cccd,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Xin hãy nhập số căn cước công dân hoặc số chứng minh thư';
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Số CCCD/CMND',
                            hintText: 'Nhập số CCCD/CMND',
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.7,
                        margin: EdgeInsets.only(top: size.height * 0.02),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          // initialValue: numberPhone!.text,
                          controller: numberPhone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Xin nhập số điện thoại cá nhân';
                            } else if (value.length != 10) {
                              return 'Số điện thoại phải đảm bảo 10 chữ số';
                            } else if (value.isValidPhoneNumber() == false) {
                              return 'Xin nhập lại số điện thoại';
                            } else if (value.isValidPhoneNumber() == true) {
                              return null;
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.02),
                        child: GestureDetector(
                          onTap: () {
                            pickImageFromCamera();
                          },
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(20),
                            child: SizedBox(
                              width: size.width * 0.7,
                              height: size.width * 0.4,
                              child: image == null
                                  ? const Center(
                                      child: Text(
                                        'Chụp mặt trước của CCCD/CMND',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : Image(image: FileImage(File(image!.path))),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.02),
                        child: GestureDetector(
                          onTap: () {
                            pickImageFromCamera();
                          },
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(20),
                            child: SizedBox(
                              width: size.width * 0.7,
                              height: size.width * 0.4,
                              child: image1 == null
                                  ? const Center(
                                      child: Text(
                                        'Chụp mặt sau của CCCD/CMND',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : Image(image: FileImage(File(image1!.path))),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await getLocation().whenComplete(
                            () {
                              signUpAccount(
                                name!.text,
                                cccd!.text,
                                numberPhone!.text,
                                FirebaseAuth.instance.currentUser!.uid,
                              ).whenComplete(() {
                                setState(() {
                                  name!.dispose();
                                  cccd!.dispose();
                                  numberPhone!.dispose();
                                  image = null;
                                  image1 = null;
                                  isLoading = false;
                                });
                              });
                            },
                          );

                          print(imageFileList.toString());
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: size.height * 0.02),
                          width: size.width * 0.7,
                          height: size.height * 0.07,
                          decoration: BoxDecoration(
                            color: AppStyle.mainColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Đăng ký',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
