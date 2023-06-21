// ignore_for_file: use_build_context_synchronously, avoid_print, must_be_immutable, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/screens/accounts/signup.dart';
import 'package:pinput/pinput.dart';
import '../../widgets/auth_widget.dart';

class VerifySMS extends StatefulWidget {
  VerifySMS({this.processing, Key? key}) : super(key: key);
  bool? processing;
  static String? verifyID;
  String? smscode;

  @override
  State<VerifySMS> createState() => _VerifySMSState();
}

class _VerifySMSState extends State<VerifySMS> {
  TextEditingController? code;
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    code = TextEditingController(text: widget.smscode);
  }

  Future<void> verifyOTP(String code, String verifyID) async {
    setState(() {
      isLoading = true;
    });
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verifyID.toString(), smsCode: code.toString());
      await auth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> verify(
      String code, String verifyID, bool processing, String uid) async {
    try {
      await verifyOTP(code, verifyID).whenComplete(() {
        FirebaseFirestore.instance
            .collection('UserAccount')
            .doc(uid)
            .get()
            .then((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            Navigator.pushReplacementNamed(context, '/home_screen');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpScreen(
                  numberPhone: FirebaseAuth.instance.currentUser!.phoneNumber,
                ),
              ),
            );
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                controller: code,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          verify(
                              code!.text,
                              VerifySMS.verifyID!,
                              widget.processing!,
                              FirebaseAuth.instance.currentUser!.uid);
                          print(
                              'ID: ' + FirebaseAuth.instance.currentUser!.uid);
                        },
                        child: const Text("Verify Phone Number")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
