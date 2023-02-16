// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_life_app/bloc/auth_cubit/auth_cubit.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/screens/accounts/login.dart';
import 'package:pinput/pinput.dart';

import '../../widgets/auth_widget.dart';

class VerifySMS extends StatefulWidget {
  const VerifySMS({Key? key}) : super(key: key);

  @override
  State<VerifySMS> createState() => _VerifySMSState();
}

class _VerifySMSState extends State<VerifySMS> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var code = '';
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
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
                    onChanged: (value) {
                      code = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          try {
                            // print(LoginScreen.verifyID);
                            // context.watch<AuthCubit>().verify(code, context);
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: LoginScreen.verifyID,
                                    smsCode: code);
                            await auth.signInWithCredential(credential);
                            Navigator.pushReplacementNamed(
                                context, '/home_screen');
                          } catch (e) {
                            print('Sai OTP');
                          }
                        },
                        child: const Text("Verify Phone Number")),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
