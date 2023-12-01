import 'dart:ffi';
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
              : Image.network(
                  networkImage!,
                  width: widthNetWork,
                  height: heightNetwork,
                  fit: fit,
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
