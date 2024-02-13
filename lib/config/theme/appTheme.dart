import 'package:flutter/material.dart';

//const seedColor = Color.fromARGB(255, 0, 0, 0);

class AppTheme {
  final bool isDarkmode;

  AppTheme({required this.isDarkmode});

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        brightness: isDarkmode ? Brightness.dark : Brightness.light,
      );
}
