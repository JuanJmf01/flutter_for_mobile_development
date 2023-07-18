import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({
    super.key,
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
  });

  final EdgeInsets? padding;
  final Asset? imageAsset;
  final String? networkImage;
  final double? height;
  final double? width;
  final int? heightAsset;
  final int? widthAsset;
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
        decoration: BoxDecoration(color: color, borderRadius: borderRadius),
        child: ClipRRect(
          borderRadius:
              hasBorderRadius ? borderRadius! : BorderRadius.circular(0.0),
          child: imageAsset != null
              ? AssetThumb(
                  asset: imageAsset!,
                  width: widthAsset ?? 0,
                  height: heightAsset ?? 0,
                )
              : Image.network(
                  networkImage!,
                  fit: fit,
                ),
        ),
      ),
    );
  }
}
