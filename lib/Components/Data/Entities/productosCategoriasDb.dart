import 'package:etfi_point/Components/Data/DB.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoCategoriaTb.dart';
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

  static Future<int> insert(ProductoCategoriaTb productoCategoria) async {
    Database database = await DB.openDB();

    return database.insert(tableName, productoCategoria.toMap());
  }


  static Future<List<int>> obtenerIdCategoriasPorIdProducto(int idProducto) async {
  Database database = await DB.openDB();
  List<Map<String, dynamic>> resultado = await database.query(
    tableName,
    columns: ['idCategoria'],
    where: 'idProducto = ?',
    whereArgs: [idProducto],
  );

  List<int> idCategorias = resultado.map((map) => map['idCategoria'] as int).toList();
  return idCategorias;
}




}



