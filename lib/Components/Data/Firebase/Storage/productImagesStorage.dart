import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/productImagesTb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
import 'package:etfi_point/Components/Utils/Services/DataTime.dart';
import 'package:etfi_point/Components/Utils/Services/assingName.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProductImagesStorage {
  static Future<ProductImagesTb> cargarImage(Asset image, String fileName,
      int idUsuario, int idProducto, int isPrincipalImage) async {
    print('Ento a cargarImage');
    final ByteData byteData = await image.getByteData();
    final Uint8List bytes = byteData.buffer.asUint8List();

    String nameImage = image.name!;
    String nameImageAux = nameImage.split('.').first;
    String extension = nameImage.split('.').last;
    String finalNameImage = assingName(nameImageAux, extensionImage: extension);

    print('FINAL NAME: $finalNameImage');

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
            isPrincipalImage: isPrincipalImage);

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

  static Future<String> updateImage(Asset newImage, String fileName, int idUsuario,
      String nombreImage, int idProducto, int isPrincipalImage) async {
    final ByteData byteData = await newImage.getByteData();
    final Uint8List imageData = byteData.buffer.asUint8List();

    try {
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
            isPrincipalImage: isPrincipalImage);

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

  static Future<bool> deleteImage(String fileName, int idUsuario, String imageName,
      int idProducto, int idProductImage) async {
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
