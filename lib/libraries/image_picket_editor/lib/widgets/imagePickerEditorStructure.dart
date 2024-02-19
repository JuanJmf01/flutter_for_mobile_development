import 'package:etfi_point/libraries/image_picket_editor/lib/screens/imagePickerSection.dart';
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

  @override
  Widget build(BuildContext context) {
    return currentPage == 1
        ? ImagePickerSection(
            selectedImages: selectedImages,
            maxSelectableImages: 5,
            countSelectedImages: countSelectedImages,
            onUpdateCurrentPage: (int newCurrentPage) {
              setState(() {
                currentPage = currentPage + newCurrentPage;
              });
            },
            onSelectImage: (AssetEntity newSelectedImage) {
              setState(() {
                selectedImages.add(newSelectedImage);
                countSelectedImages += 1;
              });
            },
            onDeletedImage: (AssetEntity newDeletedImage) {
              setState(() {
                selectedImages.remove(newDeletedImage);
                countSelectedImages -= 1;
              });
            },
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Editar iamgen"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    currentPage -= 1;
                  });
                },
              ),
            ),
            body: const Center(
              child: Text("pepe"),
            ),
          );
  }
}
