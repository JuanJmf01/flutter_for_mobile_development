import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/ratingsTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';


/// The `RatingsDb` class provides methods for saving, retrieving, updating, and deleting ratings from a
/// database. these ratings comes from services or products.
class RatingsDb {

  /// The function `saveRating` checks if a rating already exists and either updates it or inserts a new
  /// rating based on the result.
  /// 
  /// Args:
  ///   rating (RatingsCreacionTb): The rating object that needs to be saved.
  ///   existeRating (bool): A boolean value indicating whether a rating already exists or not.
  ///   url (String): The `url` parameter is a string that represents the URL where the rating will be
  /// saved or updated.
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


  /// The function `insertRating` is a static method that takes a `RatingsCreacionTb` object and a URL as
  /// parameters, and sends a POST request to the specified URL with the rating data.
  /// 
  /// Args:
  ///   rating (RatingsCreacionTb): The parameter "rating" is an object of type "RatingsCreacionTb". It
  /// represents the rating data that needs to be inserted.
  ///   url (String): The `url` parameter is a string that represents the endpoint URL where the rating
  /// will be inserted. It can be either `MisRutas.rutaRatings` or `MisRutas.rutaServiceRatings`,
  /// depending on the type of rating being inserted.
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

  /// The function `getReviewsByProducto` retrieves reviews for a product or service based on the
  /// provided ID and object type.
  /// 
  /// Args:
  ///   idProServicio (int): The id of the product or service for which you want to retrieve reviews.
  ///   objectType (Type): The `objectType` parameter is the type of object for which you want to
  /// retrieve reviews. It can be either `ProductoTb` or `ServicioTb`.
  /// 
  /// Returns:
  ///   a Future object that resolves to a List of Map<String, dynamic>.
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

  /// The function `updateRating` is a static method that takes a `RatingsCreacionTb` object and a URL
  /// as parameters, and sends a PATCH request to the specified URL with the data from the
  /// `RatingsCreacionTb` object.
  /// 
  /// Args:
  ///   rating (RatingsCreacionTb): The parameter "rating" is an object of type "RatingsCreacionTb"
  /// which contains the data for the rating that needs to be updated.
  ///   url (String): The `url` parameter is a string that represents the URL endpoint where the rating
  /// data will be updated. It can be either `MisRutas.rutaRatings` or `MisRutas.rutaServiceRatings`.
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


  /// The function `getRatingByProServicioAndUsuario` retrieves a rating based on the user ID, product
  /// ID, and URL provided.
  /// 
  /// Args:
  ///   idUsuario (int): The `idUsuario` parameter represents the user ID.
  ///   idProducto (int): The parameter `idProducto` represents the ID of a product or service. It is
  /// used to identify a specific product or service for which the rating is being retrieved.
  ///   url (String): The `url` parameter is a string that represents the URL endpoint for the API
  /// request. It is used to determine which API route to call.
  /// 
  /// Returns:
  ///   a Future object that resolves to a RatingsCreacionTb object or null.
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


  /// The function `deleteRatingsByProServicio` sends a DELETE request to the specified URL to delete
  /// ratings associated with a product, and handles different response statuses accordingly.
  /// 
  /// Args:
  ///   idProductom (int): The id of the product or service for which the ratings need to be deleted.
  ///   url (String): The URL where the ratings will be deleted from.
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

  /// The function `checkRatingExists` checks if a rating exists for a given product or service.
  /// 
  /// Args:
  ///   idProservicio (int): The id of the product or service for which we want to check if a rating
  /// exists.
  ///   idUsuario (int): The user ID.
  ///   url (String): The URL endpoint to send the request to.
  /// 
  /// Returns:
  ///   a `Future<bool>`.
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
