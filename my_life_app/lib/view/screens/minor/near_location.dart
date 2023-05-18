// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_life_app/view/screens/minor/information_notification.dart';
import '../../../models/location.dart';
import '../../widgets/notification_widget.dart';

class NearLocationUser extends StatefulWidget {
  final String documentId;
  const NearLocationUser({required this.documentId, super.key});

  @override
  State<NearLocationUser> createState() => _NearLocationUserState();
}

class _NearLocationUserState extends State<NearLocationUser> {
  late Future<LocationAddress> address;
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

  Future<LocationAddress> getLocation() async {
    final location = await _determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    print(placemarks);
    Placemark place = placemarks[2];
    print(place.toJson());
    return LocationAddress(
      name: place.name.toString(),
      street: place.thoroughfare.toString(),
      ward: '',
      district: place.subAdministrativeArea.toString(),
      city: place.administrativeArea.toString(),
      latitude: location.latitude.toString(),
      longitude: location.longitude.toString(),
    );
  }

  @override
  void initState() {
    super.initState();
    address = getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> reflect = FirebaseFirestore.instance
        .collection('Reflect')
        .where('userid', isEqualTo: widget.documentId)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: reflect,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              'Không có phản ánh ở khu vực này',
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
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InforNotification(
                          data: snapshot.data!.docs[index],
                          index: index,
                          documentId: FirebaseAuth.instance.currentUser!.uid),
                    ));
              },
              child: NotificationWidget(
                notification: snapshot.data!.docs[index],
              ),
            );
          },
        );
      },
    );
  }
}
