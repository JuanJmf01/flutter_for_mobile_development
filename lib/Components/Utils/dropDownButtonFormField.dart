import 'package:flutter/material.dart';

class DropDownButtonFormField extends StatefulWidget {
  const DropDownButtonFormField(
      {super.key,
      this.padding,
      required this.hintText,
      required this.elementosDisponibles,
      required this.onChanged});

  final EdgeInsets? padding;
  final String hintText;
  final void Function(dynamic) onChanged;

  final List<dynamic>? elementosDisponibles;

  @override
  State<DropDownButtonFormField> createState() =>
      _DropDownButtonFormFieldState();
}

class _DropDownButtonFormFieldState extends State<DropDownButtonFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
        ),
        //value: elementosDisponibles,
        items: widget.elementosDisponibles?.map((elemento) {
          // String nombreElemento = '';
          // if (elemento is CategoriaTb || elemento is SubCategoriaTb) {
          //   nombreElemento = elemento.nombre;
          // }
          return DropdownMenuItem<dynamic>(
            value: elemento,
            child: Text(
              elemento.nombre,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
        onChanged: widget.onChanged,
        dropdownColor: Colors.grey[200],
      ),
    );
  }
}
