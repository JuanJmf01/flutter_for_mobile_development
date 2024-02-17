import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({
    super.key,
    this.padding,
    this.imageAsset,
    this.networkImage,
    this.imageBytes,
    this.height,
    this.width,
    this.heightImage,
    this.widthImage,
    this.fit,
    this.color,
    this.borderRadius,
  });

  final EdgeInsets? padding;
  final Asset? imageAsset;
  final String? networkImage;
  final Uint8List? imageBytes;
  final double? height;
  final double? width;
  final double? heightImage;
  final double? widthImage;
  final BoxFit? fit;
  final Color? color;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final hasBorderRadius = borderRadius != null;

    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius:
              hasBorderRadius ? borderRadius! : BorderRadius.circular(0.0),
          child: imageAsset != null
              ? showAssetImage(imageAsset!)
              : networkImage != null && networkImage != ''
                  ? Image.network(
                      //networkImage!, //Poner una imagen por defecto
                      "https://img.freepik.com/foto-gratis/resumen-bombilla-creativa-sobre-fondo-azul-brillante-ia-generativa_188544-8090.jpg?size=626&ext=jpg&ga=GA1.1.1880011253.1704585600&semt=sph",
                      width: widthImage,
                      height: heightImage,
                      fit: fit,
                    )
                  : imageBytes != null
                      ? showImageMemory(
                          imageBytes!,
                          width: widthImage,
                          height: heightImage,
                        )
                      : Container(
                          width: widthImage,
                          height: heightImage,
                          color: Colors.grey.shade300,
                        ),
        ),
      ),
    );
  }

  Widget showAssetImage(Asset image) {
    return FutureBuilder<ByteData>(
      future: (() {
        return image.getByteData();
      })(),
      builder: (BuildContext context, AsyncSnapshot<ByteData> snapshot) {
        if (snapshot.hasData) {
          final byteData = snapshot.data!;
          Uint8List imageBytes = byteData.buffer.asUint8List();
          return showImageMemory(
            imageBytes,
            width: widthImage,
            height: heightImage,
          );
        } else if (snapshot.hasError) {
          return const Text('Error al cargar la imagen');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget showImageMemory(Uint8List imageBytes,
      {double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.memory(
        imageBytes,
        fit: BoxFit.cover,
      ),
    );
  }
}
