import 'dart:async';

import 'package:etfi_point/components/widgets/dynamicPopupMenu.dart';
import 'package:etfi_point/components/widgets/globalTextButton.dart';
import 'package:etfi_point/libraries/image_picket_editor/lib/utils/pickerImage.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class ImagePickerSection extends StatefulWidget {
  const ImagePickerSection({
    super.key,
    required this.selectedImages,
    required this.countSelectedImages,
    required this.maxSelectableImages,
    required this.onUpdateCurrentPage,
    required this.onSelectImage,
    required this.onDeletedImage,
  });

  final List<AssetEntity> selectedImages;
  final int countSelectedImages;
  final int maxSelectableImages;
  final Function(int newCurrentPage) onUpdateCurrentPage;
  final Function(AssetEntity newSelectedImage) onSelectImage;
  final Function(AssetEntity newdeletedImage) onDeletedImage;

  @override
  State<ImagePickerSection> createState() => _ImagePickerSectionState();
}

class _ImagePickerSectionState extends State<ImagePickerSection> {
  late StreamController<List<AssetEntity>> allImagesStreamController;
  late Stream<List<AssetEntity>> _stream;
  List<String> optionsPopupMenu = [];

  @override
  void initState() {
    super.initState();
    allImagesStreamController = StreamController<List<AssetEntity>>();
    _stream = allImagesStreamController.stream;
    initializeImages();
  }

  void initializeImages() async {
    try {
      List<AssetEntity> allImagesAux = await PickerImage.fetchImages();
      allImagesStreamController.add(allImagesAux);
    } catch (e) {
      print("Error fetching images: $e");
    }

    try {
      List<String> optionsPopupMenuAux = await PickerImage.fetchAlbums();
      setState(() {
        optionsPopupMenu = optionsPopupMenuAux;
      });
      print("AllAlbums $optionsPopupMenuAux ");
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  void onSelectedPopup(int index, String result) async {
    List<AssetEntity> allImagesAux =
        await PickerImage.fetchImages(albumName: result);

    setState(() {
      allImagesStreamController.add(allImagesAux);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 4;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Seleccionar imagenes'),
            GlobalTextButton(
              textButton: "Siguiente",
              fontSizeTextButton: 17,
              onPressed: () {
                widget.onUpdateCurrentPage(1);
              },
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DynamicPopupMenu(
                  options: optionsPopupMenu,
                  onSelected: (int index, String result) {
                    onSelectedPopup(index, result);
                  },
                )
              ],
            ),
            StreamBuilder<List<AssetEntity>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final List<AssetEntity> images = snapshot.data!;
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 2.5,
                      mainAxisSpacing: 2.5,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      AssetEntity assetEntity = images[index];
                      bool isSelected =
                          widget.selectedImages.contains(assetEntity);
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
                  );
                } else {
                  return const Center(
                    child: Text("No hay imagenes que mostrar"),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    allImagesStreamController.close();
    super.dispose();
  }
}
