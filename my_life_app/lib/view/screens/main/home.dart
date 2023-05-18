// ignore_for_file: avoid_print, use_build_context_synchronously, unnecessary_string_interpolations
import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_app/models/inherited_widget.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/repository/service/flask_api_service.dart';
import 'package:my_life_app/view/screens/main/user.dart';
import 'package:my_life_app/view/screens/main/notification_mana.dart';
import 'package:my_life_app/view/screens/main/notification_screen.dart';
import 'package:my_life_app/view/screens/main/profile.dart';
import 'package:my_life_app/view/screens/minor/notification_sending_screen.dart';

import '../../../models/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectitem = 0;

  dynamic image;
  ImagePicker imagePicker = ImagePicker();
  dynamic pickedImageError;
  dynamic pickedImage;

  dynamic location;
  LocationAddress? locationAddress;

  final List<IconData> icons = [
    Icons.home,
    Icons.note_alt_sharp,
    Icons.notifications,
    Icons.person
  ];
  List screen = [
    UserScreen(
      documentId: FirebaseAuth.instance.currentUser!.uid,
    ),
    NotificationManaScreen(
      documentId: FirebaseAuth.instance.currentUser!.uid,
    ),
    NotificationScreen(
      processing: true,
      documentId: FirebaseAuth.instance.currentUser!.uid,
    ),
    ProfileScreen(
      documentId: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  Map<String, dynamic>? data;
  getdata() {
    try {
      FirebaseFirestore.instance
          .collection('Profile')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          data = documentSnapshot.data() as Map<String, dynamic>;
        } else {
          print('Document không tồn tại');
        }
      });
    } catch (e) {
      print(e.toString());
    }
    FirebaseFirestore.instance
        .collection('Profile')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        data = documentSnapshot.data() as Map<String, dynamic>;
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  //Get image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final pickedImage = await imagePicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 400,
          maxWidth: 400,
          imageQuality: 95);
      final file = File(pickedImage!.path);
      final imageFile = await file.readAsBytes();
      print(imageFile.runtimeType);
      setState(() {
        this.pickedImage = pickedImage;
        image = imageFile;
      });
    } catch (e) {
      pickedImageError = e;
      print(pickedImageError);
    }
  }

  Future<void> sending() async {
    await getLocation();
    final imageSending = await FlaskApi.sendImage(image);
    if (imageSending.status == 'Không vết nứt trên hình') {
      await AnimatedSnackBar.material(
        '${imageSending.status}',
        duration: const Duration(seconds: 2),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
        type: AnimatedSnackBarType.warning,
      ).show(context);
      print(imageSending.status);
    }
    if (imageSending.status == 'Có vết nứt trên hình') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationSendingScreen(
            documentId: FirebaseAuth.instance.currentUser!.uid,
            data: data,
            image: pickedImage!.path,
            imageSending: imageSending,
            location: locationAddress,
          ),
        ),
      );
    }
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

  Future<void> getLocation() async {
    location = await _determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    // print(placemarks);
    Placemark place = placemarks[1];
    locationAddress = LocationAddress(
      name: place.name.toString(),
      street: place.street.toString(),
      ward: '',
      district: place.subAdministrativeArea.toString(),
      city: place.administrativeArea.toString(),
      latitude: location.latitude.toString(),
      longitude: location.longitude.toString(),
    );
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
      data: data,
      child: Scaffold(
        backgroundColor: AppStyle.bgColor,
        body: screen[_selectitem],
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppStyle.mainColor,
          onPressed: () {
            pickImageFromCamera().whenComplete(() => sending());
          },
          child: const Icon(
            Icons.camera_alt,
            size: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          height: MediaQuery.of(context).size.height * 0.07,
          backgroundColor: AppStyle.mainColor,
          icons: icons,
          iconSize: 30,
          activeIndex: _selectitem,
          activeColor: AppStyle.bgColor,
          gapLocation: GapLocation.center,
          splashColor: Colors.white,
          notchSmoothness: NotchSmoothness.smoothEdge,
          onTap: (value) {
            setState(() {
              _selectitem = value;
            });
          },
        ),
      ),
    );
  }
}
