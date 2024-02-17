import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Data/models/Publicaciones/noEnlaces/publicacionImagesTb.dart';
import 'package:etfi_point/config/routes/routes.dart';

class PublicacionImagesDb {
  static Future<void> insertPublicacionImage(
      PublicacionImagesCreacionTb publicacionImage) async {
    Dio dio = Dio();

    Map<String, dynamic> data = {};
    String url = '';

    url = MisRutas.rutaPublicacionImages;
    data = publicacionImage.toMapPublicacion();

    try {
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
      if (response.statusCode == 200) {
        print('publicacionImage insertado correctamenre');
        print(response.data);
      } else {
        throw Exception(
            'Error en la solicitud en insertPublicacionImage: ${response.statusCode}');
      }
    } catch (error) {
      print('Ha ocurrido un error $error');
      throw Exception('Error de conexión: $error');
    }
  }
}
