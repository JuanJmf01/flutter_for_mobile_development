import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/enlaces/enlaceProServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class EnlaceProServicioImagesDb {
  static Future<void> insertEnlaceProServicioImage(
      EnlaceProServicioImagesCreacionTb enlaceProServicioImage) async {
    Dio dio = Dio();
    Map<String, dynamic> data = enlaceProServicioImage.toMap();
    String url = MisRutas.rutaEnlaceProductosImage;

    try {
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
      if (response.statusCode == 200) {
        print('EnlaceProductoImage insertado correctamenre');
        print(response.data);
      } else {
        throw Exception(
            'Error en la solicitud en EnlaceProductoImage: ${response.statusCode}');
      }
    } catch (error) {
      print('Ha ocurrido un error $error');
      throw Exception('Error de conexión: $error');
    }
  }
}
