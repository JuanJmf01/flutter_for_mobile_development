import 'package:flutter/material.dart';

class SmallButtonTopTab extends StatelessWidget {
  const SmallButtonTopTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: 35.0,
        height: 5.0,
        decoration: BoxDecoration(
          color: Colors.grey[600],
          borderRadius: BorderRadius.circular(2.5),
        ),
      ),
    );
  }
}
