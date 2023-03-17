import 'package:flutter/material.dart';
import 'package:my_life_app/view/widgets/notification_widget.dart';

class ApprovedNotification extends StatefulWidget {
  const ApprovedNotification({super.key});

  @override
  State<ApprovedNotification> createState() => _ApprovedNotificationState();
}

class _ApprovedNotificationState extends State<ApprovedNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const NotificationWidget();
        },
      ),
    );
  }
}
