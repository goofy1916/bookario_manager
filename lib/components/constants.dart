import 'package:bookario_manager/components/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFFFFFFF);
const kPrimaryLightColor = Color(0xFFFFFFFF);
const kSecondaryColor = Color(0xFFD4005C);
const kTextColor = Color(0xFFFFFFFF);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.white,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

String getTimeOfEvent(Timestamp dateTime) {
  final DateTime temp =
      DateTime.fromMicrosecondsSinceEpoch(dateTime.microsecondsSinceEpoch);
  return "${temp.hour}:${temp.minute < 10 ? "0${temp.minute}" : temp.minute}";
}

String getDateOfEvent(Timestamp dateTime) {
  return "${dateTime.toDate().day}/${dateTime.toDate().month}/${dateTime.toDate().year}";
}

Divider divider() {
  return const Divider(
    color: Colors.white70,
    height: 1,
  );
}
