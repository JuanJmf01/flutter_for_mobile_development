import 'package:flutter/material.dart';

class NavigatorPush {
  static navigate(BuildContext context, Widget navigateTo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => navigateTo),
    );
  }

  static navigateReplacement(BuildContext context, Widget navigateTo) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => navigateTo),
    );
  }
}
