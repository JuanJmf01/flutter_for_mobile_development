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

  static Future<List<int>> getUsuariosSeguidos(int idUsuarioSeguidor) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaUsuariosSeguidos}/$idUsuarioSeguidor';

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Utilizar directamente la respuesta como una lista de objetos
        List<dynamic> jsonResponse = response.data;

        // Extraer los valores de idUsuarioSeguido como enteros
        List<int> usuariosSeguidos = jsonResponse
            .map((dynamic enlaceProducto) =>
                enlaceProducto['idEnlaceProducto'] as int)
            .toList();

        return usuariosSeguidos;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Error en la respuesta: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
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
