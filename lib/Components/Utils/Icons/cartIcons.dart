import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartPrincipalIcon extends StatelessWidget {
  const CartPrincipalIcon({super.key, required this.onpress});

  final VoidCallback onpress;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onpress, icon: const Icon(CupertinoIcons.cart));
  }
}
