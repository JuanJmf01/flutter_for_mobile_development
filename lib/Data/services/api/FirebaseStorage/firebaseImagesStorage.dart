import 'dart:typed_data';
import 'package:etfi_point/Data/models/productImagesStorageTb.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImagesStorage {
  static String definePath(dynamic image) {
    String fileName = '';
    int idUsuario = -1;
    int idFile = -1;

    if (image is ImagesStorageTb) {
      fileName = image.fileName;
      idUsuario = image.idUsuario;
      idFile = image.idFile;
    } else if (image is ImageStorageTb) {
      fileName = image.fileName;
      idUsuario = image.idUsuario;
    }

    String rutaSave = image is ImagesStorageTb && idFile != -1
        ? 'imagenes/$idUsuario/$fileName/$idFile'
        : image is ImageStorageTb && idFile == -1
            ? 'imagenes/$idUsuario/$fileName'
            : '';

    return rutaSave;
  }

  static Future<String> cargarImage(dynamic image) async {
    late Uint8List bytes;
    String imageName = '';

    if (image is ImagesStorageTb) {
      imageName = image.imageName;
      bytes = image.newImageBytes;
    } else if (image is ImageStorageTb) {
      imageName = image.imageName;
      bytes = image.newImageBytes;
    }

    String rutaSave = definePath(image);

    if (rutaSave != '' && bytes.isNotEmpty) {
      final Reference ref =
          FirebaseStorage.instance.ref().child(rutaSave).child(imageName);
      final UploadTask uploadTask = ref.putData(bytes);

      try {
        final TaskSnapshot snapshot = await uploadTask;
        final String url = await snapshot.ref.getDownloadURL();

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

  static Future<String> updateImage(dynamic image) async {
    late Uint8List bytes;

    if (image is ImagesStorageTb) {
      bytes = image.newImageBytes;
    } else if (image is ImageStorageTb) {
      bytes = image.newImageBytes;
    }

    String rutaSave = definePath(image);

    if (rutaSave != '' || bytes.isNotEmpty) {
      final Reference ref = FirebaseStorage.instance.ref().child(rutaSave);
      final UploadTask uploadTask = ref.putData(bytes);

      try {
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
    } else {
      throw Exception('Error uploading image');
    }
  }

  static Future<String> updateImageByPosition(
      dynamic image, int position) async {
    late Uint8List bytes;

    if (image is ImagesStorageTb) {
      bytes = image.newImageBytes;
    } else if (image is ImageStorageTb) {
      bytes = image.newImageBytes;
    }

    String rutaSave = definePath(image);

    if (rutaSave != '' || bytes.isNotEmpty) {
      try {
        // Obtener la lista de elementos en el directorio
        final ListResult listResult =
            await FirebaseStorage.instance.ref(rutaSave).list();
        // Verificar que hay al menos un elemento en la lista y que la posición es válida
        if (listResult.items.isNotEmpty && position < listResult.items.length) {
          final Reference ref = listResult.items[position];
          final UploadTask uploadTask = ref.putData(bytes);

          final TaskSnapshot snapshot = await uploadTask;
          if (snapshot.state == TaskState.success) {
            final String url = await snapshot.ref.getDownloadURL();

            return url;
          } else {
            throw Exception('Error actualizando image');
          }
        } else {
          throw Exception('No hay imágenes en la posición especificada');
        }
      } catch (error) {
        print('Error actualizando image: $error');
        throw Exception('Error actualizando image');
      }
    } else {
      throw Exception('Error uploading image');
    }
  }

  static Future<bool> deleteImage(ImageStorageDeleteTb imageInfo) async {
    String fileName = imageInfo.fileName;
    int idUsuario = imageInfo.idUsuario;
    int idProServicio = imageInfo.idFile;
    String imageName = imageInfo.imageName;

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

  static Future<bool> deleteDirectory(String urlDirectory) async {
    try {
      final Reference ref = FirebaseStorage.instance.ref().child(urlDirectory);

      // Listamos todos los elementos dentro del directorio
      ListResult result = await ref.listAll();

      // Eliminamos cada archivo dentro del directorio
      await Future.forEach(result.items, (Reference item) async {
        await item.delete();
      });

      // Si la eliminación se realiza sin errores, retornamos true
      return true;
    } catch (error) {
      print('Error eliminando directorio: $error');
      // Si hay un error, retornamos false
      return false;
    }
  }
}
