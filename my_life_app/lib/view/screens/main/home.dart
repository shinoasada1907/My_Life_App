// ignore_for_file: avoid_print, use_build_context_synchronously, unnecessary_string_interpolations
import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_app/models/inherited_widget.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/repository/service/flask_api_service.dart';
import 'package:my_life_app/view/screens/main/notification_mana.dart';
import 'package:my_life_app/view/screens/main/notification_screen.dart';
import 'package:my_life_app/view/screens/main/profile.dart';
import 'package:my_life_app/view/screens/main/user.dart';
import 'package:my_life_app/view/widgets/confirm_dialog.dart';
import '../../../../models/location.dart';
import '../minor/notification_sending_screen.dart';

class HomeScreen extends StatefulWidget {
  final LocationAddress? location;
  const HomeScreen({this.location, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectitem = 0;

  dynamic image;
  ImagePicker imagePicker = ImagePicker();
  dynamic pickedImageError;
  dynamic pickedImage;

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
          print('Document data: ${documentSnapshot.data()}');
        } else {
          print('Document không tồn tại');
        }
      });
    } catch (e) {
      print(e.toString());
    }
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
    // await getLocation();
    final imageSending = await FlaskApi.sendImage(image);
    if (imageSending.status == 'Không vết nứt trên hình') {
      await AnimatedSnackBar.material(
        '${imageSending.status}',
        duration: const Duration(seconds: 4),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
        type: AnimatedSnackBarType.warning,
      ).show(context).whenComplete(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationSendingScreen(
                  documentId: FirebaseAuth.instance.currentUser!.uid,
                  data: data,
                  image: pickedImage!.path,
                  imageSending: imageSending,
                  location: widget.location,
                ),
              ),
            ),
          );
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
            location: widget.location,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
    print(widget.location!.name);
    print(widget.location!.street);
  }

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
      location: widget.location,
      data: data,
      child: Scaffold(
        backgroundColor: AppStyle.bgColor,
        body: screen[_selectitem],
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppStyle.mainColor,
          onPressed: () {
            ConfirmDialogWidget.showDialog(
              context: context,
              message:
                  'Yêu cầu đối tượng được chụp là các cơ sở hạ tầng bị hư hại.',
              onTapCancle: () => Navigator.pop(context),
              onTapConfirm: () {
                pickImageFromCamera().whenComplete(() {
                  if (image != null) {
                    print('Picked image');
                    sending();
                  } else {
                    print('Exit camera');
                    Navigator.pop(context);
                  }
                });
                Navigator.pop(context);
              },
              title: 'Cảnh báo',
            );
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
