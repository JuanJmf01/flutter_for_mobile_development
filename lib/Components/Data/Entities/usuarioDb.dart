import 'package:etfi_point/Components/Data/DB.dart';
import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDb {
  static const tableName = "usuarios";
  static Future<void> createTableUsuarios(Database db) async {
    await db.execute("CREATE TABLE $tableName (\n"
        "idUsuario INTEGER PRIMARY KEY,\n"
        "nombres TEXT NOT NULL,\n"
        "apellidos TEXT NOT NULL,\n"
        "email TEXT NOT NULL,\n"
        "numeroCelular TEXT NOT NULL,\n"
        "domiciliario INTEGER,\n" //Bool (1 or 0)
        "password TEXT NOT NULL\n"
        ")");
  }

  static Future<int> insert(UsuarioTb usuario) async {
    Database database = await DB.openDB();

    return database.insert(tableName, usuario.toMap());
  }
}
