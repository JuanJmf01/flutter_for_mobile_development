import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

Future<XFile?> getImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  return image;
}

Future<Asset?> getImageAsset() async {
  try {
    List<Asset> resultList = await MultiImagePicker.pickImages(
      maxImages: 1,
      enableCamera: true,
    );
    if (resultList.isNotEmpty) {
      return resultList.first;
    }
  } catch (e) {
    // Manejo de errores
  }
  return null;
}

Future <List<Asset?>> getImagesAsset(List<Asset?> selectedImages) async {
  List<Asset> resultList = [];

  try {
    resultList = await MultiImagePicker.pickImages(
      maxImages: 5,
      enableCamera: true, // Habilitar la opción de tomar fotos desde la cámara
      //selectedAssets: selectedImages, // Imágenes seleccionadas previamente
    );
    if(resultList.isNotEmpty){
      return resultList;
    }
  } catch (e) {
    // Manejo de errores
  }

  return [];
}
