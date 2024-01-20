import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Utils/Services/DataTime.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImagesStorage {
  static Future<String> cargarImage(dynamic image) async {
    final Uint8List bytes = image.newImageBytes;

    String fileName = '';
    String imageName = '';
    int idUsuario = -1;
    int idFile = -1;

    if (image is ImagesStorageTb) {
      fileName = image.fileName;
      idUsuario = image.idUsuario;
      idFile = image.idFile;
      imageName = image.imageName;
    } else if (image is ImageStorageTb) {
      fileName = image.fileName;
      idUsuario = image.idUsuario;
      imageName = image.imageName;
    }

    String rutaSave = image is ImagesStorageTb && idFile != -1
        ? 'imagenes/$idUsuario/$fileName/$idFile'
        : image is ImageStorageTb && idFile == -1
            ? 'imagenes/$idUsuario/$fileName'
            : '';

    if (rutaSave != '' || rutaSave != null) {
      final Reference ref = storage.ref().child(rutaSave).child(imageName);

      print('REF_: ${ref.fullPath}');

      final UploadTask uploadTask = ref.putData(bytes);

      try {
        final TaskSnapshot snapshot = await uploadTask;
        print('snapshot: $snapshot');

        final String url = await snapshot.ref.getDownloadURL();
        print('url: $url');

        if (snapshot.state == TaskState.success) {
          return url;
        } else {
          throw Exception('Error uploading image');
        }
      } catch (error) {
        print('Error uploading image: $error');
        throw Exception('Error uploading image');
      }
    } else {
      throw Exception('Error uploading image');
    }
  }

  static Future<String> updateImage(ImagesStorageTb image) async {
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
    int idProServicio = imageInfo.idProServicio;
    String imageName = imageInfo.nombreImagen;

    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('imagenes/$idUsuario/$fileName/$idProServicio/$imageName');

      await ref.delete(); // Elimina la imagen

      // Si la eliminación se realiza sin errores, retornamos true
      return true;
    } catch (error) {
      print('Error eliminando image: $error');
      // Si hay un error, retornamos false
      return false;
    }
  }

  static Future<bool> deleteProServicioImage(
      ImageStorageDeleteTb imageInfo) async {
    int idUsuario = imageInfo.idUsuario;
    String fileName = imageInfo.fileName;
    int idProducto = imageInfo.idProServicio;

    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('imagenes/$idUsuario/$fileName/$idProducto');

      // Listar los elementos dentro del directorio
      ListResult result = await ref.listAll();

      // Eliminar cada archivo dentro del directorio
      await Future.forEach(result.items, (Reference item) async {
        await item.delete();
      });

      // Si no hay errores al eliminar, retornamos true
      return true;
    } catch (error) {
      print('Error eliminando directorio: $error');
      // Si hay un error, retornamos false
      return false;
    }
  }
}
