import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/proServiciosProvider.dart';
import 'package:etfi_point/Components/Utils/futureGridViewProfile.dart';
import 'package:etfi_point/Components/Utils/individualProduct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MisProductos extends StatefulWidget {
  const MisProductos({
    super.key,
    required this.idUsuario,
  });

  final int idUsuario;

  @override
  State<MisProductos> createState() => _MisProductosState();
}

class _MisProductosState extends State<MisProductos> {
  Future<List<Object>> getProductos(int idUsuario,
      {int? idUsuarioActual}) async {
    if (idUsuarioActual != null) {
      List<ProductoTb> productos = [];

      widget.idUsuario == idUsuarioActual
          ? productos = await context
              .read<ProServiciosProvider>()
              .obtenerProductosByNegocio(idUsuarioActual)
          : productos =
              await ProductoDb.getProductosByNegocio(widget.idUsuario);

      return productos;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    int? idUsuarioActual = context.watch<UsuarioProvider>().idUsuarioActual;

    return FutureGridViewProfile(
      idUsuario: widget.idUsuario,
      future: () =>
          getProductos(widget.idUsuario, idUsuarioActual: idUsuarioActual),
      bodyItemBuilder: (int index, Object item) =>
          IndividualProduct(producto: item as ProductoTb),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 20.0,
        mainAxisExtent: 305,
      ),
    );
  }
}
