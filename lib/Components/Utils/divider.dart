import 'package:flutter/material.dart';

class GlobalDivider extends StatelessWidget {
  const GlobalDivider({super.key, this.width, this.color, this.thickness});

  final double? width;
  final Color? color;
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: Divider(
        color: color ?? Colors.grey.shade300,
        thickness: thickness ?? 2.0, // Ancho de la línea en píxeles
      ),
    );
  }
}
