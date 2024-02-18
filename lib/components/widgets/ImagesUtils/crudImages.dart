import 'package:etfi_point/Data/models/proServicioImagesTb.dart';
import 'package:etfi_point/components/utils/MediaPicker.dart';
import 'package:etfi_point/components/utils/randomServices.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class CrudImages {
  static Future<List<ProServicioImageToUpload>> agregarImagenes() async {
    List<Asset?> imagesAsset = await getImagesAsset();
    List<ProServicioImageToUpload> allProServiciosImagesAux = [];

    if (imagesAsset.isNotEmpty) {
      for (var image in imagesAsset) {
        ProServicioImageToUpload newImage = ProServicioImageToUpload(
          nombreImage: RandomServices.assingName(image!.name!),
          newImage: image,
          width: image.originalWidth!.toDouble(),
          height: image.originalHeight!.toDouble(),
        );
        allProServiciosImagesAux.add(newImage);
      }
    }

    return allProServiciosImagesAux;
  }

  static Future<ProServicioImageToUpload?> addImage() async {
    Asset? imageAsset = await getImageAsset();

    if (imageAsset != null) {
      ProServicioImageToUpload newImage = ProServicioImageToUpload(
        nombreImage: RandomServices.assingName(imageAsset.name!),
        newImage: imageAsset,
        width: imageAsset.originalWidth!.toDouble(),
        height: imageAsset.originalHeight!.toDouble(),
      );
      return newImage;
    }
    return null;
  }
}
