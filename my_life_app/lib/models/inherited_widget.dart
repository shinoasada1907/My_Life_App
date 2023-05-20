import 'package:flutter/material.dart';
import 'package:my_life_app/models/location.dart';

class MyInheritedWidget extends InheritedWidget {
  final dynamic data;
  final LocationAddress? location;

  const MyInheritedWidget(
      {super.key, this.location, this.data, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant MyInheritedWidget oldWidget) {
    return oldWidget.data != data && oldWidget.location != location;
  }

  static MyInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>()!;
  }
}
