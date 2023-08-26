import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesTb.dart';
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
  static Future<ProductImagesTb> cargarImage(
      ProductCreacionImagesStorageTb image) async {
    print('Ento a cargarImage');

    final Uint8List bytes = image.newImageBytes;

    String finalNameImage = assingName(image.imageName);

    String fileName = image.fileName;
    int idUsuario = image.idUsuario;
    int idProducto = image.idProducto;

    final Reference ref = storage
        .ref()
        .child('imagenes/$fileName/$idUsuario/$idProducto')
        .child(finalNameImage);

    print('REF_: ${ref.fullPath}');

    final UploadTask uploadTask = ref.putData(bytes);

    try {
      final TaskSnapshot snapshot = await uploadTask;
      print('snapshot: $snapshot');

      final String url = await snapshot.ref.getDownloadURL();
      print('url: $url');

      if (snapshot.state == TaskState.success) {
        final ProductImageCreacionTb productImage = ProductImageCreacionTb(
            idProducto: idProducto,
            nombreImage: finalNameImage,
            urlImage: url,
            isPrincipalImage: image.isPrincipalImage);

        final ProductImagesTb productInsertImage =
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
  static Future<String> updateImage(ProductImageStorageTb image) async {
    final ByteData byteData = await image.newImage.getByteData();
    final Uint8List imageData = byteData.buffer.asUint8List();

    try {
      String fileName = image.fileName;
      int idUsuario = image.idUsuario;
      int idProducto = image.idProducto;
      String nombreImage = image.nombreImagen;

      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('imagenes/$fileName/$idUsuario/$idProducto/$nombreImage');
      final UploadTask uploadTask = ref.putData(imageData);

      final TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        final String url = await snapshot.ref.getDownloadURL();

        ProductImageCreacionTb productImage = ProductImageCreacionTb(
            idProducto: idProducto,
            nombreImage: nombreImage,
            urlImage: url,
            isPrincipalImage: image.isPrincipalImage);

        //Actualizar url un base de datos
        await ProductImageDb.updateProductImage(productImage);
        return url;
      } else {
        throw Exception('Error actualizando image');
      }
    } catch (error) {
      print('Error actualizando image: $error');
      throw Exception('Error actualizando image');
    }
  }

  static Future<bool> deleteImage(ProductImageStorageDeleteTb imageInfo) async {
    String fileName = imageInfo.fileName;
    int idUsuario = imageInfo.idUsuario;
    int idProducto = imageInfo.idProducto;
    String imageName = imageInfo.nombreImagen;
    int idProductImage = imageInfo.idProductImage;

    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('imagenes/$fileName/$idUsuario/$idProducto/$imageName');

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
