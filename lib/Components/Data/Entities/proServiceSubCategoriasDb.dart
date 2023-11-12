import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioSubCategoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class ProServiceSubCategoriasDb {
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
