// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:my_life_app/models/imagesend.dart';
import 'package:my_life_app/models/location.dart';
import 'package:my_life_app/models/reflect.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/widgets/auth_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class NotificationSendingScreen extends StatefulWidget {
  NotificationSendingScreen(
      {required this.documentId,
      required this.data,
      required this.image,
      required this.imageSending,
      super.key});
  String documentId;
  dynamic data;
  dynamic image;
  ImageSending imageSending;

  @override
  State<NotificationSendingScreen> createState() =>
      _NotificationSendingScreenState();
}

class _NotificationSendingScreenState extends State<NotificationSendingScreen> {
  TextEditingController? discriptionController;
  ImageSending? imageSending;
  String? imagePickedUrl;
  String? maskUrl;
  String? imagePicked;

  bool ischeck = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    discriptionController = TextEditingController();
    imageSending = widget.imageSending;
    imagePicked = widget.image;
  }

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

  //Upload Imge to firebase
  Future<void> uploadImage() async {
    final storageRef = firebase_storage.FirebaseStorage.instance
        .ref('mask/${path.basename(imageSending!.id)}');
    String dataUrl = 'data:text/plain;base64,${imageSending!.mask}';

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('image_seding/${path.basename(imagePicked!)}');
    try {
      //upload and getDownloadURL image sending
      await ref.putFile(File(imagePicked!)).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imagePickedUrl = value;
        });
      });

      //upload and getDownloadURL mask image
      await storageRef
          .putString(dataUrl, format: PutStringFormat.dataUrl)
          .whenComplete(() async {
        maskUrl = await storageRef.getDownloadURL();
      });
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  //Calculate distance from shooting position

  //Post reflect
  Future<void> reflectPost(Reflect reflect) async {
    CollectionReference reflects =
        FirebaseFirestore.instance.collection('Reflect');
    final postId = const Uuid().v4();
    try {
      await reflects.doc(postId).set({
        'id': postId,
        'userid': reflect.userId,
        'username': reflect.userName,
        'numberphone': reflect.numberPhone,
        'date': reflect.date,
        'description': reflect.description,
        'imagereflect': reflect.imageReflect,
        'maskimage': reflect.imageSending.mask,
        'percent': reflect.imageSending.percent,
        'status': reflect.imageSending.status,
        'latitude': reflect.location.latitude,
        'longitude': reflect.location.longitude,
        'Address':
            '${reflect.location.street}, ${reflect.location.ward}, ${reflect.location.district}, ${reflect.location.city}',
        'statusreflect': reflect.status,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //Post
  Future<void> post() async {
    setState(() {
      isLoading = true;
    });
    final location = await _determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];
    final locationAddress = LocationAddress(
      street: place.street.toString(),
      ward: '',
      district: place.subAdministrativeArea.toString(),
      city: place.administrativeArea.toString(),
      latitude: location.latitude.toString(),
      longitude: location.longitude.toString(),
    );
    await uploadImage();
    final reflect = Reflect(
      userId: FirebaseAuth.instance.currentUser!.uid,
      userName: widget.data['name'],
      numberPhone: widget.data['numberphone'],
      description: discriptionController!.text,
      imageReflect: imagePickedUrl.toString(),
      imageSending: imageSending!,
      location: locationAddress,
      date: DateFormat('dd/MM/yyy').format(DateTime.now()).toString(),
      status: StatusReflect.completed.toString(),
    );
    await reflectPost(reflect).whenComplete(() {
      AnimatedSnackBar.material('Phản ánh thành công',
              duration: const Duration(seconds: 2),
              mobileSnackBarPosition: MobileSnackBarPosition.top,
              type: AnimatedSnackBarType.success)
          .show(context);
      setState(() {
        isLoading = false;
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyle.bgColor,
        appBar: AppBar(
          backgroundColor: AppStyle.mainColor,
          title: const Text('Phản ánh'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: size.height * 0.3,
                      child: ischeck == true
                          ? Image.memory(
                              base64.decode(imageSending!.mask),
                            )
                          : Image(
                              image: FileImage(
                                File(widget.image),
                              ),
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          imageSending!.status,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Tỷ lệ: ${imageSending!.percent}%',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppStyle.mainColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                ischeck = !ischeck;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyle.mainColor,
                              textStyle: const TextStyle(fontSize: 11),
                              fixedSize: const Size(65, 20),
                              shape: const CircleBorder(),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Check',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.9,
                child: TextFormField(
                  initialValue: widget.data['name'],
                  readOnly: true,
                  decoration: textFormDecoration.copyWith(
                    labelText: 'Họ và tên',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.9,
                child: TextFormField(
                  initialValue: widget.data['numberphone'].toString(),
                  readOnly: true,
                  decoration: textFormDecoration.copyWith(
                    labelText: 'Số điện thoại',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.9,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập nội dung muốn phản ánh';
                    }
                    return null;
                  },
                  controller: discriptionController,
                  maxLines: 6,
                  decoration: textFormDecoration.copyWith(
                    labelText: 'Mô tả',
                    hintText: 'Điền mô tả phản ánh',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.3,
                height: size.height * 0.05,
                decoration: BoxDecoration(
                  color: AppStyle.mainColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          post();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyle.mainColor,
                          textStyle: const TextStyle(fontSize: 20),
                          fixedSize: Size(size.width * 0.3, size.height * 0.05),
                          shape: const CircleBorder(),
                        ),
                        child: const Text(
                          'Gửi',
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
