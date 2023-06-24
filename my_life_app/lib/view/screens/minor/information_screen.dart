// ignore_for_file: avoid_print, must_be_immutable

import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/widgets/auth_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class InformationScreen extends StatefulWidget {
  InformationScreen({required this.data, super.key});
  dynamic data;

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  bool isLoading = false;
  XFile? image, image1;
  ImagePicker imagePicker = ImagePicker();
  dynamic pickedImageError;
  List<XFile>? imageFileList = [];
  List<String> imageUrlList = [];
  String? imageFileUrl;

  TextEditingController? name;
  TextEditingController? numberPhone;
  TextEditingController? cccd;

  final formkey = GlobalKey<FormState>();
  CollectionReference users = FirebaseFirestore.instance.collection('Profile');
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  dynamic _pickedImageError;
  Future<void> pickImageFromGallery() async {
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

      print(_pickedImageError);
    }
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

  Future<void> updateInformation() async {
    if (imageFile != null) {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('user_image/${path.basename(imageFile!.path)}');

      await ref.putFile(File(imageFile!.path)).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imageFileUrl = value;
        });
      });
    } else {
      imageFileUrl = widget.data['avatar'];
    }

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
      for (var imageUrl in widget.data['image']) {
        imageUrlList.add(imageUrl.toString());
      }
    }

    await users.doc(widget.data['id']).update({
      'name': name?.text,
      'cccd': cccd?.text,
      'numberphone': numberPhone?.text,
      'avatar': imageFileUrl ?? '',
      'image': imageUrlList,
    });
  }

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.data['name']);
    cccd = TextEditingController(text: widget.data['cccd']);
    numberPhone = TextEditingController(text: widget.data['numberphone']);
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
    imageFileList = [];
    imageFileList = [];
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
        appBar: AppBar(
          backgroundColor: AppStyle.mainColor,
          centerTitle: true,
          title: const Text('Thông tin cá nhân'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: pickImageFromGallery,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 2),
                            borderRadius: BorderRadius.circular(90)),
                        child: imageFile != null
                            ? CircleAvatar(
                                radius: 75,
                                backgroundImage:
                                    FileImage(File(imageFile!.path)),
                              )
                            : widget.data['avatar'] == ''
                                ? const CircleAvatar(
                                    radius: 75,
                                    backgroundImage:
                                        AssetImage('assets/images/avatar.jpg'),
                                  )
                                : CircleAvatar(
                                    radius: 75,
                                    backgroundImage: NetworkImage(
                                      widget.data['avatar'],
                                    ),
                                  ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      right: 12,
                      child: ClipOval(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.white,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: size.width * 0.7,
                      margin: EdgeInsets.only(top: size.height * 0.02),
                      child: TextFormField(
                        controller: name,
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
                        controller: cccd,
                        keyboardType: TextInputType.number,
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
                        controller: numberPhone,
                        keyboardType: TextInputType.phone,
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
                                ? (widget.data['image'].length == 0)
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
                                    : Image(
                                        image: NetworkImage(
                                          widget.data['image'][0],
                                        ),
                                      )
                                : Image(
                                    image: FileImage(
                                      File(
                                        image!.path,
                                      ),
                                    ),
                                  ),
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
                                ? (widget.data['image'].length == 0)
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
                                    : Image(
                                        image: NetworkImage(
                                          widget.data['image'][1],
                                        ),
                                      )
                                : Image(
                                    image: FileImage(
                                      File(
                                        image1!.path,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        updateInformation().whenComplete(() {
                          AnimatedSnackBar.material(
                            'Cập nhật thành công',
                            duration: const Duration(seconds: 3),
                            mobileSnackBarPosition: MobileSnackBarPosition.top,
                            type: AnimatedSnackBarType.success,
                          ).show(context);
                          print('Update completed');
                        });
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
                                  'Cập nhật',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
