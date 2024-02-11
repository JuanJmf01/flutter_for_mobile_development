import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/enlaces/enlaceProServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/noEnlaces/publicacionImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:flutter/material.dart';

class PageViewImagesScroll extends StatefulWidget {
  const PageViewImagesScroll({super.key, required this.images});

  final List<dynamic> images;

  @override
  State<PageViewImagesScroll> createState() => _PageViewImagesScrollState();
}

class _PageViewImagesScrollState extends State<PageViewImagesScroll> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 340,
          child: PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final image = widget.images[index];
              return image is ProServicioImageToUpload
                  ? ShowImage(
                      imageAsset: image.newImage,
                      borderRadius: BorderRadius.circular(20.0),
                      heightImage: 340,
                      widthImage: 360,
                    )
                  : image is EnlaceProServicioImagesTb ||
                          image is PublicacionImagesTb
                      ? ShowImage(
                          networkImage: image.urlImage,
                          borderRadius: BorderRadius.circular(18.0),
                          fit: BoxFit.cover,
                        )
                      : const SizedBox.shrink();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (index) => buildDot(index),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDot(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == _currentPage ? Colors.grey.shade800 : Colors.grey,
        ),
      ),
    );
  }
}
