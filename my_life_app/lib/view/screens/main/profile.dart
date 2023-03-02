import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_app/models/style.dart';

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
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              pickImageFromGallery();
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black54, width: 2),
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
                          ),
                          Positioned(
                            right: 10,
                            bottom: 15,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                color: Colors.green[400],
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
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
