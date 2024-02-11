import 'dart:typed_data';
import 'package:etfi_point/Components/Utils/individualProduct.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ShowSampleAnyImage extends StatelessWidget {
  final String? urlImage;
  final Uint8List? imageBytes;
  final Asset? imageAsset;

  const ShowSampleAnyImage({
    super.key,
    this.urlImage,
    this.imageBytes,
    this.imageAsset,
  });

  Widget buildImageWidget() {
    if (urlImage != null && imageBytes == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(45.0, 00.0, 0.0, 20.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: IndividualProductSample(
              urlImage: urlImage,
              widthImage: 195.0,
              heightImage: 170.0),
        ),
      );
    } else if (imageBytes != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(45.0, 00.0, 0.0, 20.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: IndividualProductSample(
              imageBytes: imageBytes!,
              widthImage: 195.0,
              heightImage: 170.0),
        ),
      );
    } else {
      return FutureBuilder<ByteData>(
        future: imageAsset!.getByteData(),
        builder: (BuildContext context, AsyncSnapshot<ByteData> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(45.0, 00.0, 0.0, 20.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: IndividualProductSample(
                  imageBytes: snapshot.data!.buffer.asUint8List(),
                  widthImage: 195.0,
                  heightImage: 170.0,
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildImageWidget();
  }
}
