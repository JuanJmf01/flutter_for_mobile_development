import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:sqflite/sqflite.dart';

class subCategoriaDb {
  static const tableName = "subCategorias";
  static Future<void> createTableSubCategorias(Database db) async {
    await db.execute("CREATE TABLE $tableName (\n"
        "idSubCategoria INTEGER PRIMARY KEY, \n"
        "idCategoria INTEGER, \n"
        "nombre TEXT NOT NULL,"
        "FOREIGN KEY (idCategoria) REFERENCES ${CategoriaDb.tableName} (idCategoria) \n"
        ")");
  }
}
