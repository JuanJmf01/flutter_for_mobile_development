import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/publicacionesTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class PublicacionesDb {
  static Future<int> insertPublicacion(PublicacionesTb publicacion) async {
    Dio dio = Dio();

    Map<String, dynamic> data = publicacion.toMap();
    String url = MisRutas.rutaPublicaciones;

    try {
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
      if (response.statusCode == 200) {
        print('publicacion insertado correctamenre');
        print(response.data);
        int idPublicacion = response.data;

        return idPublicacion;
      } else {
        throw Exception(
            'Error en la solicitud en insertPublicacion: ${response.statusCode}');
      }
    } catch (error) {
      print('Ha ocurrido un error $error');
      throw Exception('Error de conexión: $error');
    }
  }
}
