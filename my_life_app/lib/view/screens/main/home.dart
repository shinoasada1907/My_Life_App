// ignore_for_file: avoid_print

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/screens/main/news_screen.dart';
import 'package:my_life_app/view/screens/main/notification_mana.dart';
import 'package:my_life_app/view/screens/main/notification_screen.dart';
import 'package:my_life_app/view/screens/main/profile.dart';
import 'package:my_life_app/view/screens/minor/notification_sending_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectitem = 0;

  XFile? image;
  ImagePicker imagePicker = ImagePicker();
  dynamic pickedImageError;

  final List<IconData> icons = [
    Icons.home,
    Icons.note_alt_sharp,
    Icons.notifications,
    Icons.person
  ];
  List screen = [
    const NewsScreen(),
    const NotificationManaScreen(),
    NotificationScreen(
      processing: true,
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

  Future<void> pickImageFromCamera() async {
    try {
      final pickedImage = await imagePicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        image = pickedImage;
      });
    } catch (e) {
      pickedImageError = e;
      print(pickedImageError);
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bgColor,
      body: screen[_selectitem],
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.mainColor,
        onPressed: () {
          pickImageFromCamera().whenComplete(() => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotificationSendingScreen(
                        documentId: FirebaseAuth.instance.currentUser!.uid,
                        data: data,
                        image: image!.path,
                      ))));
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
    );
  }
}
