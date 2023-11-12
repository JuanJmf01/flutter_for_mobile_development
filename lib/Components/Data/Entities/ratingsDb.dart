import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/ratingsTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

/// The `RatingsDb` class provides methods for saving, retrieving, updating, and deleting ratings data
/// from a MySQL database.

class RatingsDb {
  /// The function `saveRating` checks if a rating already exists and either updates it or inserts a new
  /// rating accordingly.
  ///
  /// Args:
  ///   rating (RatingsCreacionTb): The rating object that needs to be saved.
  ///   existeRating (bool): A boolean value indicating whether a rating already exists or not.
  static Future<void> saveRating(
      RatingsCreacionTb rating, bool existeRating, String url) async {
    if (existeRating) {
      print('existe in save2');
      await updateRatign(rating, url);
    } else {
      print('no existe in save2');
      await insertRating(rating, url);
    }
  }

  /// The function `insertRating` sends a POST request to a specified URL with a JSON-encoded data object,
  ///
  /// Args:
  ///   rating (RatingsCreacionTb): The parameter "rating" is an object of type "RatingsCreacionTb".
  static Future<void> insertRating(RatingsCreacionTb rating, String url) async {
    Dio dio = Dio();
    Map<String, dynamic> data = {};

    if (url == MisRutas.rutaRatings) {
      data = rating.toMapProductRatings();
    } else if (url == MisRutas.rutaServiceRatings) {
      data = rating.toMapServiceRatings();
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
  ///   idProServicio (int): The parameter `idProServicio` is an integer that represents the ID of a product. It
  /// is used to fetch the reviews for a specific product.
  ///
  /// Returns:
  ///   a Future that resolves to a List of Map<String, dynamic> objects.
  static Future<List<Map<String, dynamic>>> getReviewsByProducto(
      int idProServicio, Type objectType) async {
    Dio dio = Dio();
    String url = '';
    if (objectType == ProductoTb) {
      url = '${MisRutas.rutaRatingsByProducto}/$idProServicio';
    } else if (objectType == ServicioTb) {
      url = '${MisRutas.rutaRatingsByServicio}/$idProServicio';
    }

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
        throw Exception(
            'Error en la respuesta getReviewsByProducto: ${response.statusCode}');
      }
    } catch (error) {
      print('No hay reviews que mostrar getReviewsByProducto');
      return [];
    }
  }

  /// The function `updateRating` update a rating in a database by sending a PATCH request
  /// with the updated ratings data.
  ///
  /// Args:
  ///   rating (RatingsCreacionTb): The parameter "rating" is an object of type "RatingsCreacionTb".
  static Future<void> updateRatign(RatingsCreacionTb rating, String url) async {
    Dio dio = Dio();
    Map<String, dynamic> data = {};

    if (url == MisRutas.rutaRatings) {
      data = rating.toMapProductRatings();
    } else if (url == MisRutas.rutaServiceRatings) {
      print("SI ENTROO : $url");
      print("RATING : $rating");
      data = rating.toMapServiceRatings();
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
        print('Rating actualizado correctamente');
        print(response.data);
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexioon: $error');
    }
  }

  /// The function `getRatingByProductoAndUsuario` retrieves a rating by the given user ID and product ID
  /// using a GET request.
  ///
  /// Args:
  ///   idUsuario (int): The parameter "idUsuario" represents the ID of the user.
  ///   idProducto (int): The parameter "idProducto" is an integer that represents the ID of a product.
  ///
  /// Returns:
  ///   a Future object that resolves to a RatingsCreacionTb object.
  static Future<RatingsCreacionTb?> getRatingByProServicioAndUsuario(
      int idUsuario, int idProducto, String url) async {
    Dio dio = Dio();
    Map<String, dynamic> data = {};
    print('idUsuario: $idUsuario');
    print('idProducto: $idProducto');
    print('URL: $url');

    if (url == MisRutas.rutaRatingsByProductoAndUser) {
      data = {'idUsuario': idUsuario, 'idProducto': idProducto};
    } else if (url == MisRutas.rutaRatingsByServiceAndUser) {
      print("ENTRA 2: $idUsuario ; $idProducto");
      data = {'idUsuario': idUsuario, 'idServicio': idProducto};
    }

    try {
      Response response = await dio.get(
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
        RatingsCreacionTb? rating;
        if (url == MisRutas.rutaRatingsByProductoAndUser) {
          rating = RatingsCreacionTb.fromJsonProductRatings(response.data);
        } else if (url == MisRutas.rutaRatingsByServiceAndUser) {
          rating = RatingsCreacionTb.fromJsonServiceRatings(response.data);
        }
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

  //Almacenamos en un arreglo 'starCounts' la cantidad de calificaciones por cada estrella
  //Posicion 0: Cantidad de calificaciones por 5 estrellas
  //Posicion 1: Cantidad de calificaciones por 4 estrellas
  //...
  //Posicion 4: Cantidad de calificaciones por 1 estrella

  /// The `getStarCounts` function retrieves the star count for a product ID that looks like this
  ///  if a product has 4 different ratings with stars 5, 4, 4, 1, the result will be:
  ///
  /// ```JSON
  ///[
  ///  {
  ///   "count": 1, //(Only one person rated 5 stars)
  ///   "ratings": 5
  ///  },
  ///  {
  ///   "count": 2, //(two people rated 4 stars)
  ///   "ratings": 4
  ///  },
  ///  {
  ///   "count": 1, //(Only one person rated 1 stars)
  ///   "ratings": 1
  ///  }
  ///]
  /// ```
  ///
  /// Args:
  ///   idProducto (int): The parameter `idProducto` is an integer that represents the ID of a product.
  ///
  /// Returns:
  ///   a Future object that resolves to a List of integers

  static Future<List<int>> getStarCounts(
      int idProServicio, Type objectType) async {
    Dio dio = Dio();
    String url = '';

    if (objectType == ProductoTb) {
      url = '${MisRutas.rutaRatingsCountByProducto}/$idProServicio';
    } else if (objectType == ServicioTb) {
      url = '${MisRutas.rutaServerRatingsCountByServicio}/$idProServicio';
    }

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
  static Future<void> deleteRatingsByProServicio(
      int idProductom, String url) async {
    Dio dio = Dio();

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

  static Future<bool> checkRatingExists(
      int idProservicio, int idUsuario, String url) async {
    Dio dio = Dio();
    Map<String, dynamic> data = {};

    if (url == MisRutas.rutaRatingsIfExistRating) {
      data = {'idUsuario': idUsuario, 'idProducto': idProservicio};
    } else if (url == MisRutas.rutaServiceRatingsIfExistRating) {
      data = {'idUsuario': idUsuario, 'idServicio': idProservicio};
    }

    try {
      Response response = await dio.get(
        url,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print('responseData_: ${response.data}');

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
