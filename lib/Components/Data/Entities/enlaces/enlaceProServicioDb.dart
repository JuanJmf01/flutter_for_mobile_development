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
      url = MisRutas.rutaEnlaceProductosByEnlaceProducto;
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

// Hacer pruebas
  static Future<List<int>> getEnlaceProServicioSeguidos(
      int idUsuarioSeguidor, Type objectType) async {
    Dio dio = Dio();

    String url = '';
    String claveIdEnlaceProducto = '';

    if (objectType == ProductoTb) {
      url = '${MisRutas.rutaEnlaceProductosSeguidos}/$idUsuarioSeguidor';
      claveIdEnlaceProducto = 'idEnlaceProducto';
    } else if (objectType == ServicioTb) {
      url = '${MisRutas.rutaEnlaceServiciosSeguidos}/$idUsuarioSeguidor';
      claveIdEnlaceProducto = 'idEnlaceServicio';
    }

    if (url != '' && claveIdEnlaceProducto != '') {
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
                  enlaceProducto[claveIdEnlaceProducto] as int)
              .toList();

          return usuariosSeguidos;
        } else if (response.statusCode == 404) {
          return [];
        } else {
          throw Exception('Error en la respuesta: ${response.statusCode}');
        }
      } catch (error) {
        print("Error: $error");
        return [];
      }
    } else {
      return [];
    }
  }
}
