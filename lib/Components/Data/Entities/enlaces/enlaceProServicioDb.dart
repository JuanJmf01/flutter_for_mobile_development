import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/enlaces/enlaceProServicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class EnlaceProServicioDb {
  static Future<int> insertEnlaceProServicio(
      EnlaceProServicioCreacionTb enlaceProducto, Type objectType) async {
    Dio dio = Dio();

    Map<String, dynamic> data = {};
    String url = '';

    if (objectType == ProductoTb) {
      data = enlaceProducto.toMapEnlaceProducto();
      url = MisRutas.rutaEnlaceProductos;
    } else if (objectType == ServicioTb) {
      data = enlaceProducto.toMapEnlaceServicio();
      url = MisRutas.rutaEnlaceServicios;
    }

    try {
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
      if (response.statusCode == 200) {
        print('EnlaceProducto insertado correctamenre');
        print(response.data);
        int idEnlaceProducto = response.data;

        return idEnlaceProducto;
      } else {
        throw Exception(
            'Error en la solicitud en EnlaceProducto: ${response.statusCode}');
      }
    } catch (error) {
      print('Ha ocurrido un error $error');
      throw Exception('Error de conexión: $error');
    }
  }

  static Future<int> insertproductEnlaceReel(
      ProductEnlaceReelCreacionTb reel) async {
    Dio dio = Dio();
    Map<String, dynamic> data = reel.toMap();
    String url = MisRutas.rutaProductEnlaceReels;

    try {
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
      if (response.statusCode == 200) {
        print('product reel insertado correctamenre');
        int idReel = response.data;

        return idReel;
      } else {
        throw Exception(
            'Error en la solicitud en insert product Reel: ${response.statusCode}');
      }
    } catch (error) {
      print('Ha ocurrido un error $error');
      throw Exception('Error de conexión: $error');
    }
  }

  static Future<int> insertServiceEnlaceReel(
      ServiceEnlaceReelCreacionTb reel) async {
    Dio dio = Dio();
    Map<String, dynamic> data = reel.toMap();
    String url = MisRutas.rutaServiceEnlaceReels;

    try {
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
      if (response.statusCode == 200) {
        print('Service reel insertado correctamenre');
        int idReel = response.data;

        return idReel;
      } else {
        throw Exception(
            'Error en la solicitud en insert service Reel: ${response.statusCode}');
      }
    } catch (error) {
      print('Ha ocurrido un error $error');
      throw Exception('Error de conexión: $error');
    }
  }
}
