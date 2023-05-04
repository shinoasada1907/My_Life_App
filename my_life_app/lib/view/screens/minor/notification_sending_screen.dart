// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_life_app/models/imagesend.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/widgets/auth_widget.dart';

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
  ImageSeding imageSending;

  @override
  State<NotificationSendingScreen> createState() =>
      _NotificationSendingScreenState();
}

class _NotificationSendingScreenState extends State<NotificationSendingScreen> {
  TextEditingController? discriptionController;
  ImageSeding? imageSending;
  String latitude = '';
  String longitude = '';

  bool ischeck = false;

  @override
  void initState() {
    super.initState();
    discriptionController = TextEditingController();
    imageSending = widget.imageSending;
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
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              ischeck = !ischeck;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyle.mainColor,
                              textStyle: const TextStyle(fontSize: 11),
                              fixedSize: const Size(65, 30)),
                          child: const Text(
                            'Check',
                            textAlign: TextAlign.center,
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
              // Container(
              //   margin: const EdgeInsets.symmetric(vertical: 10),
              //   width: size.width * 0.9,
              //   height: size.height * 0.3,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       width: 1,
              //     ),
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: const Center(child: Text('Map')),
              // ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    final location = await _determinePosition();
                    print('''Location:
                    Latitude: ${location.latitude.toString()}
                    Longitude: ${location.longitude.toString()}''');
                    // Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.mainColor,
                    textStyle: const TextStyle(fontSize: 20),
                    fixedSize: Size(size.width * 0.3, size.height * 0.05),
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
