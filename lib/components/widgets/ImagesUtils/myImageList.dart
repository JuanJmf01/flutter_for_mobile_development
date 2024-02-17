import 'package:etfi_point/Data/models/proServicioImagesTb.dart';
import 'package:etfi_point/components/widgets/showImage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

typedef ImageSelectedCallback = void Function(dynamic selectedImage);

class MyImageList extends StatelessWidget {
  const MyImageList({
    super.key,
    required this.imageList,
    this.padding,
    this.maxHeight,
    this.principalImage,
    this.urlPrincipalImage,
    this.fit,
    required this.onImageSelected,
  });

  final ImageList imageList;
  final EdgeInsets? padding;
  final double? maxHeight;
  final Asset? principalImage;
  final String? urlPrincipalImage;
  final BoxFit? fit;
  final ImageSelectedCallback onImageSelected; // Nueva línea

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Container(
        constraints: BoxConstraints(
          maxHeight:
              maxHeight ?? 260, // Altura máxima para la lista de imágenes
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageList.items.length,
          itemBuilder: (BuildContext context, int index) {
            final image = imageList.items[index];
            double originalWidth;
            double originalHeight;
            double desiredWidth = 600.0;
            double? desiredHeight;

            bool isSelected = false;

            if (image is ProServicioImageToUpload) {
              originalWidth = image.width;
              originalHeight = image.height;
              desiredWidth = 600.0;
              desiredHeight = desiredWidth * (originalHeight / originalWidth);

              isSelected = principalImage == image.newImage;
            } else if (image is ProservicioImagesTb && isSelected == false) {
              isSelected = urlPrincipalImage == image.urlImage;
            }

            return Column(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 0.0, 4.0, 8.0),
                  child: GestureDetector(
                    onTap: () {
                      if (image is ProServicioImageToUpload) {
                        onImageSelected(image.newImage);
                      } else if (image is ProservicioImagesTb) {
                        onImageSelected(image.urlImage);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: isSelected
                              ? Border.all(color: Colors.blue, width: 4.5)
                              : null),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: image is ProServicioImageToUpload
                              ? AssetThumb(
                                  asset: image.newImage,
                                  width: desiredWidth.toInt(),
                                  height: desiredHeight!.toInt(),
                                )
                              : image is ProservicioImagesTb
                                  ? ShowImage(
                                      networkImage: image.urlImage,
                                      fit: fit ?? BoxFit.contain,
                                    )
                                  // ? Image.network(
                                  //     image.urlImage,
                                  //     fit: widget.fit ?? BoxFit.contain,
                                  //   )
                                  : const SizedBox.shrink()),
                    ),
                  ),
                )),
                if (isSelected)
                  Text(
                    'Imagen principal',
                    style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
