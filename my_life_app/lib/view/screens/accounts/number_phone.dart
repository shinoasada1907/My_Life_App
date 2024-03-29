// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_life_app/view/screens/accounts/signup.dart';
import 'package:my_life_app/view/screens/accounts/verify.dart';
import 'package:toast/toast.dart';
import '../../../../models/style.dart';
import '../../widgets/auth_widget.dart';

class NumberPhone extends StatefulWidget {
  const NumberPhone({super.key});

  @override
  State<NumberPhone> createState() => _NumberPhoneState();
}

class _NumberPhoneState extends State<NumberPhone> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController? numberphone;
  String? verifyID;
  String code = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    numberphone = TextEditingController();
    verifyID = '';
    isLoading = false;
  }

  //Login with number phone
  Future<void> loginOTPPhone(String phone, bool processing) async {
    setState(() {
      isLoading = false;
    });
    try {
      await FirebaseAuth.instance
          .verifyPhoneNumber(
        phoneNumber: '+84${phone.toString()}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          print('Complete');
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          VerifySMS.verifyID = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      )
          .whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpScreen(
              numberPhone: FirebaseAuth.instance.currentUser!.phoneNumber,
            ),
          ),
        );
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => VerifySMS(
        //         processing: processing,
        //       ),
        //     ));
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: size.width * 0.1,
                    right: size.width * 0.1,
                    top: size.height * 0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Đăng ký',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/welcome_screen');
                      },
                      icon: const Icon(
                        Icons.home,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.08),
                width: size.width * 0.8,
                height: size.height * 0.40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 7,
                      blurRadius: 7,
                      offset: const Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.7,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: numberphone,
                        decoration: textFormDecoration.copyWith(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (numberphone!.text != '') {
                          setState(() {
                            isLoading = true;
                          });
                          loginOTPPhone(numberphone!.text, false);
                          // context.read<AuthCubit>().loginOTPPhone(
                          //     context, numberphone!.text, false);
                        } else {
                          Toast.show('Xin hãy nhập số điện thoại!',
                              duration: Toast.lengthShort,
                              backgroundColor: Colors.grey,
                              gravity: Toast.bottom);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: size.height * 0.015),
                        width: size.width * 0.7,
                        height: size.height * 0.07,
                        decoration: BoxDecoration(
                          color: AppStyle.mainColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
