import 'package:flutter/material.dart';

class DynamicPopupMenu extends StatefulWidget {
  final List<String> options;
  final Function(int, String) onSelected;

  const DynamicPopupMenu({
    super.key,
    required this.options,
    required this.onSelected,
  });

  @override
  State<DynamicPopupMenu> createState() => _DynamicPopupMenuState();
}

class _DynamicPopupMenuState extends State<DynamicPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onSelected: (String option) {
        int index = widget.options.indexOf(option);
        widget.onSelected(index, option);
      },
      itemBuilder: (BuildContext context) {
        return widget.options.map((String option) {
          return PopupMenuItem<String>(
            value: option,
            height: 40,
            child: Text(option),
          );
        }).toList();
      },
    );
  }
}
