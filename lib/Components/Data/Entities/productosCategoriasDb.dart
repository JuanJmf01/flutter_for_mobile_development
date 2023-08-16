import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

/// The `ProductosCategoriasDb` class contains methods for inserting, retrieving, and deleting product
/// categories from a database. Products categories contains the categories that each product has
/// since each product can have many categories

class ProductosCategoriasDb {
  // -------- Consultas despues de la migracion a mySQL --------- //

  /// The function `insertCategoriasSeleccionadas` sends a POST request to a specified URL with the data
  /// of a `ProductoCategoriaTb` object and handles the response.
  ///
  /// Args:
  ///   productoCategoria (ProductoCategoriaTb): An instance of the class ProductoCategoriaTb, which
  /// represents a product category.
  static Future<void> insertCategoriasSeleccionadas(
      ProductoCategoriaTb productoCategoria) async {
    Dio dio = Dio();
    Map<String, dynamic> data = productoCategoria.toMap();
    String url = MisRutas.rutaProductosCategorias;

    try {
      Response response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('productoCategoria insertado correctamente (print)');
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

  /// The function `getIdCategoriasPorIdProducto` retrieves a list of category IDs associated with a given
  /// product ID.
  ///
  /// Args:
  ///   idProducto (int): The parameter `idProducto` is an integer that represents the ID of a product.
  ///
  /// Returns:
  /// a future object that resolves to a list of integers that are the category IDs associated with a product ID
  static Future<List<int>> getIdCategoriasPorIdProducto(int idProducto) async {
    try {
      Dio dio = Dio();
      Response response =
          await dio.get('${MisRutas.rutaProductosCategorias}/$idProducto');

      if (response.statusCode == 200) {
        List<int> idCategorias = [];

        if (response.data is List) {
          for (var productoCategoria in response.data) {
            int idCategoria = productoCategoria['idCategoria'];
            idCategorias.add(idCategoria);
          }
        }

        return idCategorias;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to fetch product categories');
      }
    } catch (error) {
      throw Exception('Error de conexión: $error');
    }
  }

  /// The `deleteProductCategories` function sends a DELETE request to a specific URL to delete a product's categories
  /// and returns a boolean value indicating whether the deletion was successful. /// product category, and returns a boolean indicating whether the deletion was successful.
  ///
  /// Args:
  ///   idProducto (int): The parameter `idProducto` is the ID of the product for which you want to
  /// delete the categories.
  ///
  /// Returns:
  ///   a Future<bool>.
  static Future<bool> deleteProductCategories(int idProducto) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaProductosCategorias}/$idProducto';

    try {
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 202) {
        print('ProductosCategorias eliminados correctamente');
        return true;
        // Realiza las operaciones necesarias con la respuesta
      } else if (response.statusCode == 404) {
        print('Producto no encontrado en deleteProductosCategorias');
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
