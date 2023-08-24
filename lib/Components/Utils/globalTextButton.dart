import 'package:flutter/material.dart';

class GlobalTextButton extends StatelessWidget {
  const GlobalTextButton({
    super.key,
    this.padding,
    required this.onPressed,
    required this.textButton,
    this.color,
    this.fontSizeTextButton,
    this.fontWeightTextButton,
  });

  final EdgeInsets? padding;
  final VoidCallback onPressed;
  final String textButton;
  final Color? color;
  final double? fontSizeTextButton;
  final FontWeight? fontWeightTextButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          textButton,
          style: TextStyle(
              color: color,
              fontSize: fontSizeTextButton,
              fontWeight: fontWeightTextButton),
        ),
      ),
    );
  }
}
