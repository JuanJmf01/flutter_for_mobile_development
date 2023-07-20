import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/ratingsTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

/// The `RatingsDb` class provides methods for saving, retrieving, updating, and deleting ratings data
/// from a MySQL database.

class RatingsDb {
  // -------- Consultas despues de la migracion a mySQL --------- //

  /// The function `saveRating` checks if a rating already exists and either updates it or inserts a new
  /// rating accordingly.
  ///
  /// Args:
  ///   rating (RatingsCreacionTb): The rating object that needs to be saved.
  ///   existeRating (bool): A boolean value indicating whether a rating already exists or not.
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

  /// The function `insertRating` sends a POST request to a specified URL with a JSON-encoded data object,
  ///
  /// Args:
  ///   rating (RatingsCreacionTb): The parameter "rating" is an object of type "RatingsCreacionTb".
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
        //print(response.data);
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }

  /// The function `getReviewsByProducto` retrieves a list of reviews for a given product ID using the Dio
  /// package in Dart.
  ///
  /// Args:
  ///   idProducto (int): The parameter `idProducto` is an integer that represents the ID of a product. It
  /// is used to fetch the reviews for a specific product.
  ///
  /// Returns:
  ///   a Future that resolves to a List of Map<String, dynamic> objects.
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
        //print(reviews);

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

  /// The function `updateRating` update a rating in a database by sending a PATCH request
  /// with the updated ratings data.
  ///
  /// Args:
  ///   rating (RatingsCreacionTb): The parameter "rating" is an object of type "RatingsCreacionTb".
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

  /// The function `getRatingByProductoAndUsuario` retrieves a rating by the given user ID and product ID
  /// using a POST request.
  ///
  /// Args:
  ///   idUsuario (int): The parameter "idUsuario" represents the ID of the user.
  ///   idProducto (int): The parameter "idProducto" is an integer that represents the ID of a product.
  ///
  /// Returns:
  ///   a Future object that resolves to a RatingsCreacionTb object.
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

  /// The function checks if a rating exists for a given user and product.
  ///
  /// Args:
  ///   idUsuario (int): The id of the user for whom we want to check if a rating exists or not.
  ///   idProducto (int): The id of the product for which we want to check if a rating exists or not.
  ///
  /// Returns:
  ///   a `Future<bool>`.
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

  /// The function `getStarCounts` retrieves the star counts for a given product ID from an API endpoint.
  ///
  /// Args:
  ///   idProducto (int): The parameter `idProducto` is an integer that represents the ID of a product.
  ///
  /// Returns:
  ///   a Future object that resolves to a List of integers.
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

  /// The function `deleteRatings` sends a DELETE request to a specified URL with the given `idProducto`
  /// and handles the response accordingly.
  ///
  /// Args:
  ///   idProducto (int): The parameter "idProducto" represents the ID of the product for which the
  /// ratings need to be deleted.
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
