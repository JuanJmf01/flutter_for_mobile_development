import 'dart:typed_data';
import 'package:etfi_point/constants/productos.dart';
import 'package:etfi_point/components/widgets/showImage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class IndividualProduct extends StatelessWidget {
  const IndividualProduct({
    super.key,
    this.urlImage,
    this.imageAsset,
    this.imageBytes,
    this.onTap,
    required this.precio,
    this.oferta,
    this.descuento,
    required this.nombre,
  });

  final String? urlImage;
  final Asset? imageAsset;
  final Uint8List? imageBytes;
  final VoidCallback? onTap;
  final double precio;
  final int? oferta;
  final int? descuento;
  final String nombre;

  String priceWithDesc(double price, int descuento) {
    double newPrice;

    newPrice = price - (price * (descuento / 100.0));

    return newPrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    double borderCircularProduct = 20.0;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: MyProducts.height,
      width: (screenWidth / 2) - MyProducts.width * 2,
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
            onTap: onTap,
            child: ShowImage(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderCircularProduct),
                topRight: Radius.circular(borderCircularProduct),
              ),
              height: 170.0,
              width: double.infinity,
              fit: BoxFit.cover,
              networkImage: urlImage,
              imageAsset: imageAsset,
              imageBytes: imageBytes,
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
                  "\$${precio.toString()}",
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                        const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.5,
                        ),
                      ),
                ),
                oferta == 1 && descuento != null
                    ? Text(
                        "\$ ${priceWithDesc(precio, descuento!)}",
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
                    nombre != '' ? nombre : "Nombre de producto",
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
          oferta == 1
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
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}