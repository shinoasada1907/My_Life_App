// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_life_app/models/notification.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/widgets/notification_widget.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({required this.processing, super.key});
  bool processing;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.processing ? false : true,
        backgroundColor: AppStyle.mainColor,
        title: const Text('Thông báo'),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                'Đánh dấu đọc tất cả',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      backgroundColor: AppStyle.bgColor,
      body: ListView.builder(
        itemCount: notifiList.length,
        itemBuilder: (context, index) {
          return NotificationWidget(
            index: index,
            date: notifiList[index].date!,
            location: notifiList[index].location!,
            status: notifiList[index].status!,
            url: notifiList[index].url!,
            comment: notifiList[index].comment,
          );
        },
      ),
    );
  }
}
