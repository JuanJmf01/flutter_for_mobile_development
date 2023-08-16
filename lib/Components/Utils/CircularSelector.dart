import 'package:flutter/material.dart';

class CircularSelector extends StatefulWidget {
  const CircularSelector({
    super.key,
    required this.isSelected,
    this.onChanged,
    this.padding,
    required this.sizeIcon,
  });

  final bool isSelected;
  final ValueChanged<bool>? onChanged;
  final EdgeInsets? padding;
  final double sizeIcon;

  @override
  State<CircularSelector> createState() => _CircularSelectorState();
}

class _CircularSelectorState extends State<CircularSelector> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(isSelected);
        }
      },
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Icon(
          isSelected ? Icons.check_circle : Icons.panorama_fish_eye,
          color: isSelected ? Colors.blue : Colors.grey,
          size: widget.sizeIcon,
        ),
      ),
    );
  }
}
