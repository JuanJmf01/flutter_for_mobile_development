import 'package:etfi_point/components/widgets/dynamicPopupMenu.dart';
import 'package:etfi_point/libraries/image_picker/lib/data/services/providers/imagePickerProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class ImagePicker extends ConsumerStatefulWidget {
  const ImagePicker({
    super.key,
    required this.selectedImages,
    required this.countSelectedImages,
    required this.maxSelectableImages,
    required this.onSelectImage,
    required this.onDeletedImage,
  });

  final List<AssetEntity> selectedImages;
  final int countSelectedImages;
  final int maxSelectableImages;
  final Function(AssetEntity newSelectedImage) onSelectImage;
  final Function(AssetEntity newdeletedImage) onDeletedImage;

  @override
  ImagePickerState createState() => ImagePickerState();
}

class ImagePickerState extends ConsumerState<ImagePicker> {
  String? currentAlbum;


  void ifAnImageIsPress(AssetEntity assetEntity, bool isSelected) {
    if (isSelected) {
      widget.onDeletedImage(assetEntity);
    } else {
      if (widget.countSelectedImages < widget.maxSelectableImages) {
        widget.onSelectImage(assetEntity);
      } else {
        print("Maximo de imagenes seleccionadas alcanzado");
      }
    }
  }

  String handleCountImages(AssetEntity assetEntity) {
    return (widget.selectedImages.indexOf(assetEntity) + 1).toString();
  }

  List<String> handleAlbums(List<AssetPathEntity> albums) {
    return albums.map((album) => album.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 4;
    double screenWidth = MediaQuery.of(context).size.width;

    final imageContentAsync = ref.watch(imageContentProvider(currentAlbum));

    return SingleChildScrollView(
        child: imageContentAsync.when(
      data: (imageContent) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DynamicPopupMenu(
                  options: handleAlbums(imageContent.albums),
                  onSelected: (int index, String result) {
                    setState(() {
                      currentAlbum = result;
                    });
                  },
                )
              ],
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 2.5,
                mainAxisSpacing: 2.5,
              ),
              itemCount: imageContent.images.length,
              itemBuilder: (context, index) {
                AssetEntity assetEntity = imageContent.images[index];
                bool isSelected = widget.selectedImages.contains(assetEntity);
                Color backgroundIsSelected =
                    isSelected ? Colors.blue : Colors.white38;
                Color borderIsSelected =
                    isSelected ? Colors.black54 : Colors.grey.shade300;

                return GestureDetector(
                  onTap: () => ifAnImageIsPress(assetEntity, isSelected),
                  child: Stack(
                    children: [
                      Image(
                        image: AssetEntityImageProvider(assetEntity),
                        fit: BoxFit.cover,
                        height: screenWidth / crossAxisCount,
                        width: screenWidth / crossAxisCount,
                      ),
                      if (widget.selectedImages.isNotEmpty)
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: backgroundIsSelected,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: borderIsSelected,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                                child: isSelected
                                    ? Text(
                                        handleCountImages(assetEntity),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : const SizedBox.shrink()),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
      error: (_, __) => const Text('No se pudo cargar el contenido'),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
