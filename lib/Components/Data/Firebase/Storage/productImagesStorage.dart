import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
import 'package:etfi_point/Components/Utils/Services/DataTime.dart';
import 'package:etfi_point/Components/Utils/Services/assingName.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductImagesStorage {
  /// The function `cargarImage` uploads an image to a storage location and returns the inserted product
  /// image.
  ///
  /// Args:
  ///   image (ProductCreacionImagesStorageTb): The parameter "image" is of type
  /// ProductCreacionImagesStorageTb, which is a custom class that contains information about the image
  /// to be uploaded.
  ///
  /// Returns:
  ///   a Future of type ProductImagesTb.
  static Future<ProservicioImagesTb> cargarImage(
      ImageStorageTb image) async {
    final Uint8List bytes = image.newImageBytes;

    //String ruta = 'imagenes/"idUsuario"/"fileName/idProducto, servicio, etc"';

    String finalNameImage = assingName(image.imageName);

    String fileName = image.fileName;
    int idUsuario = image.idUsuario;
    int idFile = image.idFile;

    final Reference ref = storage
        .ref()
        .child('imagenes/$idUsuario/$fileName/$idFile')
        .child(finalNameImage);

    print('REF_: ${ref.fullPath}');

    final UploadTask uploadTask = ref.putData(bytes);

    try {
      final TaskSnapshot snapshot = await uploadTask;
      print('snapshot: $snapshot');

      final String url = await snapshot.ref.getDownloadURL();
      print('url: $url');

      if (snapshot.state == TaskState.success) {
        final ProServicioImageCreacionTb productImage = ProServicioImageCreacionTb(
            idProServicio: idFile,
            nombreImage: finalNameImage,
            urlImage: url,
            width: image.width,
            height: image.height,
            isPrincipalImage: image.isPrincipalImage);

        final ProservicioImagesTb productInsertImage =
            await ProductImageDb.insertProductImages(productImage);

        return productInsertImage;
      } else {
        throw Exception('Error uploading image');
      }
    } catch (error) {
      print('Error uploading image: $error');
      throw Exception('Error uploading image');
    }
  }

  /// The function `updateImage` takes a `ProductImageStorageTb` object, uploads the image data to
  /// Firebase Storage, retrieves the download URL, updates the URL in the database, and returns the URL.
  ///
  /// Args:
  ///   image (ProductImageStorageTb): The `image` parameter is an instance of the
  /// `ProductImageStorageTb` class, which represents the image data to be updated. It contains the
  /// following properties:
  ///
  /// Returns:
  ///   a Future<String>.
  static Future<String> updateImage(ImageStorageTb image) async {
    final Uint8List bytes = image.newImageBytes;
    //String ruta = 'imagenes/"idUsuario"/"fileName/idProducto, servicio, etc"';
    print('nomnbrimagenPrinciapl ${image.imageName}');
    try {
      String fileName = image.fileName;
      int idUsuario = image.idUsuario;
      int idFile = image.idFile;
      String nombreImage = image.imageName;

      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('imagenes/$idUsuario/$fileName/$idFile/$nombreImage');
      final UploadTask uploadTask = ref.putData(bytes);

      final TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        final String url = await snapshot.ref.getDownloadURL();


        //Por ahora no utilizaremos la actualizacion de la iamgen en base de datos ya que no es necesario por ahora
        // ProductImageCreacionTb productImage = ProductImageCreacionTb(
        //     idProducto: idFile,
        //     nombreImage: nombreImage,
        //     urlImage: url,
        //     width: image.width,
        //     height: image.height,
        //     isPrincipalImage: image.isPrincipalImage);

        //Actualizar url un base de datos
        // await ProductImageDb.updateProductImage(productImage);
        return url;
      } else {
        throw Exception('Error actualizando image');
      }
    } catch (error) {
      print('Error actualizando image: $error');
      throw Exception('Error actualizando image');
    }
  }

  static Future<bool> deleteImage(ImageStorageDeleteTb imageInfo) async {
    String fileName = imageInfo.fileName;
    int idUsuario = imageInfo.idUsuario;
    int idProducto = imageInfo.idProducto;
    String imageName = imageInfo.nombreImagen;
    int idProductImage = imageInfo.idProductImage;

    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('imagenes/$idUsuario/$fileName/$idProducto/$imageName');

      await ref.delete();
      // Actualizar base de datos
      bool result = await ProductImageDb.deleteProuctImage(idProductImage);

      return result;
    } catch (error) {
      print('Error eliminando image: $error');
      throw Exception('Error eliminando image');
    }
  }
}
