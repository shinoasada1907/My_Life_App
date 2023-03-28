import 'package:flutter/material.dart';

class MyInheritedWidget extends InheritedWidget {
  final dynamic data;

  const MyInheritedWidget(
      {super.key, required this.data, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant MyInheritedWidget oldWidget) {
    return oldWidget.data != data;
  }

  static MyInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>()!;
  }
}
