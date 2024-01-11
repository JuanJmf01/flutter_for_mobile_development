import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/enlaces/ratingsEnlaceProServicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';

import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class RatingsEnlaceProServicioDb {
  static Future<void> saveRating(int idProServicio, int idEnlaceProservicio,
      int idUsuario, RatingsEnlaceProServicioTb rating, Type objectType) async {
    bool existeRating = await checkRatingEnlaceProServicioIfExists(
        idProServicio, idEnlaceProservicio, idUsuario, objectType);

    if (existeRating) {
      print('Ya existe');
      //Actualizar o eliminar
    } else {
      print('No existe');
      await insertRatingsEnlaceProServicio(rating, objectType);
    }
  }

  static Future<int> insertRatingsEnlaceProServicio(
      RatingsEnlaceProServicioTb rating, Type objectType) async {
    Dio dio = Dio();
    Map<String, dynamic> data = {};

    String url = '';
    if (objectType == NewsFeedProductosTb) {
      url = MisRutas.rutaRatingsEnlaceProducto;
      data = rating.toMapEnlaceProducto();
    } else if (objectType == NewsFeedServiciosTb) {
      url = MisRutas.rutaRatingsEnlaceServicio;
      data = rating.toMapEnlaceServicio();
    } else if (objectType == NeswFeedReelProductTb) {
      url = MisRutas.rutaRatingsEnlaceVidProducto;
      data = rating.toMapEnlaceVidProducto();
    } else if (objectType == NeswFeedReelServiceTb) {
      url = MisRutas.rutaRatingsEnlaceVidServicio;
      data = rating.toMapEnlaceVidServicio();
    }

    try {
      Response response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode == 200) {
        print('ratingsEnlaceProServicio insertado correctamente');
        int idRatingEnlaceProservicio = response.data;
        return idRatingEnlaceProservicio;
      } else {
        throw Exception(
            'Error en la solicitud en ratingsEnlaceProServicio: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
      throw Exception('Error de conexión: $error');
    }
  }

  static Future<bool> checkRatingEnlaceProServicioIfExists(int idProServicio,
      int idEnlaceProServicio, int idUsuario, Type objectType) async {
    Dio dio = Dio();
    Map<String, dynamic> data = {};

    String url = '';

    if (objectType == NewsFeedProductosTb) {
      url = MisRutas.rutaCheckRatingEnlaceProductoIfExist;
      data = {'idUsuario': idUsuario, 'idEnlaceProducto': idEnlaceProServicio};
    } else if (objectType == NewsFeedServiciosTb) {
      url = MisRutas.rutaCheckRatingEnlaceServicioIfExist;
      data = {'idUsuario': idUsuario, 'idEnlaceServicio': idEnlaceProServicio};
    } else if (objectType == NeswFeedReelProductTb) {
      url = MisRutas.rutaCheckRatingEnlaceVidProductIfExist;
      data = {
        'idUsuario': idUsuario,
        'idProductEnlaceReel': idEnlaceProServicio
      };
    } else if (objectType == NeswFeedReelServiceTb) {
      url = MisRutas.rutaCheckRatingEnlaceVidServiceIfExist;
      data = {
        'idUsuario': idUsuario,
        'idServiceEnlaceReel': idEnlaceProServicio
      };
    }

    try {
      Response response = await dio.get(
        url,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('existe in checkRatingExists: ${response.data}');
        return response.data;
      } else {
        print('No existe in checkRatingExists');
        return false;
      }
    } catch (error) {
      print('Error de conexión: $error');
      throw Exception('Error: $error');
    }
  }
}
