import 'package:flutter/material.dart';

class ElevatedGlobalButton extends StatelessWidget {
  const ElevatedGlobalButton({
    super.key,
    required this.nameSavebutton,
    this.fontSize,
    this.fontWeight,
    this.letterSpacing,
    this.widthSizeBox,
    this.heightSizeBox,
    required this.onPress,
    this.borderRadius,
    this.paddingLeft,
    this.paddingTop,
    this.paddingRight,
    this.paddingBottom,
    this.backgroundColor,
    this.colorNameSaveButton,
    this.borderSideColor,
    this.widthBorderSide,
  });

  final String nameSavebutton;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? widthSizeBox;
  final double? heightSizeBox;
  final VoidCallback onPress;
  final BorderRadius? borderRadius;

  final double? paddingLeft;
  final double? paddingTop;
  final double? paddingRight;
  final double? paddingBottom;

  final Color? backgroundColor;
  final Color? colorNameSaveButton;
  final Color? borderSideColor;
  final double? widthBorderSide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(paddingLeft ?? 0.0, paddingTop ?? 0.0,
          paddingRight ?? 0.0, paddingBottom ?? 0.0),
      child: SizedBox(
        width: widthSizeBox,
        height: heightSizeBox,
        child: ElevatedButton(
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.zero),
              side: BorderSide(
                width: widthBorderSide ?? 0.0,
                color: borderSideColor ?? Colors.transparent,
              )),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(nameSavebutton,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    letterSpacing: letterSpacing,
                    color: colorNameSaveButton)),
          ),
        ),
      ),
    );
  }
}
