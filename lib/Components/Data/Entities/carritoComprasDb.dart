import 'package:sqflite/sqflite.dart';

class CarritoComprasDb {
  static const tableName = "carritoCompras";
  static Future<void> createTableCarritoCompras(Database db) async {
    await db.execute("CREATE TABLE $tableName (\n"
        "idCarrito INTEGER PRIMARY KEY,\n"
        "idUsuario INTEGER,\n"
        "idProducto INTEGER,\n"
        "cantidad INTEGER,\n"
        "FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario),\n"
        "FOREIGN KEY (idProducto) REFERENCES productos(idProducto))");
  }
}
