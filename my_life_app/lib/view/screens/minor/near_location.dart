// ignore_for_file: avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final double earthRadius = 6371000; //bán kính trái đất (m)
  final double radius = 500; //bán kính mong muốn (m)

  double _toRadians(double degrees) {
    return (degrees * pi) / 180;
  }

  //Áp dụng công thức Haversine để tính khoản cách 2 tọa độ GPS
  bool isWithinRadius(lat1, lat2, lon1, lon2) {
    double dLat = _toRadians(lat2 - lat1); //Độ chênh lệch vĩ độ
    double dLon = _toRadians(lon2 - lon1); // Độ chênh lệch kinh độ
    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c; //Khoản cách 2 điểm (m)
    return distance <= radius;
  }

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
            listreflect.sort(
              (a, b) => DateFormat('dd/MM/yyy')
                  .parse(b.get('date'))
                  .compareTo(DateFormat('dd/MM/yyy').parse(a.get('date'))),
            );
            List<DocumentSnapshot> listreflect1 = [];
            for (var list in snapshot.data!.docs) {
              if (isWithinRadius(
                  double.parse(address!.latitude),
                  double.parse(list['latitude']),
                  double.parse(address!.longitude),
                  double.parse(list['longitude']))) {
                listreflect1.add(list);
              }
            }
            documents = listreflect1;
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
