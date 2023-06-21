// ignore_for_file: must_be_immutable, avoid_print

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/style.dart';
import '../../widgets/auth_widget.dart';

class InforNotification extends StatefulWidget {
  InforNotification(
      {required this.data,
      required this.index,
      required this.documentId,
      super.key});
  String documentId;
  dynamic data;
  int index;

  @override
  State<InforNotification> createState() => _InforNotificationState();
}

class _InforNotificationState extends State<InforNotification> {
  CollectionReference reference =
      FirebaseFirestore.instance.collection('Reflect');
  String currentId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController? name, numphone, address, description;
  bool isLoading = false;
  bool isUpdate = false;
  bool isDelete = false;

  @override
  void initState() {
    super.initState();
    if (widget.data['statusreflect'] == 'Đã gửi') {
      setState(() {
        isLoading = true;
        isUpdate = false;
        isDelete = false;
      });
    }
    if (currentId != widget.data['userid']) {
      setState(() {
        isLoading = false;
      });
    }
    name = TextEditingController(text: widget.data['username']);
    numphone = TextEditingController(text: widget.data['numberphone']);
    address = TextEditingController(text: widget.data['address']);
    description = TextEditingController(text: widget.data['description']);
  }

  Future<void> updateData() async {
    setState(() {
      isUpdate = true;
    });
    await reference.doc(widget.data['id']).update({
      'date': DateFormat('dd/MM/yyy').format(DateTime.now()).toString(),
      'username': name!.text,
      'numberphone': numphone!.text,
      'address': address!.text,
      'description': description!.text,
    }).then((value) => print('update completed'));
  }

  Future<void> deleteData() async {
    setState(() {
      isDelete = true;
    });
    final ref =
        FirebaseStorage.instance.refFromURL(widget.data['imagereflect']);
    final refmask =
        FirebaseStorage.instance.refFromURL(widget.data['maskimage']);
    await ref.delete();
    await refmask.delete();
    await reference.doc(widget.data['id']).delete();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppStyle.mainColor,
          title: const Text('Thông tin phản ánh'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.85,
                  height: size.height * 0.3,
                  child: Image.network(
                    widget.data['imagereflect'],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 30,
                        bottom: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: (widget.data['statusreflect'] == 'Đã gửi')
                                ? Colors.green
                                : (widget.data['statusreflect'] ==
                                        'Đã tiếp nhận')
                                    ? Colors.red
                                    : Colors.blue,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(widget.data['statusreflect']),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 25),
                      child: Column(
                        children: [
                          Text('Đánh giá: ${widget.data['status']} '),
                          Text(
                              'Tỉ lệ so với khung hình: ${widget.data['percent']}%'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.9,
                child: TextFormField(
                  initialValue: widget.data['username'],
                  readOnly: true,
                  decoration:
                      textFormDecoration.copyWith(labelText: 'Họ và tên'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.9,
                child: TextFormField(
                  initialValue: widget.data['numberphone'],
                  readOnly: true,
                  decoration: textFormDecoration.copyWith(),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.9,
                child: TextFormField(
                  controller: address,
                  // initialValue: widget.data['address'],
                  readOnly: isLoading ? false : true,
                  decoration: textFormDecoration.copyWith(),
                  maxLines: 2,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.9,
                child: TextFormField(
                  controller: description,
                  readOnly: isLoading ? false : true,
                  // initialValue: widget.data['description'],
                  maxLines: 4,
                  decoration:
                      textFormDecoration.copyWith(labelText: 'Nội dung'),
                ),
              ),
              isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: size.width * 0.3,
                          height: size.height * 0.05,
                          decoration: BoxDecoration(
                            color: AppStyle.mainColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: isUpdate
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    updateData()
                                        .whenComplete(
                                          () => AnimatedSnackBar.material(
                                            'Cập nhật dữ liệu thành công',
                                            duration:
                                                const Duration(seconds: 3),
                                            type: AnimatedSnackBarType.success,
                                            mobileSnackBarPosition:
                                                MobileSnackBarPosition.top,
                                          ).show(context),
                                        )
                                        .whenComplete(
                                            () => Navigator.pop(context));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyle.mainColor,
                                    textStyle: const TextStyle(fontSize: 20),
                                    fixedSize: Size(
                                        size.width * 0.3, size.height * 0.05),
                                    shape: const CircleBorder(),
                                  ),
                                  child: const Text(
                                    'Cập nhật',
                                  ),
                                ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: size.width * 0.3,
                          height: size.height * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: isDelete
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    deleteData()
                                        .whenComplete(
                                          () => Navigator.pop(context),
                                        )
                                        .whenComplete(
                                          () => AnimatedSnackBar.material(
                                            'Xóa phản ánh thành công',
                                            duration:
                                                const Duration(seconds: 3),
                                            type: AnimatedSnackBarType.success,
                                            mobileSnackBarPosition:
                                                MobileSnackBarPosition.top,
                                          ).show(context),
                                        );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                    ),
                                    fixedSize: Size(
                                        size.width * 0.3, size.height * 0.05),
                                    shape: const CircleBorder(),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Xóa',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
