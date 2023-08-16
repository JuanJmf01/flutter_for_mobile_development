import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

String obtenerFechaHoraActual() {
  DateTime now = DateTime.now();

  // Formatear la fecha y hora actual
  DateFormat formatter = DateFormat('yyyyMMdd_HHmmss');
  String formattedDateTime = formatter.format(now);

  return formattedDateTime;
}


