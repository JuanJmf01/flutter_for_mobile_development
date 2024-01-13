import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManageIcon extends StatelessWidget {
  const ManageIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.onTap,
    this.paddingLeft,
    this.paddingTop,
    this.paddingRight,
    this.paddingBottom,
  });

  final IconData icon;
  final double? size;
  final Color? color;
  final VoidCallback? onTap;
  final double? paddingLeft;
  final double? paddingTop;
  final double? paddingRight;
  final double? paddingBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        paddingLeft ?? 0.0,
        paddingTop ?? 0.0,
        paddingRight ?? 0.0,
        paddingBottom ?? 0.0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          icon,
          size: size,
          color: color,
        ),
      ),
    );
  }
}

class Compartir extends StatelessWidget {
  const Compartir({
    super.key,
    this.size,
    this.onTap,
    this.paddingLeft,
    this.paddingTop,
    this.paddingRight,
    this.paddingBottom,
    this.color,
  });

  final double? size;
  final VoidCallback? onTap;
  final double? paddingLeft;
  final double? paddingTop;
  final double? paddingRight;
  final double? paddingBottom;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        paddingLeft ?? 0.0,
        paddingTop ?? 0.0,
        paddingRight ?? 0.0,
        paddingBottom ?? 0.0,
      ),
      child: GestureDetector(
          onTap: onTap,
          child: Icon(
            CupertinoIcons.paperplane,
            color: color,
            size: size,
          )),
    );
  }
}
