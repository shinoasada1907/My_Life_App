// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_life_app/models/news.dart';
import 'package:my_life_app/models/style.dart';

class ReadNewsScreen extends StatelessWidget {
  ReadNewsScreen({required this.index, super.key});
  int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.mainColor,
        centerTitle: true,
        title: Text(newslist[index].categories!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: Column(
            children: [
              Text(
                newslist[index].title!,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.asset(newslist[index].url!),
              ),
              Text(
                newslist[index].description!,
                style: const TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
