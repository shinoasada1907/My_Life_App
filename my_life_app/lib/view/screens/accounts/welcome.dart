import 'package:flutter/material.dart';
import 'package:my_life_app/models/style.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoading = false;
  void loginScreen() {
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppStyle.bgColor,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: size.height * 0.5,
                decoration: BoxDecoration(
                  color: AppStyle.mainColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: size.width * 0.7,
            left: size.height * 0.05,
            right: size.height * 0.05,
            height: size.height * 0.5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: size.width * 0.6,
                        height: size.height * 0.065,
                        decoration: BoxDecoration(
                          color: AppStyle.mainColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: AppStyle.mainColor,
                                    shape: const CircleBorder()),
                                onPressed: () {
                                  loginScreen();
                                  Navigator.pushReplacementNamed(
                                      context, '/login_screen');
                                },
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
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: size.width * 0.6,
                        height: size.height * 0.065,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: AppStyle.mainColor, width: 2)),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () {
                                  loginScreen();
                                  Navigator.pushReplacementNamed(
                                      context, '/number_phone_screen');
                                },
                                child: Center(
                                  child: Text(
                                    'Đăng ký',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
