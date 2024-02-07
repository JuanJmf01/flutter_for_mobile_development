import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralInputs extends StatelessWidget {
  const GeneralInputs({
    super.key,
    required this.controller,
    this.labelText,
    this.color,
    this.colorBorder,
    this.textLabelOutside,
    this.keyboardType,
    this.inputFormatters,
    this.minLines,
    this.maxLines,
    this.padding,
    this.enable,
    this.borderInput,
  });

  final TextEditingController controller;
  final String? labelText;
  final Color? color;
  final Color? colorBorder;
  final TextInputType? keyboardType;
  final String? textLabelOutside;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;
  final EdgeInsetsGeometry? padding;
  final bool? enable;
  final BoxBorder? borderInput;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textLabelOutside != '' && textLabelOutside != null
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 4.5),
                  child: Text(
                    textLabelOutside!,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 17.2,
                        letterSpacing: 0.6),
                  ),
                )
              : SizedBox.shrink(),
          Container(
            decoration: BoxDecoration(
                color: color, // Cuadro blanco
                borderRadius: BorderRadius.circular(10.0),
                border: borderInput),
            child: TextField(
              enabled: enable ?? true,
              controller: controller,
              minLines: minLines ?? 1,
              maxLines: maxLines,
              decoration: InputDecoration(
                labelText: labelText,
                border: borderInput != null
                    ? InputBorder.none
                    : const UnderlineInputBorder(),
                contentPadding: const EdgeInsets.fromLTRB(
                    15.0, 7.0, 0.0, 7.0), // Ajustar el padding
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


// Border.all(
//                 width: 1.0,
//                 color: colorBorder ?? Colors.grey.shade400,
//               ),