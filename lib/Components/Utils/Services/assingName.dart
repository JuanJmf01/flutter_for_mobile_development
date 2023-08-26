import 'package:etfi_point/Components/Utils/Services/DataTime.dart';
import 'dart:math';
import 'package:multi_image_picker/multi_image_picker.dart';

String assingName(String imageName) {
  String finalNameImage;

  String currentDateTime = obtenerFechaHoraActual();
  String aleatorio = generarTextoAleatorio();
  String nameImage = imageName.split('.').first;
  String extension = imageName.split('.').last;

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
