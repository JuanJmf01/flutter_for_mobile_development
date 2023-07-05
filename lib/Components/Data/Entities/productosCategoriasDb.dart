import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:sqflite/sqflite.dart';

class ProductosCategoriasDb {
  static const tableName = "productosCategorias";
  static Future<void> createTableProductosCategorias(Database db) async {
    await db.execute("CREATE TABLE $tableName( \n"
        "idProducto INTEGER, \n"
        "idCategoria INTEGER, \n"
        "FOREIGN KEY (idProducto) REFERENCES productos(idProducto), \n "
        "FOREIGN KEY (idCategoria) REFERENCES categorias(idCategoria) \n "
        ")");
  }

  // -------- Consultas despues de la migracion a mySQL --------- //

  //Obtiene todos los idCategorias de productosCategorias que coincidan con idProducto

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

  //Retorna una lista de idCategorias (categorias) pertenecientes a un producto
 static Future<List<int>> getIdCategoriasPorIdProducto(int idProducto) async {
  print('imprimir idProducto: $idProducto');
  
  try {
    Dio dio = Dio();
    Response response = await dio.get('${MisRutas.rutaProductosCategorias}/$idProducto');
    
    print('dataaa: ${response.data}');
    
    if (response.statusCode == 200) {
      List<int> idCategorias = [];
      print('dataaa222: ${response.data}');
      
      if (response.data is List) {
        for (var productoCategoria in response.data) {
          int idCategoria = productoCategoria['idCategoria'];
          idCategorias.add(idCategoria);
        }
      }
      
      return idCategorias;
    } else if (response.statusCode == 404) {
      return []; // Devuelve una lista vacía si no hay categorías encontradas
    } else {
      throw Exception('Failed to fetch product categories');
    }
  } catch (error) {
    throw Exception('Error de conexión: $error');
  }
}


  static Future<bool> deleteProductosCategorias(int idProducto) async {
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
