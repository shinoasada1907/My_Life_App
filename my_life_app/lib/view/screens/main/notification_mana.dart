import 'package:flutter/material.dart';

class NotificationManaScreen extends StatefulWidget {
  const NotificationManaScreen({super.key});

  @override
  State<NotificationManaScreen> createState() => _NotificationManaScreenState();
}

class _NotificationManaScreenState extends State<NotificationManaScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Nootification Management screen'),
      ),
    );
  }
}
