import 'dart:io';
import 'dart:typed_data';

import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class EditarImagen {
  static Future<Uint8List?> editImage(File tempFile,
      {String? urlImage, Asset? imageAset}) async {
    if (imageAset != null || urlImage != null) {
      // 2. Editar Archivo temporal
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: tempFile.path,
        aspectRatio: const CropAspectRatio(
            ratioX: 2.3, ratioY: 2), // Acomodar ancho y alto para la imagen
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
      );

      if (croppedFile != null) {
        Uint8List croppedBytes = await croppedFile.readAsBytes();
        return croppedBytes;
      }
    }
    return null;
  }
}
