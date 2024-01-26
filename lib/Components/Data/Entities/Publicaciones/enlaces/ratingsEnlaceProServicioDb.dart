import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/enlaces/ratingsEnlaceProServicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';

import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class RatingsEnlaceProServicioDb {
  static Future<void> saveRating(int idEnlaceProservicio, int idUsuario,
      RatingsEnlaceProServicioTb rating, Type objectType) async {
    bool existeRating = await checkRatingEnlaceProServicioIfExists(
        idEnlaceProservicio, idUsuario, objectType);

    if (existeRating) {
      print('Ya existe');
      updateLikeEnlaceProServicio(rating, objectType);
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

  static Future<bool> checkRatingEnlaceProServicioIfExists(
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

  static Future<void> updateLikeEnlaceProServicio(
      RatingsEnlaceProServicioTb rating, Type objectType) async {
    Dio dio = Dio();
    Map<String, dynamic> data = {};
    String url = '';

    if (objectType == NewsFeedProductosTb) {
      data = rating.toMapEnlaceProducto();
      url = MisRutas.rutaUpdateLikeEnlaceProducto;
    } else if (objectType == NewsFeedServiciosTb) {
      data = rating.toMapEnlaceServicio();
      url = MisRutas.rutaUpdateLikeEnlaceServicio;
    } else if (objectType == NeswFeedReelProductTb) {
      data = rating.toMapEnlaceVidProducto();
      url = MisRutas.rutaUpdateLikeEnlaceProductReel;
    } else if (objectType == NeswFeedReelServiceTb) {
      data = rating.toMapEnlaceVidServicio();
      url = MisRutas.rutaUpdateLikeEnlaceServiceReel;
    }

    try {
      Response response = await dio.patch(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('LikeEnlaceProServicio actualizado correctamente');
        print(response.data);
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexioon: $error');
    }
  }
}
