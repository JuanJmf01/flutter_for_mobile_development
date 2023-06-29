import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosCategoriasDb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:sqflite/sqflite.dart';

class CategoriaDb {
  static const tableName = "categorias";
  static Future<void> createTableCategorias(Database db) async {
    await db.execute(
        "CREATE TABLE $tableName (idCategoria INTEGER PRIMARY KEY, nombre TEXT, imagePath TEXT)");
  }


  //Obtenemos todas la categorias en una lista de un producto especifico
  static Future<List<CategoriaTb>> getCategoriasSeleccionadas(
      int idProducto) async {
    try {
      //Obtenemos una lista de idCategorias que pertenezcan unicamnete a idProducto
      final idCategoriasDeProducto =
          await ProductosCategoriasDb.getIdCategoriasPorIdProducto(idProducto);
      final categoriasSeleccionadas = <CategoriaTb>[];

      //Recorremos 'idCategoriasDeProducto' y en cada ciclo llamamos al metodo 'obtenerCategoriasPorId'
      //'obtenerCategoriasPorId' nos retorna una categoria (nombre de la categoria) y lo guardamos en la lista 'categoriasSeleccionadas'
      for (int idCategoria in idCategoriasDeProducto) {
        final categoria = await getCategoria(idCategoria);

        categoriasSeleccionadas.add(categoria);
      }

      return categoriasSeleccionadas;
    } catch (error) {
      print('Error al obtener las categorías seleccionadas: $error');
      return [];
    }
  }

  // -------- Consultas despues de la migracion a mySQL --------- //

// Función para obtener las categorías desde la API
  static Future<List<CategoriaTb>> getCategorias() async {
    try {
      Dio dio = Dio();

      Response response = await dio.get(MisRutas.rutaCategorias);
      print('llega a getCate');
      if (response.statusCode == 200) {
        print('llega al if getCate');

        List<CategoriaTb> categorias = List<CategoriaTb>.from(
          response.data
              .map((categoriaData) => CategoriaTb.fromJson(categoriaData)),
        );
        return categorias;
      } else {
        // Si hay un error en la respuesta
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Si ocurre un error durante la solicitud
      print('Error: $error');
      return [];
    }
  }

  //Funcion para obtener una unica categoria por idCategoria
  static Future<CategoriaTb> getCategoria(int idCategoria) async {
    try {
      Dio dio = Dio();
      Response response =
          await dio.get('${MisRutas.rutaCategorias}/$idCategoria');

      if (response.statusCode == 200) {
        return CategoriaTb.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch category');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
