import 'dart:io';
import 'dart:typed_data';

import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class EditarImagen {
  static Future<Uint8List?> editImage(
      File tempFile, double ratioX, double ratioY) async {
    // 2. Editar Archivo temporal
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: tempFile.path,
      aspectRatio: CropAspectRatio(
          ratioX: ratioX,
          ratioY: ratioY), // Acomodar ancho y alto para la imagen
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
    );

    if (croppedFile != null) {
      Uint8List croppedBytes = await croppedFile.readAsBytes();
      return croppedBytes;
    }
    return null;
  }

  static Future<Uint8List?> editCircularImage(File tempFile) async {
    // 2. Editar Archivo temporal
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: tempFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      cropStyle: CropStyle.circle, // Configurar el estilo de recorte a circular
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
    );

    if (croppedFile != null) {
      Uint8List croppedBytes = await croppedFile.readAsBytes();
      return croppedBytes;
    }
    return null;
  }
}
