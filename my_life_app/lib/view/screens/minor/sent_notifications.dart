import 'package:flutter/material.dart';
import 'package:my_life_app/view/widgets/notification_widget.dart';

class SentNotification extends StatefulWidget {
  const SentNotification({super.key});

  @override
  State<SentNotification> createState() => _SentNotificationState();
}

class _SentNotificationState extends State<SentNotification> {
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
