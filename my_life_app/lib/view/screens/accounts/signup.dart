// ignore_for_file: avoid_print, must_be_immutable

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_app/bloc/auth_cubit/auth_cubit.dart';
import '../../../models/style.dart';
import '../../widgets/auth_widget.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({this.numberPhone, super.key});
  String? numberPhone = '';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  XFile? image, image1;
  ImagePicker imagePicker = ImagePicker();
  dynamic pickedImageError;
  List<XFile>? imageFileList = [];

  TextEditingController? name;
  TextEditingController? numberPhone;
  TextEditingController? cccd;

  final formkey = GlobalKey<FormState>();

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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
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
                            '????ng k?? t??i kho???n',
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
                      height: size.height * 0.8,
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
                                  return 'Xin nh???p h??? t??n';
                                }
                                return null;
                              },
                              decoration: textFormDecoration.copyWith(
                                labelText: 'H??? v?? T??n',
                                hintText: 'Nh???p H??? v?? T??n',
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
                                  return 'Xin h??y nh???p s??? c??n c?????c c??ng d??n ho???c s??? ch???ng minh th??';
                                }
                                return null;
                              },
                              decoration: textFormDecoration.copyWith(
                                labelText: 'S??? CCCD/CMND',
                                hintText: 'Nh???p s??? CCCD/CMND',
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
                                  return 'Xin nh???p s??? ??i???n tho???i c?? nh??n';
                                } else if (value.length != 10) {
                                  return 'S??? ??i???n tho???i ph???i ?????m b???o 10 ch??? s???';
                                } else if (value.isValidPhoneNumber() ==
                                    false) {
                                  return 'Xin nh???p l???i s??? ??i???n tho???i';
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
                                            'Ch???p m???t tr?????c c???a CCCD/CMND',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Image(
                                          image: FileImage(File(image!.path))),
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
                                            'Ch???p m???t sau c???a CCCD/CMND',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Image(
                                          image: FileImage(File(image1!.path))),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<AuthCubit>()
                                  .signUp(
                                      context,
                                      name!.text,
                                      int.parse(cccd!.text),
                                      int.parse(numberPhone!.text),
                                      imageFileList!.toList(),
                                      FirebaseAuth.instance.currentUser!.uid)
                                  .whenComplete(() {
                                setState(() {
                                  name!.dispose();
                                  cccd!.dispose();
                                  numberPhone!.dispose();
                                  image = null;
                                  image1 = null;
                                });
                              });
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
                              child: const Center(
                                child: Text(
                                  '????ng k??',
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
      },
    );
  }
}
