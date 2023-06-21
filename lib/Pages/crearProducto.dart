
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Utils/productosGeneralForm.dart';
import 'package:flutter/material.dart';

class CrearProducto extends StatefulWidget {
  const CrearProducto({super.key});

  @override
  State<CrearProducto> createState() => _CrearProductoState();
}

class _CrearProductoState extends State<CrearProducto> {
  
  @override
  Widget build(BuildContext context) {
    return ProductosGeneralForm(
      titulo: 'Agregar producto',  
      nameSavebutton: 'Crear',
      exitoMessage: 'Producto creado exitosamente',
    );
  }
}
