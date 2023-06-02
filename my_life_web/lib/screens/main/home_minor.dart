import 'package:flutter/material.dart';

class HomeMinorScreen extends StatefulWidget {
  const HomeMinorScreen({super.key});

  @override
  State<HomeMinorScreen> createState() => _HomeMinorScreenState();
}

class _HomeMinorScreenState extends State<HomeMinorScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      padding: const EdgeInsets.only(top: 10),
      itemBuilder: (context, index) => Container(
        height: 100,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).canvasColor,
          boxShadow: const [BoxShadow()],
        ),
      ),
    );
  }
}
