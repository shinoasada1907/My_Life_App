import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth_cubit/auth_cubit.dart';
import '../../../models/style.dart';
import '../../widgets/auth_widget.dart';

class NumberPhone extends StatefulWidget {
  const NumberPhone({super.key});

  @override
  State<NumberPhone> createState() => _NumberPhoneState();
}

class _NumberPhoneState extends State<NumberPhone> {
  TextEditingController? numberphone;
  String? verifyID;
  String code = '';
  @override
  void initState() {
    super.initState();
    numberphone = TextEditingController();
    verifyID = '';
  }

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
                            context.read<AuthCubit>().loginOTPPhone(
                                context, numberphone!.text, false);
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
      },
    );
  }
}
