import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_life_app/models/style.dart';
import 'package:my_life_app/view/screens/main/news_screen.dart';
import 'package:my_life_app/view/screens/main/notification_mana.dart';
import 'package:my_life_app/view/screens/main/notification_screen.dart';
import 'package:my_life_app/view/screens/main/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectitem = 0;
  final List<IconData> icons = [
    Icons.home,
    Icons.note_alt_sharp,
    Icons.notifications,
    Icons.person
  ];
  List screen = [
    const NewsScreen(),
    const NotificationManaScreen(),
    const NotificationScreen(),
    ProfileScreen(
      documentId: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[_selectitem],
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.mainColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ));
        },
        child: const Icon(
          Icons.camera_alt,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: MediaQuery.of(context).size.height * 0.07,
        backgroundColor: AppStyle.mainColor,
        icons: icons,
        iconSize: 30,
        activeIndex: _selectitem,
        activeColor: AppStyle.bgColor,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (value) {
          setState(() {
            _selectitem = value;
          });
        },
      ),
    );
  }
}
