import 'package:etfi_point/Components/Utils/Services/DataTime.dart';
import 'dart:math';

String assingName(String archivoName) {
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

String generarTextoAleatorio() {
  const letras = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  String textoAleatorio = '_';

  for (int i = 0; i < 7; i++) {
    textoAleatorio += letras[random.nextInt(letras.length)];
  }

  String finalTextoAleatorio = '${textoAleatorio}_';

  return finalTextoAleatorio;
}
