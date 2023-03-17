import 'package:flutter/material.dart';
import 'package:my_life_app/models/style.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.mainColor,
        centerTitle: true,
        title: const Text('Cài đặt'),
      ),
      body: const Center(
        child: Text('Setting'),
      ),
    );
  }
}
