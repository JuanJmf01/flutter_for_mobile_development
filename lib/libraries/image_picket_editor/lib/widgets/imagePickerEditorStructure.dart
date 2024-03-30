import 'dart:io';
import 'dart:typed_data';

import 'package:etfi_point/components/widgets/globalTextButton.dart';
import 'package:etfi_point/libraries/image_editor/lib/screens/imageEditor.dart';
import 'package:etfi_point/libraries/image_picker/lib/screens/imagePicker.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePickerEditorStructure extends StatefulWidget {
  const ImagePickerEditorStructure({super.key});

  @override
  State<ImagePickerEditorStructure> createState() =>
      _ImagePickerEditorStructureState();
}

class _ImagePickerEditorStructureState
    extends State<ImagePickerEditorStructure> {
  List<AssetEntity> selectedImages = [];
  int countSelectedImages = 0;
  int currentPage = 1;

  Uint8List? selectedImage;
  int widthSelectedImage = 0;
  int heightSelectedImage = 0;

  void getBytesFromFile() async {
    File? imageFile = await selectedImages[0].file;
    final bytes = await imageFile?.readAsBytes();

    setState(() {
      selectedImage = bytes;
      widthSelectedImage = selectedImages[0].width;
      heightSelectedImage = selectedImages[0].height;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (currentPage == 1) {
              Navigator.of(context).pop();
            } else if (currentPage > 1 && currentPage <= 2) {
              setState(() {
                currentPage -= 1;
              });
            }
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            currentPage == 1
                ? const Text('Seleccionar imagenes')
                : const SizedBox.shrink(),
            GlobalTextButton(
              textButton: "Siguiente",
              fontSizeTextButton: 17,
              onPressed: () {
                setState(() {
                  if (selectedImages.isNotEmpty) {
                    currentPage += 1;
                  } else {
                    print("Ninguna imagen seleccionada");
                  }
                });
              },
            )
          ],
        ),
      ),
      body: currentPage == 1
          ? ImagePicker(
              selectedImages: selectedImages,
              maxSelectableImages: 5,
              countSelectedImages: countSelectedImages,
              onSelectImage: (AssetEntity newSelectedImage) {
                setState(() {
                  selectedImages.add(newSelectedImage);
                  countSelectedImages += 1;
                });
                getBytesFromFile();
              },
              onDeletedImage: (AssetEntity newDeletedImage) {
                setState(() {
                  selectedImages.remove(newDeletedImage);
                  countSelectedImages -= 1;
                });
              },
            )
          : ImageEditor2(
              selectedImage: selectedImage!,
              width: widthSelectedImage,
              height: heightSelectedImage,
              screenWidth: screenWidth,
            ),
    );
  }
}
