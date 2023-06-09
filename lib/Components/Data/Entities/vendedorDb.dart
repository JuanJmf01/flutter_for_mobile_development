import 'package:etfi_point/Components/Data/DB.dart';
import 'package:etfi_point/Components/Data/EntitiModels/vendedorTb.dart';
import 'package:sqflite/sqflite.dart';

class VendedorDb {
  static Future<void> insertVendedor(VendedorTb vendedor) async {
    final Database db = await DB.openDB();
    await db.insert('vendedores', vendedor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
