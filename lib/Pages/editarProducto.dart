import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Utils/productosGeneralForm.dart';
import 'package:flutter/material.dart';

class EditarProducto extends StatefulWidget {
  const EditarProducto({
    super.key,
    required this.producto
  });

  final ProductoTb producto;

  @override
  State<EditarProducto> createState() => _EditarProductoState();
}

class _EditarProductoState extends State<EditarProducto> {
  @override
  Widget build(BuildContext context) {
    return ProductosGeneralForm(
      data: widget.producto,
      titulo: 'Editar producto',
      nameSavebutton: 'Guardar',
      exitoMessage: 'Producto actualizado exitosamente',
    );
  }
}