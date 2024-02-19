import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

//  Convertir Asset o URLimage (image.network) a Archivo temporal
class FileTemporal {
  // static Future<File> convertToTempFile({String? urlImage, Asset? image}) async {
  //   final tempDir = await getTemporaryDirectory();
  //   final tempFile = File('${tempDir.path}/temp_image.jpg');

  //   if (urlImage != null) {
  //     // Descargar la imagen de la URL y guardarla en el archivo temporal
  //     final response = await Dio()
  //         .get(urlImage, options: Options(responseType: ResponseType.bytes));
  //     await tempFile.writeAsBytes(response.data);
  //   } else if (image != null) {
  //     final byteData = await image.getByteData();
  //     final buffer = byteData.buffer.asUint8List();
  //     await tempFile.writeAsBytes(buffer);
  //   }

  //   return tempFile;
  // }
}
