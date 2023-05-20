// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_life_app/models/inherited_widget.dart';
import 'package:my_life_app/view/screens/minor/information_notification.dart';
import '../../../../models/location.dart';
import '../../widgets/notification_widget.dart';

class NearLocationUser extends StatefulWidget {
  final String documentId;
  const NearLocationUser({required this.documentId, super.key});

  @override
  State<NearLocationUser> createState() => _NearLocationUserState();
}

class _NearLocationUserState extends State<NearLocationUser> {
  List<DocumentSnapshot> documents = [];
  LocationAddress? address;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    address = MyInheritedWidget.of(context).location;
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> reflect = FirebaseFirestore.instance
        .collection('Reflect')
        .where('statusreflect', isEqualTo: 'Đã gửi')
        .snapshots();
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          reflect = FirebaseFirestore.instance
              .collection('Reflect')
              .where('userid', isEqualTo: widget.documentId)
              .where('statusreflect', isEqualTo: 'Đã gửi')
              .snapshots();
        });
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: reflect,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> listreflect = snapshot.data!.docs
                .where(
                    (element) => element['address'].contains(address!.street))
                .toList();
            documents = listreflect;
          }

          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (documents.isEmpty) {
            return const Center(
              child: Text(
                'Không có phản ánh ở khu vực này',
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
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InforNotification(
                            data: documents[index],
                            index: index,
                            documentId: FirebaseAuth.instance.currentUser!.uid),
                      ));
                },
                child: NotificationWidget(
                  notification: documents[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
