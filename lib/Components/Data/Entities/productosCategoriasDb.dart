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
  static Future<List<int>> getIdCategoriasPorIdProducto(int idProducto) async {
    try {
      Dio dio = Dio();

      Response response =
          await dio.get('${MisRutas.rutaProductosCategorias}/$idProducto');

      if (response.statusCode == 200) {
        ProductoCategoriaTb productoCategoria =
            ProductoCategoriaTb.fromJson(response.data);
        int idCategoria = productoCategoria.idCategoria;

        return [idCategoria];
      } else {
        throw Exception('Failed to fetch product categories');
      }
    } catch (error) {
      throw Exception('Error en getIdCategoriasPorIdProducto: $error');
    }
  }
}
