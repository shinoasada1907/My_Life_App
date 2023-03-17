import 'package:flutter/material.dart';
import 'package:my_life_app/models/style.dart';

class AlertWidget {
  static void showAlert({
    required BuildContext context,
    required String title,
    required String content,
    required Function() onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        icon: const Icon(
          Icons.notification_important,
          size: 30,
        ),
        actions: [
          TextButton(
            onPressed: onPressed,
            child: Text(
              'OK',
              style: TextStyle(
                color: AppStyle.mainColor,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
