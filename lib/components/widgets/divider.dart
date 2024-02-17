import 'package:flutter/material.dart';

class GlobalDivider extends StatelessWidget {
  const GlobalDivider({super.key, this.width, this.color, this.thickness, this.padding});

  final double? width;
  final Color? color;
  final double? thickness;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        width: width ?? double.infinity,
        child: Divider(
          color: color ?? Colors.grey.shade300,
          thickness: thickness ?? 2.0, // Ancho de la línea en píxeles
        ),
      ),
    );
  }
}
