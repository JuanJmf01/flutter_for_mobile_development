import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralInputs extends StatelessWidget {
  const GeneralInputs(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.color,
      this.textLabelOutside,
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
  final String? textLabelOutside;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 4.5),
            child: Text(
              textLabelOutside ?? '',
              style: TextStyle(
                  color: Colors.black54, fontSize: 17.2, letterSpacing: 0.6),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: color, // Cuadro blanco
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(width: 1.0, color: Colors.grey.shade400)
            ),
            child: TextField(
              controller: controller,
              minLines: minLines ?? 1,
              maxLines: maxLines,
              decoration: InputDecoration(
                labelText: labelText,
                border: InputBorder.none, // Sin borde
                contentPadding: const EdgeInsets.fromLTRB(
                    15.0, 8.0, 0.0, 8.0), // Ajustar el padding
              ),
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
            ),
          ),
        ],
      ),
    );
  }
}
