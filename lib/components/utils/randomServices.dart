import 'dart:math';
import 'dart:typed_data';

import 'package:intl/intl.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';

class RandomServices {
  static String obtenerFechaHoraActual() {
    DateTime now = DateTime.now();

    // Formatear la fecha y hora actual
    DateFormat formatter = DateFormat('yyyyMMdd_HHmmss');
    String formattedDateTime = formatter.format(now);

    return formattedDateTime;
  }

  static String assingName(String archivoName) {
    String finalNameImage;

    String currentDateTime = obtenerFechaHoraActual();
    String aleatorio = generarTextoAleatorio();
    String nameImage = archivoName.split('.').first;
    String extension = archivoName.split('.').last;

    print('aleatorio: $aleatorio');

    finalNameImage = '$currentDateTime$aleatorio$nameImage';

    finalNameImage = '$finalNameImage.$extension';
    print('finalNmae_: $finalNameImage');

    return finalNameImage;
  }

  static String generarTextoAleatorio() {
    const letras = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    String textoAleatorio = '_';

    for (int i = 0; i < 7; i++) {
      textoAleatorio += letras[random.nextInt(letras.length)];
    }

    String finalTextoAleatorio = '${textoAleatorio}_';

    return finalTextoAleatorio;
  }

  static double textToDouble(String stringValue) {
    try {
      double doubleValue = double.parse(stringValue);
      return doubleValue;
    } catch (e) {
      print('Error: $e');
      return 0.0;
    }
  }

  static int textToInt(String stringValue) {
    try {
      int intValue = int.parse(stringValue);
      return intValue;
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  // static Future<Uint8List> assetToUint8List(Asset image) async {
  //   final ByteData byteData = await image.getByteData();
  //   final Uint8List bytes = byteData.buffer.asUint8List();

  //   return bytes;
  // }
}
