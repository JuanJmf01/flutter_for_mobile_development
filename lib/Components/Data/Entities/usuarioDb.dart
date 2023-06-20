import 'package:etfi_point/Components/Data/DB.dart';
import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Inserta un usuario. De ser necesario utilizar el retorno del id del metodo
  static Future<int> insert(UsuarioCreacionTb usuario) async {
    Database database = await DB.openDB();

    return database.insert(tableName, usuario.toMap());
  }

  //Retorna toda la informacion de un usuario por idUsuario
  static Future<UsuarioTb> getUserById(int idUsuario) async {
    Database database = await DB.openDB();

    List<Map<String, dynamic>> result = await database.query(
      tableName,
      where: 'idUsuario = ?',
      whereArgs: [idUsuario],
    );

    if (result.isEmpty) {
      throw Exception('User not found');
    }

    return UsuarioTb.fromMap(result.first);
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

  // Busca un usuario por correo para retornar el id del usuario
  static Future<int> getIdUsuarioPorCorreo(String email) async {
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
      throw Exception('Usuario no encontrado');
    }
  }

  // Obtener idUsuario mediante el correo en firebase
  static Future<int> getIdUsuario() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String? email = FirebaseAuth.instance.currentUser?.email;
      if (email != null) {
        try {
          int idUsuario = await getIdUsuarioPorCorreo(email);
          return idUsuario;
        } catch (e) {
          // Manejo de errores
          print('Error al obtener el idUsuario: $e');
          throw Exception('Error al obtener el idUsuario');
        }
      }
    }
    throw Exception('No se pudo obtener el idUsuario');
  }
}
