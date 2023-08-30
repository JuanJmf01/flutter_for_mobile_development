import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesTb.dart';
import 'package:etfi_point/Components/Data/Firebase/Storage/productImagesStorage.dart';
import 'package:etfi_point/Components/Utils/Services/assingName.dart';
import 'package:etfi_point/Components/Utils/Services/selectImage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class CrudImages {
  static Future<List<ProductImageToUpload>> agregarImagenes() async {
    List<Asset?> imagesAsset = await getImagesAsset();
    List<ProductImageToUpload> allProductImagesAux = [];

    if (imagesAsset.isNotEmpty) {
      for (var image in imagesAsset) {
        ProductImageToUpload newImage = ProductImageToUpload(
          nombreImage: assingName(image!.name!),
          newImage: image,
          width: image.originalWidth!.toDouble(),
          height: image.originalHeight!.toDouble(),
        );
        allProductImagesAux.add(newImage);
      }
    }

    return allProductImagesAux;
  }

//   /// The function `editarImagenes` is used to edit images by replacing them with new images in a list.
//   ///
//   /// Args:
//   ///   image: The parameter `image` is of type `dynamic` and represents an image object.
//   void editarImagenes(final image) async {
//     Asset? asset = await getImageAsset();
//     if (asset != null) {
//       int imageIndex = allProductImages.indexOf(image);

//       int indice = imagesToUpdate
//           .indexWhere((element) => element.nombreImage == image.nombreImage);

//       /** Si 'indice' != de -1  es por que ya ha sido cambiada previamente
//       * En este caso el objeto ya se encuentra dentro de 'imagesToUpdate' por lo tanto
//        * solo es necesario actualizar "imageToUpdate" respecto a su posicion 'indice' y dejar
//        * "nombreImage" igual ya que este nombre se utiliza para completar la ruta en firebase Storage y actualizar */
//       if (indice != -1 || image is ProductImageToUpdate) {
//         ProductImageToUpdate newImage = ProductImageToUpdate(
//           nombreImage: imagesToUpdate[indice].nombreImage,
//           newImage: asset,
//         );
//         setState(() {
//           allProductImages[imageIndex] = newImage;
//           imagesToUpdate[indice] = newImage;
//         });
//       } else {
//         if (image is ProductImagesTb) {
//           ProductImageToUpdate newImage = ProductImageToUpdate(
//             nombreImage: image.nombreImage,
//             newImage: asset,
//           );
//           setState(() {
//             imagesToUpdate.add(newImage);

//             allProductImages[imageIndex] = newImage;
//           });
//         } else if (image is ProductImageToUpload) {
//           int indiceToUpload = imagesToUpload.indexWhere(
//               (element) => element.nombreImage == image.nombreImage);
//           ProductImageToUpload newImage = ProductImageToUpload(
//             nombreImage: assingName(asset.name!),
//             newImage: asset,
//             width: asset.originalWidth!.toDouble(),
//             height: asset.originalHeight!.toDouble(),
//           );

//           setState(() {
//             allProductImages[imageIndex] = newImage;
//             imagesToUpload[indiceToUpload] = newImage;
//           });
//         }
//       }
//     }
//   }

  static Future<bool> eliminarImagen(dynamic image, int idUsuario) async {
    bool band = false;
    if (image is ProductImagesTb) {
      ProductImageStorageDeleteTb infoImageToDelete =
          ProductImageStorageDeleteTb(
        fileName: 'productos',
        idUsuario: idUsuario,
        nombreImagen: image.nombreImage,
        idProducto: image.idProducto,
        idProductImage: image.idProductImage,
      );

      bool deleteResult =
          await ProductImagesStorage.deleteImage(infoImageToDelete);

      if (deleteResult) {
        band = true;
      } else {
        band = false;
      }
    }
    return band;
  }
}
