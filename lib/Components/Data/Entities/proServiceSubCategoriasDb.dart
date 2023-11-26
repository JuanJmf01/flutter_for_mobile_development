import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioSubCategoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

/// The `ProServiceSubCategoriasDb` class contains static methods for fetching, inserting, and deleting
/// subcategories related to a product or service.
class ProServiceSubCategoriasDb {

  /// The function `getProServiceSelectedSubCategoies` retrieves a list of subcategories based on the
  /// given `idProServicio` and `objectType` parameters.
  /// 
  /// Args:
  ///   idProServicio (int): The id of the professional service for which you want to retrieve the
  /// selected subcategories.
  ///   objectType (Type): The `objectType` parameter is a `Type` object that represents the type of
  /// object for which we want to retrieve the selected subcategories. It can be either `ProductoTb` or
  /// `ServicioTb`.
  /// 
  /// Returns:
  ///   a Future object that resolves to a List of integers.
  static Future<List<int>> getProServiceSelectedSubCategoies(
      int idProServicio, Type objectType) async {
    Dio dio = Dio();
    String url = '';
    if (objectType == ProductoTb) {
      url = '${MisRutas.rutaProductosSubCategorias}/$idProServicio';
    } else if (objectType == ServicioTb) {
      url = '${MisRutas.rutaServiciosSubCategorias}/$idProServicio';
    }

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        List<int> idSubCategorias = [];

        for (var productoSubCategoria in response.data) {
          int idSubCategoria = productoSubCategoria['idSubCategoria'];
          idSubCategorias.add(idSubCategoria);
        }

        return idSubCategorias;
      } else {
        throw Exception('Failed to fetch product categories');
      }
    } catch (error) {
      throw Exception('Error de conexión: $error');
    }
  }

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
  static Future<bool> deleteProServicioSubCategories(int idProServicio, String url) async {
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
