import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ShowImage extends StatelessWidget {
  const ShowImage(
      {super.key,
      this.padding,
      this.imageAsset,
      this.networkImage,
      this.height,
      this.width,
      this.heightAsset,
      this.widthAsset,
      this.fit,
      this.color,
      this.borderRadius,
      this.heightNetwork,
      this.widthNetWork});

  final EdgeInsets? padding;
  final Asset? imageAsset;
  final String? networkImage;
  final double? height;
  final double? width;
  final double? heightAsset;
  final double? widthAsset;
  final BoxFit? fit;
  final Color? color;
  final BorderRadius? borderRadius;
  final double? widthNetWork;
  final double? heightNetwork;

  @override
  Widget build(BuildContext context) {
    final hasBorderRadius = borderRadius != null;

    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: color, borderRadius: borderRadius),
        child: ClipRRect(
            borderRadius:
                hasBorderRadius ? borderRadius! : BorderRadius.circular(0.0),
            child: imageAsset != null
                ? showAssetImage(imageAsset!)
                : networkImage != null && networkImage != ''
                    ? Image.network(
                        //networkImage!, //Poner una imagen por defecto
                        "https://img.freepik.com/foto-gratis/resumen-bombilla-creativa-sobre-fondo-azul-brillante-ia-generativa_188544-8090.jpg?size=626&ext=jpg&ga=GA1.1.1880011253.1704585600&semt=sph",
                        width: widthNetWork,
                        height: heightNetwork,
                        fit: fit,
                      )
                    : Container(
                        width: widthNetWork,
                        height: heightNetwork,
                        color: Colors.grey.shade300,
                      )),
      ),
    );
  }

  Widget getImageWidget() {
    try {
      return Image.network(
        networkImage!,
        width: widthNetWork,
        height: heightNetwork,
        fit: fit,
      );
    } catch (e) {
      // En caso de error al cargar la imagen, muestra una imagen por defecto
      return Image.network(
        'https://img.freepik.com/foto-gratis/resumen-bombilla-creativa-sobre-fondo-azul-brillante-ia-generativa_188544-8090.jpg?size=626&ext=jpg&ga=GA1.1.1880011253.1704585600&semt=sph', // Ruta de la imagen por defecto en tu proyecto
        width: widthNetWork,
        height: heightNetwork,
        fit: fit,
      );
    }
  }

  Widget showAssetImage(Asset image) {
    return FutureBuilder<ByteData>(
      future: (() {
        return image.getByteData();
      })(),
      builder: (BuildContext context, AsyncSnapshot<ByteData> snapshot) {
        if (snapshot.hasData) {
          final byteData = snapshot.data!;
          final bytes = byteData.buffer.asUint8List();
          return SizedBox(
            width: widthAsset,
            height: heightAsset,
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('Error al cargar la imagen');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
