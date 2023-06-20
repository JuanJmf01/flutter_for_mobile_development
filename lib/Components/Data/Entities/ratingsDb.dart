import 'package:etfi_point/Components/Data/DB.dart';
import 'package:etfi_point/Components/Data/EntitiModels/ratingsTb.dart';
import 'package:sqflite/sqflite.dart';

class RatingsDb {
  static const tableName = "ratings";
  static Future<void> createTableRatings(Database db) async {
    await db.execute("CREATE TABLE $tableName( \n"
        "id INTEGER PRIMARY KEY, \n"
        "idUsuario INTEGER, \n"
        "idProducto INTEGER, \n"
        "comentario TEXT, \n"
        "likes INTEGER, \n"
        "ratings INTEGER, \n"
        "FOREIGN KEY (idUsuario) REFERENCES Usuarios(id), \n"
        "FOREIGN KEY (idProducto) REFERENCES Productos(id) \n"
        ")");
  }

  //verifica la existencia de idUsuario e idProducto en la misma fila de la tabla "ratings"
  static Future<void> saveRating(RatingsCreacionTb rating) async {
    Database database = await DB.openDB();

    List<Map<String, dynamic>> result = await database.query(
      tableName,
      where: 'idUsuario = ? AND idProducto = ?',
      whereArgs: [rating.idUsuario, rating.idProducto],
    );

    if (result.isNotEmpty) {
      // El registro existe, realizar la actualización
      await database.update(
        tableName,
        rating.toMap(),
        where: 'idUsuario = ? AND idProducto = ?',
        whereArgs: [rating.idUsuario, rating.idProducto],
      );
    } else {
      // El registro no existe, realizar la inserción
      insert(rating);
    }
  }

  static Future<int> insert(RatingsCreacionTb rating) async {
    Database database = await DB.openDB();

    int id = await database.insert(tableName, rating.toMap());

    return id;
  }

  static Future<RatingsCreacionTb> getRatingAndOthersByIdProductoAndIdUser(
      int idUsuario, int idProducto) async {
    try {
      Database database = await DB.openDB();

      List<Map<String, dynamic>> result = await database.query(
        tableName,
        where: 'idUsuario = ? AND idProducto = ?',
        whereArgs: [idUsuario, idProducto],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return RatingsCreacionTb.fromMap(result.first);
      } else {
        throw Exception(
            'No se encontró el rating con los datos proporcionados.');
      }
    } catch (error) {
      // Manejo de errores
      print('Error: $error');
      throw Exception('Ocurrió un error al obtener los datos del rating.');
    }
  }

  //Obtiene todos los ratings que coincidan con idProducto
  static Future<List<Map<String, dynamic>>> getRatingsByIdProducto(
      int idProducto) async {
    final Database database = await DB.openDB();

    final List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT r.*, u.nombres AS nombreUsuario
    FROM ratings AS r
    INNER JOIN usuarios AS u ON r.idUsuario = u.idUsuario
    WHERE r.idProducto = $idProducto AND r.ratings != 0
  ''');

    return result;
  }

  //Obtiene todos los ratings que coincidan con idProducto y raging (calificacion por estrellas)
  static Future<List<Map<String, dynamic>>> getRatingsByIdProductoAndRating(
      int idProducto, int rating) async {
    final Database database = await DB.openDB();

    final List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT r.*, u.nombres AS nombreUsuario
    FROM ratings AS r
    INNER JOIN usuarios AS u ON r.idUsuario = u.idUsuario
    WHERE r.idProducto = $idProducto AND r.ratings = $rating
  ''');

    return result;
  }

  static Future<bool> existOrNotRating(int idUsuario, int idProducto) async {
    Database database = await DB.openDB();

    List<Map<String, dynamic>> result = await database.query(
      tableName,
      where: 'idUsuario = ? AND idProducto = ?',
      whereArgs: [idUsuario, idProducto],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  //Almacenamos en un arreglo la cantidad de calificaciones por cada estrella
  //Posicion 0: Cantidad de calificaciones por 5 estrellas
  //Posicion 1: Cantidad de calificaciones por 4 estrellas
  //...
  //Posicion 4: Cantidad de calificaciones por 1 estrella

  static Future<List<int>> getStarCounts(int idProducto) async {
    Database database = await DB.openDB();

    List<Map<String, dynamic>> results = await database.rawQuery('''
    SELECT COUNT(*) as count, ratings
    FROM ratings
    WHERE idProducto = ?
    AND ratings >= 1 AND ratings <= 5
    GROUP BY ratings
    ORDER BY ratings DESC
  ''', [idProducto]);

    List<int> starCounts = List.filled(5, 0);

    for (Map<String, dynamic> result in results) {
      int count = result['count'];
      int rating = result['ratings'];

      starCounts[5 - rating] = count;
    }

    //List<int> starCount2 = [5459,2839,1500,500,142];

    return starCounts;
  }
}
