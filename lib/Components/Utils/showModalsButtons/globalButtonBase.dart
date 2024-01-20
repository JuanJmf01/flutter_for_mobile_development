import 'package:flutter/cupertino.dart';

class GlobalButtonBase extends StatelessWidget {
  const GlobalButtonBase({super.key, required this.itemsColumn});

  final Column itemsColumn;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: itemsColumn,
    );
  }
}
