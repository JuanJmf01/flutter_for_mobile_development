import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemForModalButtons extends StatelessWidget {
  const ItemForModalButtons(
      {super.key,
      required this.onPress,
      required this.padding,
      this.icon,
      this.colorIcon,
      required this.textItem});

  final VoidCallback onPress;
  final EdgeInsets padding;
  final IconData? icon;
  final Color? colorIcon;
  final String textItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: onPress,
          child: Row(
            children: [
              Icon(
                icon,
                color: colorIcon,
              ),
              SizedBox(width: 10.0),
              Text(
                textItem,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
