import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Data/models/proServicioSubCategoriaTb.dart';
import 'package:etfi_point/Data/models/productoTb.dart';
import 'package:etfi_point/Data/models/servicioTb.dart';
import 'package:etfi_point/config/routes/routes.dart';

/// The `ProServiceSubCategoriasDb` class contains static methods for fetching, inserting, and deleting
/// subcategories related to a product or service.
class ProServiceSubCategoriasDb {
  /// The function `insertSubCategoriasSeleccionadas` is a static method that inserts selected
  /// subcategories for a product or service into the database using the Dio package in Dart.
  ///
  /// Args:
  ///   productoSubCategoria (ProServicioSubCategoriaTb): An instance of the class
  /// ProServicioSubCategoriaTb, which represents a product or service subcategory.
  ///   objectType (Type): The `objectType` parameter is a `Type` object that represents the type of the
  /// object being inserted. It can be either `ProductoTb` or `ServicioTb`.
  static Future<void> insertSubCategoriasSeleccionadas(
      ProServicioSubCategoriaTb productoSubCategoria, Type objectType) async {
    Dio dio = Dio();
    Map<String, dynamic> data = {};
    String url = '';
    if (objectType == ProductoTb) {
      url = MisRutas.rutaProductosSubCategorias;
      data = productoSubCategoria.toMapProducto();
    } else if (objectType == ServicioTb) {
      url = MisRutas.rutaServiciosSubCategorias;
      data = productoSubCategoria.toMapServicio();
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
        print('proServiceSubCategoria insertado correctamente (print)');
        print(response.data);
        // Realiza las operaciones necesarias con la respuesta
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      // Ocurrió un error en la conexión
      print('Error de conexión: $error');
    }
  }

  /// The function `deleteProServicioSubCategories` sends a DELETE request to a specified URL to delete
  /// subcategories of a ProServicio, and returns a boolean indicating whether the deletion was
  /// successful.
  ///
  /// Args:
  ///   idProServicio (int): The id of the ProServicio (professional service) for which you want to
  /// delete the subcategories.
  ///   url (String): The `url` parameter is the endpoint URL where the DELETE request will be sent to
  /// delete the ProServicioSubCategories.
  ///
  /// Returns:
  ///   a Future<bool>.
  static Future<bool> deleteProServicioSubCategories(
      int idProServicio, String url) async {
    Dio dio = Dio();

    try {
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 202) {
        print('ProServiciosSubCategorias eliminados correctamente');
        return true;
        // Realiza las operaciones necesarias con la respuesta
      } else if (response.statusCode == 404) {
        print('ProServicio no encontrado en deleteProServicioSubCategories');
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      // Ocurrió un error en la conexión
      print('Error de conexión: $error');
    }
    return false;
  }
}
