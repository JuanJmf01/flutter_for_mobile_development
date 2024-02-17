import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Data/models/Publicaciones/noEnlaces/ratingsPublicacionesTb.dart';
import 'package:etfi_point/Data/models/newsFeedTb.dart';
import 'package:etfi_point/config/routes/routes.dart';

class RatingsFotoAndReelPublicacionDb {
  static Future<void> saveRating(int idPublicacion, int idUsuario,
      RatingsPublicacionesTb rating, Type objectType) async {
    bool existeRating = await checkRatingPublicacionIfExists(
        idPublicacion, idUsuario, objectType);

    if (existeRating) {
      print('Ya existe');
      updateLikePublicacion(rating, objectType);
    } else {
      print('No existe');
      await insertRatingsPublicacion(rating, objectType);
    }
  }

  static Future<int> insertRatingsPublicacion(
      RatingsPublicacionesTb rating, Type objectType) async {
    Dio dio = Dio();
    Map<String, dynamic> data = {};
    String url = '';

    if (objectType == NeswFeedPublicacionesTb) {
      url = MisRutas.rutaRatingsFotoPublicacion;
      data = rating.toMapRatingFotoPublicacion();
    } else if (objectType == NeswFeedReelPublicacionTb) {
      url = MisRutas.rutaRatingsReelPublicacion;
      data = rating.toMapRatingReelPublicacion();
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
        print('ratingPublicacion insertado correctamente');
        int idRatingEnlaceProservicio = response.data;
        return idRatingEnlaceProservicio;
      } else {
        throw Exception(
            'Error en la solicitud en ratingPublicacion: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
      throw Exception('Error de conexión: $error');
    }
  }

  static Future<bool> checkRatingPublicacionIfExists(
      int idPublicacion, int idUsuario, Type objectType) async {
    Dio dio = Dio();
    Map<String, dynamic> data = {};

    String url = '';

    if (objectType == NeswFeedPublicacionesTb) {
      url = MisRutas.rutaCheckRatingFotoPublicacionIfExist;
      data = {'idUsuario': idUsuario, 'idFotoPublicacion': idPublicacion};
    } else if (objectType == NeswFeedReelPublicacionTb) {
      url = MisRutas.rutaCheckRatingReelPublicacionIfExist;
      data = {'idUsuario': idUsuario, 'idReelPublicacion': idPublicacion};
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

  static Future<void> updateLikePublicacion(
      RatingsPublicacionesTb rating, Type objectType) async {
    Dio dio = Dio();
    Map<String, dynamic> data = {};
    String url = '';

    if (objectType == NeswFeedPublicacionesTb) {
      data = rating.toMapRatingFotoPublicacion();
      url = MisRutas.rutaUpdateLikeFotoPublicacion;
    } else if (objectType == NeswFeedReelPublicacionTb) {
      data = rating.toMapRatingReelPublicacion();
      url = MisRutas.rutaUpdateLikeReelPublicacion;
    }

    print("NUEVO LIke: ${rating.likes}");

    try {
      Response response = await dio.patch(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('Likepublicaciones actualizado correctamente');
        print(response.data);
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexioon: $error');
    }
  }
}
