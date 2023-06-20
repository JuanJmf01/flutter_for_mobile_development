import 'package:flutter/material.dart';

class Stars extends StatelessWidget {
  Stars(
      {super.key,
      required this.index,
      required this.size,
      required this.separationEachStar,
      required this.color
      });

  final int index;
  final double size;
  final double separationEachStar;
  final Color color;

  int? rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          SizedBox(
            width: separationEachStar,
            child: Icon(
              i <= index ? Icons.star_rounded : Icons.star_border_rounded,
              color: color,
              size: size,
            ),
          ),
      ],
    );
  }
}
