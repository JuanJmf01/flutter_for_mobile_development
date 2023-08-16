import 'package:flutter/material.dart';

class SwitchIcon extends StatefulWidget {
  const SwitchIcon({super.key, required this.isChecked, this.onChanged});

  final bool isChecked;
  final ValueChanged<bool>? onChanged;

  @override
  State<SwitchIcon> createState() => _SwitchIconState();
}

class _SwitchIconState extends State<SwitchIcon> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(isChecked);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 50,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isChecked ? Colors.blue : Colors.grey,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: isChecked ? 25 : 0,
              right: isChecked ? 0 : 25,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
