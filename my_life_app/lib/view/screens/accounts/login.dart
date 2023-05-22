// ignore_for_file: body_might_complete_normally_nullable, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_life_app/models/inherited_widget.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/screens/accounts/signup.dart';
import 'package:my_life_app/view/screens/accounts/verify.dart';

import '../../../../models/location.dart';
import '../../widgets/auth_widget.dart';
import '../main/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;
  LocationAddress? address;
  TextEditingController? phone;

  @override
  void initState() {
    super.initState();
    phone = TextEditingController();
    isLoading = false;
  }

  //Get location device
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getLocation() async {
    final location = await _determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    print(placemarks);
    Placemark place = placemarks[2];
    print(place.toJson());
    address = LocationAddress(
      name: place.name.toString(),
      street: place.thoroughfare.toString(),
      ward: '',
      district: place.subAdministrativeArea.toString(),
      city: place.administrativeArea.toString(),
      latitude: location.latitude.toString(),
      longitude: location.longitude.toString(),
    );
  }

  //Login with number phone
  Future<void> loginOTPPhone(String phone, bool processing) async {
    try {
      await FirebaseAuth.instance
          .verifyPhoneNumber(
        phoneNumber: '+84${phone.toString()}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
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
              builder: (context) => HomeScreen(location: address),
            ));
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  //Login with google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> loginWithGoogle(String uid) async {
    FirebaseFirestore.instance
        .collection('UserAccount')
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(location: address),
            ));
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MyInheritedWidget(
      location: address,
      child: Scaffold(
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
                          controller: phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) {},
                          decoration: textFormDecoration.copyWith(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: size.height * 0.01),
                        width: size.width * 0.7,
                        height: size.height * 0.07,
                        decoration: BoxDecoration(
                          color: AppStyle.mainColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppStyle.mainColor,
                                  shape: const CircleBorder(),
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await getLocation().whenComplete(
                                    () => loginOTPPhone(phone!.text, true),
                                  );
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
                      const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          'Hoặc',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
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
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppStyle.mainColor,
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  getLocation().whenComplete(
                                    () => signInWithGoogle().whenComplete(() {
                                      loginWithGoogle(FirebaseAuth
                                          .instance.currentUser!.uid);
                                      print(FirebaseAuth
                                          .instance.currentUser!.uid);
                                    }),
                                  );
                                },
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
      ),
    );
  }
}
