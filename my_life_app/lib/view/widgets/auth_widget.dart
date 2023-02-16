import 'package:flutter/material.dart';
import 'package:my_life_app/models/style.dart';
import 'package:pinput/pinput.dart';

var textFormDecoration = InputDecoration(
  labelText: 'Số điện thoại',
  hintText: 'Nhập số điện thoại',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: AppStyle.mainColor,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(25),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: AppStyle.mainColor,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(25),
  ),
);

extension PhonelValidator on String {
  bool isValidPhoneNumber() {
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(this);
  }
}

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: const TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
    borderRadius: BorderRadius.circular(10),
  ),
);

final submittedPinTheme = defaultPinTheme.copyWith(
  decoration: defaultPinTheme.decoration?.copyWith(
    color: const Color.fromRGBO(234, 239, 243, 1),
  ),
);
