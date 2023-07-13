import 'package:etfi_point/Components/Utils/Services/DataTime.dart';
import 'dart:math';

String assingName(String nameImage, {String? extensionImage}) {
  String finalNameImage;

  String currentDateTime = obtenerFechaHoraActual();
  String aleatorio = generarTextoAleatorio();
  print('aleatorio: $aleatorio');

  finalNameImage = '$currentDateTime$aleatorio$nameImage';

  if (extensionImage != null) {
    finalNameImage = '$finalNameImage.$extensionImage';
    print('finalNmae_: $finalNameImage');
  } else {
    print('nombreFinalSinExtension $finalNameImage');
  }

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
