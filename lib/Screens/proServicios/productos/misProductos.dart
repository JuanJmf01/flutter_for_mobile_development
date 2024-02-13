import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Utils/constants/productos.dart';
import 'package:etfi_point/Components/Utils/futureGridViewProfile.dart';
import 'package:etfi_point/Components/Utils/individualProduct.dart';
import 'package:etfi_point/Components/providers/proServiciosProvider.dart';
import 'package:etfi_point/Components/providers/userStateProvider.dart';
import 'package:etfi_point/Screens/proServicios/proServicioDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MisProductos extends ConsumerStatefulWidget {
  const MisProductos({
    super.key,
    required this.idUsuario,
  });

  final int idUsuario;

  @override
  MisProductosState createState() => MisProductosState();
}

class MisProductosState extends ConsumerState<MisProductos> {
  Future<List<Object>> getProductos(int idUsuario,
      {int? idUsuarioActual}) async {
    if (idUsuarioActual != null) {
      final List<ProductoTb> productos;

      if (widget.idUsuario == idUsuarioActual) {
        final productosFuture =
            ref.read(productosByNegocioProvider(idUsuario).future);
        productos = await productosFuture;

        //ref.read(isInitProductosProvider.notifier).update((state) => true);
      } else {
        productos = await ProductoDb.getProductosByNegocio(widget.idUsuario);
      }

      return productos;
    }
    return [];
  }

  Future<void> _navigateToProductDetail(
      int productId, ProductoTb producto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProServicioDetail(
          proServicio: producto,
          nameContexto: "producto",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //int? idUsuarioActual = context.watch<UsuarioProvider>().idUsuarioActual;

    final int? idUsuarioActual = ref.watch(getCurrentUserProvider).value;

    return FutureGridViewProfile(
      idUsuario: widget.idUsuario,
      future: () =>
          getProductos(widget.idUsuario, idUsuarioActual: idUsuarioActual),
      bodyItemBuilder: (int index, Object item) {
        ProductoTb producto = item as ProductoTb;
        return IndividualProduct(
          urlImage: producto.urlImage,
          onTap: () => _navigateToProductDetail(
            producto.idProducto,
            producto,
          ),
          precio: producto.precio,
          oferta: producto.oferta,
          descuento: producto.descuento,
          nombre: producto.nombre,
        );
      },
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: MyProducts.width,
        mainAxisSpacing: 20.0,
        mainAxisExtent: MyProducts.height,
      ),
    );
  }
}
