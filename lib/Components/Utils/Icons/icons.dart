import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeartIcon extends StatelessWidget {
  const HeartIcon({super.key, this.size, this.onTap});

  final double? size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        CupertinoIcons.heart,
        size: size,
      ),
    );
  }
}

class HeartSolidIcon extends StatelessWidget {
  const HeartSolidIcon({super.key, this.size, this.onTap, this.color});

  final double? size;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Icon(
          CupertinoIcons.heart_fill,
          color: color,
          size: size,
        ));
  }
}
