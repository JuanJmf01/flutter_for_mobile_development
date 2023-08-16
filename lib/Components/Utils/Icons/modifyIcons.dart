import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModifyPrincipalIcon extends StatelessWidget {
  const ModifyPrincipalIcon({super.key, required this.onpress});

  final VoidCallback onpress;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onpress,
      icon: Icon(Icons.edit_outlined),
    );
  }
}
