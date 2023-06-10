import 'package:etfi_point/Components/Data/Entities/carritoComprasDb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosCategoriasDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<Database> openDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'etfi_point');
    print(path);
    return await openDatabase(path, version: 2, onCreate: (db, version) async {
      await CategoriaDb.createTableCategorias(db);
      await UsuarioDb.createTableUsuarios(db);
      await NegocioDb.createTableNegocios(db);
      await ProductoDb.createTableProductos(db);
      await CarritoComprasDb.createTableCarritoCompras(db);
      await ProductosCategoriasDb.createTableProductosCategorias(db);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      print("oldVersion y newVersion");
      print(oldVersion);
      print(newVersion);
      if (oldVersion == 1 && newVersion == 2) {
        await db.execute("DROP TABLE carritoCompras");
        await db.execute("DROP TABLE productos");
        await db.execute("DROP TABLE negocios");
        await db.execute("DROP TABLE usuarios");
        await db.execute("PRAGMA foreign_keys = ON;");
        await UsuarioDb.createTableUsuarios(db);
        await NegocioDb.createTableNegocios(db);
        await ProductoDb.createTableProductos(db);
        await CarritoComprasDb.createTableCarritoCompras(db);
      }
      // if (oldVersion == 2 && newVersion == 3) {
      //   await ProductoDb.createTableProductos(db);
      // }
      // if (oldVersion == 1 && newVersion == 4) {
      //   await db.execute("PRAGMA foreign_keys = ON;");
      // }
    });
  }
}
