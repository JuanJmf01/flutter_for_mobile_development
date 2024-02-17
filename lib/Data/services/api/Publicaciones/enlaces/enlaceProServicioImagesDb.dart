import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Data/models/Publicaciones/enlaces/enlaceProServicioImagesTb.dart';
import 'package:etfi_point/Data/models/productoTb.dart';
import 'package:etfi_point/Data/models/servicioTb.dart';
import 'package:etfi_point/config/routes/routes.dart';

class EnlaceProServicioImagesDb {
  static Future<void> insertEnlaceProServicioImage(
      EnlaceProServicioImagesCreacionTb enlaceProServicioImage,
      Type objectType) async {
    Dio dio = Dio();

    Map<String, dynamic> data = {};
    String url = '';

    if (objectType == ProductoTb) {
      url = MisRutas.rutaEnlaceProductosImage;
      data = enlaceProServicioImage.toMapEnlaceProducto();
    } else if (objectType == ServicioTb) {
      url = MisRutas.rutaEnlaceServiciosImage;
      data = enlaceProServicioImage.toMapEnlaceServicio();
    }

    try {
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
      if (response.statusCode == 200) {
        print('EnlaceProServicioImage insertado correctamenre');
        print(response.data);
      } else {
        throw Exception(
            'Error en la solicitud en EnlaceProServicioImage: ${response.statusCode}');
      }
    } catch (error) {
      print('Ha ocurrido un error $error');
      throw Exception('Error de conexión: $error');
    }
  }
}
