import 'package:flutter/material.dart';

//const seedColor = Color.fromARGB(255, 0, 0, 0);

class AppTheme {
  final bool isDarkmode;

  AppTheme({required this.isDarkmode});

  ThemeData getTheme() => ThemeData(
        //useMaterial3: true,

        brightness: isDarkmode ? Brightness.dark : Brightness.light,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.black, // Color del texto del título del AppBar
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          color: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white, // Color de fondo de la pantalla
      );
}
