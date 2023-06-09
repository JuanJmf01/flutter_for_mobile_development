import 'package:etfi_point/Components/Data/EntitiModels/negocioTb.dart';
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

   static Future<int> insert(NegocioTb negocio) async {
    Database database = await DB.openDB();

    return database.insert(tableName, negocio.toMap());
  }


}
