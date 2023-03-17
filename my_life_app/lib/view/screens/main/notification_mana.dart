import 'package:flutter/material.dart';
import 'package:my_life_app/models/style.dart';

import '../minor/approved_notifications.dart';
import '../minor/sent_notifications.dart';

class NotificationManaScreen extends StatefulWidget {
  const NotificationManaScreen({super.key});

  @override
  State<NotificationManaScreen> createState() => _NotificationManaScreenState();
}

class _NotificationManaScreenState extends State<NotificationManaScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppStyle.bgColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppStyle.mainColor,
          centerTitle: true,
          title: const Text('Quản lý'),
          bottom: const TabBar(
            isScrollable: true,
            indicatorWeight: 1.5,
            unselectedLabelColor: Colors.black87,
            tabs: [
              Tab(
                text: 'Đã gửi',
              ),
              Tab(
                text: 'Đã duyệt',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SentNotification(),
            ApprovedNotification(),
          ],
        ),
      ),
    );
  }
}
