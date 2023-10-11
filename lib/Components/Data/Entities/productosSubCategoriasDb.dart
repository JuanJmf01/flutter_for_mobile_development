import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioSubCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class ProductosSubCategoriasDb {
  static Future<List<int>> getProductSelectedSubCategoies(
      int idProducto) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaProductosSubCategorias}/$idProducto';

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

   static Future<void> insertSubCategoriasSeleccionadas(
      ProServicioSubCategoriaTb productoSubCategoria) async {

    Dio dio = Dio();
    Map<String, dynamic> data = productoSubCategoria.toMapProducto();
    String url = MisRutas.rutaProductosSubCategorias;

    try {
      Response response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('productoSubCategoria insertado correctamente (print)');
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

  static Future<bool> deleteProductSubCategories(int idProducto) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaProductosSubCategorias}/$idProducto';

    try {
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 202) {
        print('ProductosSubCategorias eliminados correctamente');
        return true;
        // Realiza las operaciones necesarias con la respuesta
      } else if (response.statusCode == 404) {
        print('Producto no encontrado en deleteProductosSubCategorias');
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
