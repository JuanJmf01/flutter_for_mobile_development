import 'package:etfi_point/components/widgets/globalTextButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArrowTextButton extends StatelessWidget {
  const ArrowTextButton({
    super.key,
    required this.textButton,
    required this.onTap,
    this.fontSizeTextButton,
    this.fontWeightTextButton,
    this.horizontalPaggin,
    this.paddingTop,
    this.paddingBottom,
    this.color,
  });

  final String textButton;
  final VoidCallback onTap;
  final double? fontSizeTextButton;
  final FontWeight? fontWeightTextButton;
  final double? horizontalPaggin;
  final double? paddingTop;
  final double? paddingBottom;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPaggin ?? 0.0,
        paddingTop ?? 0.0,
        horizontalPaggin ?? 0.0,
        paddingBottom ?? 0.0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GlobalTextButton(
              textButton: textButton,
              fontSizeTextButton: fontSizeTextButton ?? 18,
              fontWeightTextButton: fontWeightTextButton ?? FontWeight.w500,
              color: color ?? Colors.grey.shade800,
            ),
            const Icon(
              CupertinoIcons.chevron_forward,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
