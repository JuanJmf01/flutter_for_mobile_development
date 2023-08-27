import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/productDetail.dart';
import 'package:flutter/material.dart';

class IndividualProduct extends StatefulWidget {
  const IndividualProduct({super.key, required this.producto});

  final ProductoTb producto;

  @override
  State<IndividualProduct> createState() => _IndividualProductState();
}

class _IndividualProductState extends State<IndividualProduct> {
  Future<void> _navigateToProductDetail(int productId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductDetail(id: productId, producto: widget.producto),
      ),
    );
  }

  // //ACTUALIZACION DE ESTADO
  // void renderizarProductoModificado(idProducto) async {
  //   try {
  //     final productoAux = await ProductoDb.getProducto(idProducto);
  //     setState(() {
  //       productos.removeWhere((element) => element.idProducto == idProducto);
  //       productos.add(productoAux);
  //       productos.sort((a, b) => a.idProducto.compareTo(b.idProducto));
  //     });
  //   } catch (error) {
  //     print(
  //         'Error al obtener el producto (individualProduct, renderizarProductoAgregadoOModificado): $error');
  //   }
  // }

  // //ACTUALIZACION DE ESTADO
  // void deleteProduct(id) {
  //   setState(() {
  //     productos.removeWhere((element) => element.idProducto == id);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            16.0,
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: InkWell(
                  onTap: () {
                    _navigateToProductDetail(widget.producto.idProducto);
                  },
                  child: ShowImage(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    borderRadius: BorderRadius.circular(0.0),
                    height: 170.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    networkImage: widget.producto.urlImage,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.producto.nombreProducto,
                    style: Theme.of(context).textTheme.titleMedium!.merge(
                          const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Price two",
                    style: Theme.of(context).textTheme.titleSmall!.merge(
                          TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                          ),
                        ),
                  ),
                  // Row(
                  //   children: [
                  //     CartPrincipalIcon(
                  //         onpress: () async {
                  //       if (idUsuario != null) {
                  //         ShoppingCartCreacionTb
                  //             shoppingCartProduct =
                  //             ShoppingCartCreacionTb(
                  //           idUsuario: idUsuario,
                  //           idProducto:
                  //               producto.idProducto,
                  //           cantidad: 1,
                  //         );
                  //         bool result = await ShoppingCartDb
                  //             .insertShoppingCartProduct(
                  //                 shoppingCartProduct);
                  //         if (result &&
                  //             context.mounted) {
                  //           print(
                  //               'INIZIALIZAR VALORES');
                  //           context
                  //               .read<
                  //                   ShoppingCartProvider>()
                  //               .initializeValues();
                  //         }
                  //       }
                  //     }),
                  // ModifyPrincipalIcon(onpress: () async {
                  //   print(producto.idProducto);
                  //   result = await Navigator.push<int>(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           EditarProducto(producto: producto),
                  //     ),
                  //   );
                  //   if (result != null) {
                  //     print('Funciona $result');
                  //     renderizarProductoModificado(result);
                  //   }
                  // }),
                  // DeletedPrincipalIcon(
                  //   onpress: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return ConfirmationDialog(
                  //           titulo: 'Advertencia',
                  //           message:
                  //               '¿Seguro que deseas eliminar este producto?',
                  //           onAcceptMessage: 'Aceptar',
                  //           onCancelMessage: 'Cancelar',
                  //           onAccept: () async {
                  //             try {
                  //               print(
                  //                   'Id producto: ${producto.idProducto}');
                  //               await ProductoDb.deleteProducto(
                  //                   producto.idProducto);
                  //               if (context.mounted) {
                  //                 Navigator.of(context).pop();
                  //               }
                  //               deleteProduct(producto.idProducto);
                  //             } catch (error) {
                  //               print(
                  //                   'Error al eliminar el producto: $error');
                  //             }
                  //           },
                  //           onCancel: () {
                  //             Navigator.of(context).pop();
                  //           },
                  //         );
                  //       },
                  //     );
                  //   },
                  // )
                  //],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IndividualProductSample extends StatelessWidget {
  const IndividualProductSample({
    super.key,
    required this.imageBytes,
    required this.widthImage,
    required this.heightImage,
  });

  final Uint8List imageBytes;
  final double widthImage;
  final double heightImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            16.0,
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Image.memory(
                imageBytes,
                width: widthImage,
                height: heightImage,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NameSample',
                    style: Theme.of(context).textTheme.titleMedium!.merge(
                          const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "999.999",
                    style: Theme.of(context).textTheme.titleSmall!.merge(
                          TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                          ),
                        ),
                  ),
                  SizedBox(
                    height: 40.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
