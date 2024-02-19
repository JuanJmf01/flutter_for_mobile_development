import 'package:flutter/material.dart';

//const seedColor = Color.fromARGB(255, 0, 0, 0);

class AppTheme {
  final bool? isDarkmode;

  AppTheme({this.isDarkmode});

  ThemeData getTheme() => ThemeData(
        useMaterial3: false,

        brightness: isDarkmode != null
            ? isDarkmode == true
                ? Brightness.dark
                : Brightness.light
            : Brightness.light,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.black, // Color del texto del título del AppBar
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
            size: 28
          ),
          elevation: 0,
          color: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white, // Color de fondo de la pantalla
      );
}
