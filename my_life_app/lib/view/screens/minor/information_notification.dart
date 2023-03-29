// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_life_app/models/notification.dart';

import '../../../models/style.dart';
import '../../widgets/auth_widget.dart';

class InforNotification extends StatelessWidget {
  InforNotification(
      {required this.data,
      required this.index,
      required this.documentId,
      super.key});
  String documentId;
  dynamic data;
  int index;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppStyle.mainColor,
          title: const Text('Thông tin phản ánh'),
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
                  child: Image.asset(notifiList[index].url!),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.9,
                child: TextFormField(
                  initialValue: data['name'],
                  readOnly: true,
                  decoration:
                      textFormDecoration.copyWith(labelText: 'Họ và tên'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.9,
                child: TextFormField(
                  initialValue: data['numberphone'].toString(),
                  readOnly: true,
                  decoration: textFormDecoration.copyWith(),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.9,
                child: TextFormField(
                  readOnly: true,
                  initialValue: notifiList[index].comment,
                  maxLines: 6,
                  decoration: textFormDecoration.copyWith(),
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
                child: Center(child: Text(notifiList[index].location!)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
