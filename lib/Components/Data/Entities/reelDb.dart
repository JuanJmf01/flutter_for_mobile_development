import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/reelTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class ReelDb {
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

  static Future<int> insertOnlyReel(ReelCreacionTb reel) async {
    Dio dio = Dio();
    Map<String, dynamic> data = reel.toMap();
    String url = MisRutas.rutaOnlyReels;

    try {
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
      if (response.statusCode == 200) {
        print('only reel insertado correctamenre');
        int idReel = response.data;

        return idReel;
      } else {
        throw Exception(
            'Error en la solicitud en insert only Reel: ${response.statusCode}');
      }
    } catch (error) {
      print('Ha ocurrido un error $error');
      throw Exception('Error de conexión: $error');
    }
  }
}
