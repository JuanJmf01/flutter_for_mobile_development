import 'dart:async';

import 'package:etfi_point/components/widgets/globalTextButton.dart';
import 'package:etfi_point/libraries/image_picket_editor/lib/utils/pickerImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

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

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 3;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.countSelectedImages}/${widget.maxSelectableImages}'),
            GlobalTextButton(
              textButton: "Siguiente",
              fontSizeTextButton: 19,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const GlobalTextButton(
                  textButton: "Selección de imagenes",
                  fontSizeTextButton: 19,
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                  color: Colors.black,
                ),
                PopupMenuButton<String>(
                  offset: const Offset(0, 50),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  onSelected: (String result) {
                    print('Opción seleccionada: $result');
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'opcion1',
                      child: Container(
                        decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: const Text('Opción 1'),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'opcion2',
                      child: Container(
                        decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: const Text('Opción 2'),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'opcion3',
                      child: Container(
                        decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: const Text('Opción 3'),
                      ),
                    ),
                  ],
                ),
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
                            if (isSelected)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black26,
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
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
