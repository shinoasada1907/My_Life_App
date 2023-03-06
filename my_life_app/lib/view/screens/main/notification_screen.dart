import 'package:flutter/material.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/widgets/notification_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        itemCount: 10,
        itemBuilder: (context, index) {
          return const NotificationWidget();
        },
      ),
    );
  }
}
