import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_life_app/models/inherited_widget.dart';
import 'package:my_life_app/models/notification.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/screens/minor/information_notification.dart';
import 'package:my_life_app/view/widgets/notification_widget.dart';

class NotificationManaScreen extends StatefulWidget {
  const NotificationManaScreen({super.key});

  @override
  State<NotificationManaScreen> createState() => _NotificationManaScreenState();
}

class _NotificationManaScreenState extends State<NotificationManaScreen> {
  String dropdownValue = 'Mới nhất';
  List<String> options = ['Mới nhất', 'Đã gửi', 'Đang xử lý', 'Đã xử lý'];
  bool isDropdownValue = false;

  List<NotificationModel> notificationList = [];

  @override
  void initState() {
    super.initState();
    notifiList.sort(
      (a, b) => b.date!.compareTo(a.date!),
    );
    notificationList = notifiList;
  }

  void filterList() {
    if (isDropdownValue) {
      notificationList = notifiList
          .where((element) =>
              element.status == dropdownValue || dropdownValue == 'Mới nhất')
          .toList();
    } else {
      notificationList = List.from(notifiList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = MyInheritedWidget.of(context).data;
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
        body: ListView.builder(
          itemCount: notificationList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InforNotification(
                          data: data,
                          index: index,
                          documentId: FirebaseAuth.instance.currentUser!.uid),
                    ));
              },
              child: NotificationWidget(
                index: index,
                url: notificationList[index].url!,
                date: notificationList[index].date!,
                location: notificationList[index].location!,
                status: notificationList[index].status!,
              ),
            );
          },
        ),
      ),
    );
  }
}
