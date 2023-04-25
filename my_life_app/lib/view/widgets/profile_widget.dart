// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget(
      {required this.icons,
      required this.title,
      required this.onPressed,
      super.key});
  IconData icons;
  String title;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(top: size.height * 0.01),
        width: size.width * 0.95,
        height: size.height * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(icons),
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Nunito'),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 22,
              ),
            )
          ],
        ),
      ),
    );
  }
}
