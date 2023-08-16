import 'package:flutter/material.dart';

class RoundedSearchBar extends StatelessWidget {
  final TextEditingController controller;

  RoundedSearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const Padding(padding: EdgeInsets.only(left: 5)),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Buscar...',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            height: 40,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(30),
                  right: Radius.circular(30),                
                ),
                color: Colors.black87
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     Colors.grey.shade600,
                //     Colors.black,
                //   ],
                // ),
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
