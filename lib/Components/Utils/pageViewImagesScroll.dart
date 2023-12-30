import 'package:etfi_point/Components/Data/EntitiModels/enlaces/enlaceProServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:flutter/material.dart';

class PageViewImagesScroll extends StatelessWidget {
  const PageViewImagesScroll({super.key, required this.images});

  final List<dynamic> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 340,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return image is ProServicioImageToUpload
              ? ShowImage(
                  imageAsset: image.newImage,
                  borderRadius: BorderRadius.circular(20.0),
                  heightAsset: 340,
                  widthAsset: 360,
                )
              : image is EnlaceProServicioImagesTb
                  ? ShowImage(
                      networkImage: image.urlImage,
                      borderRadius: BorderRadius.circular(18.0),
                      fit: BoxFit.cover,
                    )
                  : SizedBox.shrink();
        },
      ),
    );
  }
}
