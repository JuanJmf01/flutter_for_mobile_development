import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralInputs extends StatelessWidget {
  const GeneralInputs(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.color,
      this.keyboardType,
      this.inputFormatters,
      this.minLines,
      this.maxLines,
      this.horizontalPadding,
      this.verticalPadding});

  final TextEditingController controller;
  final String labelText;
  final Color color;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;
  final double? horizontalPadding;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 0.0,
          vertical: verticalPadding ?? 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: color, // Cuadro blanco
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          controller: controller,
          minLines: minLines ?? 1,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none, // Sin borde
            contentPadding: const EdgeInsets.all(13.0), // Ajustar el padding
          ),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
        ),
      ),
    );
  }
}
