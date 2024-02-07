import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/proServicios/proServicioDetail.dart';
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
        builder: (context) => ProServicioDetail(
          proServicio: widget.producto,
          nameContexto: "producto",
        ),
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

  String priceWithDesc(double price, int descuento) {
    double newPrice;

    newPrice = price - (price * (descuento / 100.0));

    return newPrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    double borderCircularProduct = 20.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            borderCircularProduct,
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                _navigateToProductDetail(producto.idProducto);
              },
              child: ShowImage(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderCircularProduct),
                  topRight: Radius.circular(borderCircularProduct),
                ),
                height: 170.0,
                width: double.infinity,
                fit: BoxFit.cover,
                networkImage: producto.urlImage,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "\$${producto.precio}",
                    style: Theme.of(context).textTheme.titleSmall!.merge(
                          const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.5,
                          ),
                        ),
                  ),
                  producto.oferta == 1 && producto.descuento != null
                      ? Text(
                          "\$ ${priceWithDesc(producto.precio, producto.descuento!)}",
                          style: Theme.of(context).textTheme.titleSmall!.merge(
                                TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade500,
                                    fontSize: 17),
                              ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                    child: Text(
                      producto.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            producto.oferta == 1
                ? Container(
                    width: double.infinity,
                    height: 30.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(borderCircularProduct),
                        top: Radius.zero,
                      ),
                      color: const Color(0xFFC59400),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

class IndividualProductSample extends StatelessWidget {
  const IndividualProductSample({
    super.key,
    this.imageBytes,
    this.urlImage,
    required this.widthImage,
    required this.heightImage,
  });

  final String? urlImage;
  final Uint8List? imageBytes;
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
                child: imageBytes != null
                    ? Image.memory(
                        imageBytes!,
                        width: widthImage,
                        height: heightImage,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        urlImage!,
                        width: 195,
                        height: 170,
                        fit: BoxFit.cover,
                      )),
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
