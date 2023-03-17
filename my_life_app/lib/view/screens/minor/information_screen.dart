import 'package:flutter/material.dart';
import 'package:my_life_app/models/style.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.mainColor,
        centerTitle: true,
        title: const Text('Thông tin cá nhân'),
      ),
      body: const Center(
        child: Text('information'),
      ),
    );
  }
}
