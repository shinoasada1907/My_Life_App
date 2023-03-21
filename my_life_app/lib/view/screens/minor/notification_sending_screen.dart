// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/widgets/auth_widget.dart';

class NotificationSendingScreen extends StatefulWidget {
  NotificationSendingScreen(
      {required this.documentId,
      required this.data,
      required this.image,
      super.key});
  String documentId;
  dynamic data;
  dynamic image;

  @override
  State<NotificationSendingScreen> createState() =>
      _NotificationSendingScreenState();
}

class _NotificationSendingScreenState extends State<NotificationSendingScreen> {
  TextEditingController? discriptionController;

  @override
  void initState() {
    super.initState();
    discriptionController = TextEditingController();
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
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.85,
                  height: size.height * 0.3,
                  child: Image(image: FileImage(File(widget.image))),
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
                width: size.width * 0.9,
                height: size.height * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(child: Text('Map')),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyle.mainColor,
                        textStyle: const TextStyle(fontSize: 20),
                        fixedSize: Size(size.width * 0.3, size.height * 0.05)),
                    child: const Text(
                      'Gửi',
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
