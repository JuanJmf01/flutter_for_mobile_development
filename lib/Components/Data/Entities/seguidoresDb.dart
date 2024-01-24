import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/seguidoresTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class SeguidoresDb {
  static Future<void> insertSeguidor(SeguidoresCreacionTb seguidor) async {
    Dio dio = Dio();
    Map<String, dynamic> data = seguidor.toMap();
    String url = MisRutas.rutaSeguidores;

    try {
      Response response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('Seguidor insertado correctamente (print)');
        print(response.data);
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      // Ocurrió un error en la conexión
      print('Error de conexión: $error');
    }
  }

  static Future<bool> deleteSeguidor(
      int idUsuarioSeguidor, int idUsuarioSeguido) async {
    Dio dio = Dio();
    String url = MisRutas.rutaSeguidores;
    Map<String, dynamic> data = {
      "idUsuarioSeguidor": idUsuarioSeguidor,
      "idUsuarioSeguido": idUsuarioSeguido
    };

    try {
      Response response = await dio.delete(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('Seguidor eliminados correctamente');
        return true;
      } else if (response.statusCode == 404) {
        print('Seguidor no encontrado');
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      // Ocurrió un error en la conexión
      print('Error de conexión: $error');
    }
    return false;
  }
}
