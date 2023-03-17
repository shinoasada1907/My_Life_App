// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/screens/main/notification_screen.dart';
import 'package:my_life_app/view/screens/minor/information_screen.dart';
import 'package:my_life_app/view/screens/minor/setting_screen.dart';
import 'package:my_life_app/view/widgets/profile_widget.dart';

import '../../../bloc/profile_cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  final String documentId;
  const ProfileScreen({required this.documentId, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('Profile');
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  dynamic _pickedImageError;

  void pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      // ignore: avoid_print
      print(_pickedImageError);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Center(child: Text("Document does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: AppStyle.bgColor,
                appBar: AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Center(
                      child: Text(
                    data['name'],
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                  backgroundColor: AppStyle.mainColor,
                ),
                body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black54, width: 2),
                                borderRadius: BorderRadius.circular(90)),
                            child: imageFile != null
                                ? CircleAvatar(
                                    radius: 75,
                                    backgroundImage:
                                        FileImage(File(imageFile!.path)),
                                  )
                                : data['avatar'] == ''
                                    ? const CircleAvatar(
                                        radius: 75,
                                        backgroundImage: AssetImage(
                                            'assets/images/avatar.jpg'),
                                      )
                                    : CircleAvatar(
                                        radius: 75,
                                        backgroundImage: NetworkImage(
                                          data['avatar'],
                                        ),
                                      ),
                          ),
                          Text(
                            data['name'],
                            style: const TextStyle(
                              fontSize: 25,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProfileWidget(
                            icons: Icons.person,
                            title: 'Thông tin cá nhân',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const InformationScreen(),
                                  ));
                            },
                          ),
                          ProfileWidget(
                            icons: Icons.notifications,
                            title: 'Thông báo',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationScreen(
                                      processing: false,
                                    ),
                                  ));
                            },
                          ),
                          ProfileWidget(
                            icons: Icons.settings,
                            title: 'Cài đặt',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingScreen()));
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ProfileWidget(
                            icons: Icons.logout,
                            title: 'Đăng xuất',
                            onPressed: () {
                              FirebaseAuth.instance.signOut().whenComplete(
                                    () => Navigator.pushReplacementNamed(
                                        context, '/welcome_screen'),
                                  );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
