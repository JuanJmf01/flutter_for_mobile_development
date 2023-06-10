import 'package:etfi_point/Components/Data/DB.dart';
import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDb {
  static const tableName = "usuarios";
  static Future<void> createTableUsuarios(Database db) async {
    await db.execute("CREATE TABLE $tableName (\n"
        "idUsuario INTEGER PRIMARY KEY,\n"
        "nombres TEXT, \n"
        "apellidos TEXT, \n"
        "email TEXT NOT NULL, \n"
        "numeroCelular TEXT, \n"
        "domiciliario INTEGER \n" //Bool (1 or 0)
        ")");
  }

  static Future<int> insert(UsuarioTb usuario) async {
    Database database = await DB.openDB();

    return database.insert(tableName, usuario.toMap());
  }

  //Buscar si existe un usuario por email
  static Future<bool> existsUserByEmail(String email) async {
    Database database = await DB.openDB();

    List<Map<String, dynamic>> results = await database.query(
      tableName,
      columns: ['idUsuario'],
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    return results.isNotEmpty;
  }


  static Future<int?> getIdUsuarioPorCorreo(String email) async {
  Database database = await DB.openDB();

  List<Map<String, dynamic>> result = await database.query(
    tableName,
    columns: ['idUsuario'],
    where: 'email = ?',
    whereArgs: [email],
  );

  if (result.isNotEmpty) {
    return result.first['idUsuario'];
  } else {
    return null;
  }
}



}
