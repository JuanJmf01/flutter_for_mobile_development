import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/negocioTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:sqflite/sqflite.dart';

import '../DB.dart';

class NegocioDb {
  static const tableName = "negocios";
  static Future<void> createTableNegocios(Database db) async {
    await db.execute("CREATE TABLE $tableName (\n"
        "idNegocio INTEGER PRIMARY KEY,\n"
        "idUsuario INTEGER,\n"
        "nombreNegocio TEXT,\n"
        "descripcionNegocio TEXT,\n"
        "facebook TEXT,\n"
        "instagram TEXT,\n"
        "vendedor INTEGER, \n" //bool (0 or 1)
        "FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario) \n"
        ")");
  }

  // static Future<int> insert(NegocioCreacionTb negocio) async {
  //   Database database = await DB.openDB();

  //   return database.insert(tableName, negocio.toMap());
  // }

  //Buscar si existe un negocio por idUsuario
  static Future<int?> fidIdNegocioByIdUsuario(int idUsuario) async {
    try {
      Database database = await DB.openDB();

      List<Map<String, dynamic>> results = await database.query(
        tableName,
        columns: ['idNegocio'],
        where: 'idUsuario = ?',
        whereArgs: [idUsuario],
        limit: 1,
      );

      if (results.isNotEmpty) {
        return results.first['idNegocio'] as int;
      } else {
        return null;
      }
    } catch (e) {
      print('Error al buscar el idNegocio: $e');
      return null;
    }
  }

  // -------- Consultas despues de la migracion a mySQL --------- //

  static Future<int> insertNegocio(NegocioCreacionTb negocio) async {
    Dio dio = Dio();
    //Se convierte un negocio de tipo negocioCreacionTb a un tipo Map<String, dynamic>
    //De esta manera podemos convertirlo a un json ya que la api recibe en json
    Map<String, dynamic> data = negocio.toMap();
    String url = MisRutas.rutaNegocios;

    try {
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
      if (response.statusCode == 200) {
        int idNegocio = response.data;
        print('Negocio insertado correctamente (print)');
        return idNegocio;
      } else {
        throw Exception(
            'Error en la solicitud en insertNegocio: ${response.statusCode}');
      }
    } catch (error) {
      // Ocurrió un error en la conexión
      print('Error de conexión: $error');
      throw Exception('Error de conexión: $error');
    }
  }

  //Funcion para obtener un unico negocio por idUsuario
  static Future<NegocioTb?> getNegocio(int idUsuario) async {
    try {
      Dio dio = Dio();
      Response response = await dio.get('${MisRutas.rutaNegocios}/$idUsuario');
      if (response.statusCode == 200) {

        final negocioJson = response.data as Map<String, dynamic>;
        return NegocioTb.fromJson(negocioJson);
      } else if (response.statusCode == 404) {
        return null;
      }
    } catch (error) {
      print('Error al obtener el negocio: $error');
    }
    return null;
  }
}
