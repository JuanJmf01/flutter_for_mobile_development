import 'package:flutter/material.dart';

class LineForDropdownButton extends StatelessWidget {
  const LineForDropdownButton({
    super.key,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.paddingTop,
    this.paddingBottom,
  });

  final double? width;
  final double? height;
  final Color? color;
  final BorderRadius? borderRadius;
  final double? paddingTop;
  final double? paddingBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop ?? 0.0, bottom: paddingBottom ?? 0.0),
      child: Container(
        alignment: Alignment.center,
        child: Container(
          width: width ?? 35.0,
          height: height ?? 5.0,
          decoration: BoxDecoration(
            color: color ?? Colors.grey[400],
            borderRadius: borderRadius ?? BorderRadius.circular(2.5),
          ),
        ),
      ),
    );
  }
}
