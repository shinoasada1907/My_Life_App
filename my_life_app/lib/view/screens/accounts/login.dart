import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_life_app/bloc/auth_cubit/auth_cubit.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/screens/accounts/verify.dart';
import 'package:my_life_app/view/widgets/auth_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String verifyID = '';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var phone = '';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
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
                          'Đăng nhập',
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
                      children: [
                        Container(
                          width: size.width * 0.7,
                          margin: EdgeInsets.only(top: size.height * 0.07),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            validator: (value) {},
                            onChanged: (value) {
                              phone = value;
                            },
                            decoration: textFormDecoration.copyWith(),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: '+84${phone.toString()}',
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {},
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                LoginScreen.verifyID = verificationId;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const VerifySMS(),
                                    ));
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                            // context
                            //     .read<AuthCubit>()
                            //     .loginOTPPhone(context, phone);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: size.height * 0.01),
                            width: size.width * 0.7,
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                              color: AppStyle.mainColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Center(
                              child: Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'Hoặc',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/signup_screen');
                          },
                          child: Container(
                            width: size.width * 0.7,
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                width: 2,
                                color: AppStyle.mainColor,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Google',
                                style: TextStyle(
                                  color: AppStyle.mainColor,
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
      },
    );
  }
}
