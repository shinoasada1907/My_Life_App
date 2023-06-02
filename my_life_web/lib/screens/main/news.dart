import 'package:flutter/material.dart';

class NewsManagement extends StatefulWidget {
  const NewsManagement({super.key});

  @override
  State<NewsManagement> createState() => _NewsManagementState();
}

class _NewsManagementState extends State<NewsManagement> {
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
