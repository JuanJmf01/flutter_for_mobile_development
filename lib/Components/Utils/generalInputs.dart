import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralInputs extends StatelessWidget {
  const GeneralInputs({
    super.key,
    this.controller,
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
    this.onChanged,
  });

  final TextEditingController? controller;
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
  final void Function(String?)? onChanged;

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
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 17.2,
                        letterSpacing: 0.6),
                  ),
                )
              : const SizedBox.shrink(),
          Container(
            decoration: BoxDecoration(
              color: color, // Cuadro blanco
              borderRadius: BorderRadius.circular(10.0),
              border: borderInput,
            ),
            child: TextGlobalFiled(
              controller: controller,
              enable: enable,
              minLines: minLines,
              maxLines: maxLines,
              labelText: labelText,
              borderInput: borderInput,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class TextGlobalFiled extends StatelessWidget {
  const TextGlobalFiled({
    super.key,
    this.controller,
    this.enable,
    this.minLines,
    this.maxLines,
    this.labelText,
    this.borderInput,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  final TextEditingController? controller;
  final bool? enable;
  final int? minLines;
  final int? maxLines;
  final String? labelText;
  final BoxBorder? borderInput;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enable ?? true,
      controller: controller,
      minLines: minLines ?? 1,
      maxLines: maxLines,
      onChanged: onChanged,
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
    );
  }
}


// Border.all(
//                 width: 1.0,
//                 color: colorBorder ?? Colors.grey.shade400,
//               ),