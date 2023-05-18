// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/widgets/notification_widget.dart';
import '../minor/information_notification.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({this.documentId, required this.processing, super.key});
  bool processing;
  final String? documentId;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> reflect = FirebaseFirestore.instance
        .collection('Reflect')
        .where('userid', isEqualTo: widget.documentId)
        .snapshots();
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
      body: StreamBuilder<QuerySnapshot>(
        stream: reflect,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có phản ánh',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InforNotification(
                            data: snapshot.data!.docs[index],
                            index: index,
                            documentId: FirebaseAuth.instance.currentUser!.uid),
                      ));
                },
                child: NotificationWidget(
                  notification: snapshot.data!.docs[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
