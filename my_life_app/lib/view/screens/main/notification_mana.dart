import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/mobile/widgets/notification_widget.dart';

import '../minor/information_notification.dart';

class NotificationManaScreen extends StatefulWidget {
  final String documentId;
  const NotificationManaScreen({required this.documentId, super.key});

  @override
  State<NotificationManaScreen> createState() => _NotificationManaScreenState();
}

class _NotificationManaScreenState extends State<NotificationManaScreen> {
  String dropdownValue = 'Mới nhất';
  List<String> options = ['Mới nhất', 'Đã gửi', 'Đã tiếp nhận', 'Đã xử lý'];
  bool isDropdownValue = false;
  List<DocumentSnapshot> documents = [];

  List<DocumentSnapshot> listreflect = [];

  @override
  void initState() {
    super.initState();
  }

  void filterList() {
    if (isDropdownValue) {
      setState(() {
        documents = listreflect
            .where((element) =>
                element['statusreflect'].toString() == dropdownValue ||
                dropdownValue == 'Mới nhất')
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> reflect = FirebaseFirestore.instance
        .collection('Reflect')
        .where('userid', isEqualTo: widget.documentId)
        .snapshots();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppStyle.bgColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppStyle.mainColor,
          centerTitle: true,
          title: const Text('Quản lý'),
          toolbarHeight: 55,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: DropdownButton(
                borderRadius: BorderRadius.circular(15),
                dropdownColor: AppStyle.mainColor,
                icon: const Icon(
                  Icons.filter_alt_rounded,
                  color: Colors.white,
                  size: 25,
                ),
                value: dropdownValue,
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    final previousValue = dropdownValue;
                    dropdownValue = value!;
                    isDropdownValue = dropdownValue != previousValue;
                    filterList();
                  });
                },
              ),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: reflect,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              listreflect = snapshot.data!.docs;
              listreflect.sort(
                (a, b) => DateFormat('dd/MM/yyy')
                    .parse(b.get('date'))
                    .compareTo(DateFormat('dd/MM/yyy').parse(a.get('date'))),
              );
              if (dropdownValue == 'Mới nhất') {
                documents = listreflect;
              }
            }

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
                              documentId:
                                  FirebaseAuth.instance.currentUser!.uid),
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
      ),
    );
  }
}
