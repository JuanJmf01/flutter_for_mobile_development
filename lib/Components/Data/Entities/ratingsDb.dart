import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/ratingsTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class RatingsDb {
  static const tableName = "ratings";

  // -------- Consultas despues de la migracion a mySQL --------- //

  static Future<void> saveRating(
      RatingsCreacionTb rating, bool existeRating) async {
    if (existeRating) {
      print('existe in save2');
      await updateRatign(rating);
    } else {
      print('no existe in save2');
      await insertRating(rating);
    }
  }

  static Future<void> insertRating(RatingsCreacionTb rating) async {
    Dio dio = Dio();
    String url = MisRutas.rutaRatings;

    Map<String, dynamic> data = rating.toMap();

    try {
      Response response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode == 200) {
        print('Rating insertado correctamente (print)');
        print(response.data);
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }

  static Future<List<Map<String, dynamic>>> getReviewsByProducto(
      int idProducto) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaRatingsByProducto}/$idProducto';

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        List<Map<String, dynamic>> reviews = responseData.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList();
        print(reviews);

        return reviews;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Error en la respuesta: ${response.statusCode}');
      }
    } catch (error) {
      print('No hay reviews que mostrar');
      return [];
    }
  }

  static Future<void> updateRatign(RatingsCreacionTb rating) async {
    Dio dio = Dio();
    String url = MisRutas.rutaRatings;
    Map<String, dynamic> data = rating.toMap();

    try {
      Response response = await dio.patch(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('Rating actualizado correctamente');
        print(response.data);
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }

  static Future<RatingsCreacionTb?> getRatingByProductoAndUsuario(
      int idUsuario, int idProducto) async {
    Dio dio = Dio();
    String url = MisRutas.rutaRatingsByProductoAndUser;
    print('idUsuario: $idUsuario');
    print('idProducto: $idProducto');

    try {
      Map<String, dynamic> data = {
        'idUsuario': idUsuario,
        'idProducto': idProducto
      };

      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          responseType: ResponseType.json,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        RatingsCreacionTb rating = RatingsCreacionTb.fromJson(response.data);
        print(rating);
        return rating;
      } else if (response.statusCode == 404) {
        return null; // Retorna null en caso de rating no encontrado
      } else {
        throw Exception('Error en la respuesta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en la solicitud: $error');
      return null; // Retorna null en caso de error en la solicitud
    }
  }

  static Future<bool> existOrNotRating(int idUsuario, int idProducto) async {
    RatingsCreacionTb? rating =
        await getRatingByProductoAndUsuario(idUsuario, idProducto);

    if (rating != null) {
      print('Existe rating');
      return true;
    } else {
      print('No existe rating');
      return false;
    }
  }

  //Almacenamos en un arreglo la cantidad de calificaciones por cada estrella
  //Posicion 0: Cantidad de calificaciones por 5 estrellas
  //Posicion 1: Cantidad de calificaciones por 4 estrellas
  //...
  //Posicion 4: Cantidad de calificaciones por 1 estrella

  static Future<List<int>> getStarCounts(int idProducto) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaRatingsCountByProducto}/$idProducto';

    List<int> starCounts = List.filled(5, 0);

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        for (Map<String, dynamic> result in response.data) {
          int count = result['count'];
          int rating = result['ratings'];

          starCounts[5 - rating] = count;
        }
      } else {}
    } catch (error) {
      print('Error de conexión: $error');
    }

    //List<int> starCount2 = [5459,2839,1500,500,142];

    return starCounts;
  }

  static Future<void> deleteRatings(int idProducto) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaRatings}/$idProducto';

    try {
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 202) {
        print('Ratings eliminados correctamente');
      } else if (response.statusCode == 404) {
        print('Ratings no encontrado');
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }
}
