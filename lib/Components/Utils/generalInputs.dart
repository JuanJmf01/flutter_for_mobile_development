import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralInputs extends StatelessWidget {
  GeneralInputs({
    super.key,
    required this.controller,
    required this.labelText,
    required this.color,
    this.keyboardType, 
    this.inputFormatters,
  });

  final TextEditingController controller;
  String labelText;
  Color color;
  TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color, // Cuadro blanco
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none, // Sin borde
          contentPadding: EdgeInsets.all(13.0), // Ajustar el padding
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,

      ),
    );
  }
}
