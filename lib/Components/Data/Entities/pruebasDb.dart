import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/pruebaTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PruebasDb {
  static Future<Database> _openDB() async {
    final directory = await getDatabasesPath();
    print('Esta es la direccion' + directory);
    return openDatabase(join(await getDatabasesPath(), 'etfi_pointTwo.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE pruebas (id INTEGER PRIMARY KEY, nombre TEXT)",
          );
        },
        version:
            20, //Anteriormente existia una version 1, debido a que hubieron cambios en la estructura de la tabla la version la aumentamos en 1

        onUpgrade: (db, oldVersion, newVersion) {
          print("Version vieja y nueva:");
          print(oldVersion);
          print(newVersion);

          if (oldVersion <= 1) {
            db.execute("ALTER TABLE pruebas ADD COLUMN age INTEGER");
          }
          if (oldVersion <= 2) {
            db.execute("CREATE TABLE vendedores (\n"
                "idVendedor INTEGER PRIMARY KEY,\n"
                "nombres TEXT,\n"
                "apellidos TEXT,\n"
                "nombreNegocio TEXT,\n"
                "descripcionNegocio TEXT,\n"
                "facebook TEXT,\n"
                "instagram TEXT,\n"
                "password TEXT)");
          }
          if (oldVersion <= 4) {
            db.execute(
                "CREATE TABLE pruebaUno (idPruebaUno INTEGER PRIMARY KEY, nombrePrueba TEXT)");
          }
          if (oldVersion <= 6) {
            db.execute(
                'CREATE TABLE pruebas (id INTEGER PRIMARY KEY, nombre TEXT, age INTEGER)');
          }
          if (oldVersion <= 19) {
            db.execute(
                'CREATE TABLE pruebas (id INTEGER PRIMARY KEY, nombre TEXT, age INTEGER, imagePath TEXT NOT NULL)');
          }
          if (oldVersion <= 18) {
            db.execute(
                'DROP TABLE pruebas');
          }
        });
  }

  

  static Future<int> insert(PruebaTb prueba) async {
    Database database = await _openDB();

    return database.insert("pruebas", prueba.toMap());
  }

  static Future<List<PruebaTb>> pruebas() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> nombresMap =
        await database.query("pruebas");

    return List.generate(
        nombresMap.length,
        (i) => PruebaTb(
              id: nombresMap[i]['id'],
              nombre: nombresMap[i]['nombre'],
              age: nombresMap[i]['age'],
              imagePath: nombresMap[i]['imagePath']
            ));
  }

  static Future<int> delete(PruebaTb prueba) async {
    Database database = await _openDB();

    return database.delete("pruebas", where: "id = ?", whereArgs: [prueba.id]);
  }

  static Future<int> update(PruebaTb prueba) async {
    Database database = await _openDB();

    return database.update("pruebas", prueba.toMap(),
        where: "id = ?", whereArgs: [prueba.id]);
  }
}
