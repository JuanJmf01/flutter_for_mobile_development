import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/noEnlaces/publicacionesTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class PublicacionesDb {
  /* ------ Consultas para publicaciones tipo imagenes ------ */

  static Future<int> insertFotoPublicacion(
      PublicacionesCreacionTb publicacion) async {
    Dio dio = Dio();

    Map<String, dynamic> data = publicacion.toMap();
    String url = MisRutas.rutaFotosPublicaciones;

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

  /* ------ Consultas para publicaciones tipo reels ------ */

  static Future<int> insertReelPublicacion(ReelCreacionTb reel) async {
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

  /* ------ Consultas generales para foto publicacion y para reel publicacion ------ */

  static Future<List<int>> getIdsPublicacionesSeguidas(
      int idUsuarioSeguidor, Type objectType) async {
    Dio dio = Dio();

    String url = '';
    String claveIdPublicacion = '';

    if (objectType == ReelCreacionTb) {
      url = '${MisRutas.rutaIdsReelsBySeguidor}/$idUsuarioSeguidor';
      claveIdPublicacion = 'idReelPublicacion';
    } else if (objectType == PublicacionesCreacionTb) {
      url = '${MisRutas.rutaPublicacionesBySeguidor}/$idUsuarioSeguidor';
      claveIdPublicacion = 'idFotoPublicacion';
    }

    if (url != '' && claveIdPublicacion != '') {
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
              .map((dynamic publicacion) =>
                  publicacion[claveIdPublicacion] as int)
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
