import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosCategoriasDb.dart';
import 'package:sqflite/sqflite.dart';

import '../DB.dart';

class ProductoDb {
  static const tableName = "productos";
  static Future<void> createTableProductos(Database db) async {
    await db.execute("CREATE TABLE $tableName (\n"
        "idProducto INTEGER PRIMARY KEY,\n"
        "idNegocio INTEGER,\n"
        "nombreProducto TEXT NOT NULL,"
        "precio REAL NOT NULL,\n"
        "descripcion TEXT,\n"
        "cantidadDisponible INTEGER NOT NULL,\n"
        "oferta INTEGER,\n" //bool (0 or 1)
        "imagePath TEXT,\n"
        "FOREIGN KEY (idNegocio) REFERENCES negocios(idNegocio) \n"
        ")");
  }


   static Future<void> save(ProductoTb producto, List<CategoriaTb> categorias) async {
    if (producto.idProducto != null) {
      // Actualizar el producto existente
      await update(producto, categorias);
    } else {
      // Insertar un nuevo producto
      await insert(producto, categorias);
    }
  }

  static Future<int> insert(
      ProductoTb producto, categoriasSeleccionadas) async {
    Database database = await DB.openDB();

    int idProducto = await database.insert(tableName, producto.toMap());

    await database.transaction((txn) async {
      for (int idCategoria in categoriasSeleccionadas
          .map((categoria) => categoria.idCategoria)) {
        Map<String, dynamic> productoCategoriaMap = {
          'idProducto': idProducto,
          'idCategoria': idCategoria,
        };
        await txn.insert('productosCategorias', productoCategoriaMap);
      }
    });

    return idProducto;
  }

  static Future<void> update(ProductoTb producto, List<CategoriaTb> categoriasSeleccionadas) async {
  Database database = await DB.openDB();

  await database.transaction((txn) async {
    await txn.update(tableName, producto.toMap(),
        where: 'idProducto = ?', whereArgs: [producto.idProducto]);

    await txn.delete('productosCategorias',
        where: 'idProducto = ?', whereArgs: [producto.idProducto]);

    for (CategoriaTb categoria in categoriasSeleccionadas) {
      Map<String, dynamic> productoCategoriaMap = {
        'idProducto': producto.idProducto,
        'idCategoria': categoria.idCategoria,
      };
      await txn.insert('productosCategorias', productoCategoriaMap);
    }
  });
}


  static Future<ProductoTb> individualProduct(int id) async {
    Database database = await DB.openDB();
    final List<Map<String, dynamic>> productoMap = await database.query(
      tableName,
      where: 'idProducto = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (productoMap.isNotEmpty) {
      return ProductoTb(
        idProducto: productoMap[0]['idProducto'],
        //idCategoria: productoMap[0]['idProducto'],
        idNegocio: productoMap[0]['idNegocio'],
        nombreProducto: productoMap[0]['nombreProducto'],
        precio: productoMap[0]['precio'],
        descripcion: productoMap[0]['descripcion'],
        cantidadDisponible: productoMap[0]['cantidadDisponible'],
        oferta: productoMap[0]['oferta'],
        imagePath: productoMap[0]['imagePath'],
      );
    } else {
      throw Exception('No se encontró un producto con el id especificado');
    }
  }

  static Future<List<ProductoTb>> productos() async {
    Database database = await DB.openDB();
    final List<Map<String, dynamic>> nombresMap =
        await database.query(tableName);
    final List<ProductoTb> productosList = List.generate(
      nombresMap.length,
      (i) => ProductoTb(
        idProducto: nombresMap[i]['idProducto'],
        //idCategoria: nombresMap[i]['idProducto'],
        idNegocio: nombresMap[i]['idNegocio'],
        nombreProducto: nombresMap[i]['nombreProducto'],
        precio: nombresMap[i]['precio'],
        descripcion: nombresMap[i]['descripcion'],
        cantidadDisponible: nombresMap[i]['cantidadDisponible'],
        oferta: nombresMap[i]['oferta'],
        imagePath: nombresMap[i]['imagePath'],
      ),
    );

    // Imprimir los productos en la consola
    // for (var producto in productosList) {
    //   print(producto);
    // }

    return productosList;
  }

  static Future<void> delete(int idProducto) async {
    Database database = await DB.openDB();

    await database.transaction((txn) async {
      // Eliminar el producto de la tabla productos
      await txn
          .delete(tableName, where: "idProducto = ?", whereArgs: [idProducto]);

      // Eliminar los registros de la tabla productosCategorias que coincidan con el idProducto
      await txn.delete(ProductosCategoriasDb.tableName,
          where: "idProducto = ?", whereArgs: [idProducto]);
    });
  }

  static Future<List<ProductoTb>> getProductosByCategoria(int idCategoria) async {
    Database database = await DB.openDB();

    final List<Map<String, dynamic>> productosMap = await database.rawQuery('''
      SELECT p.* 
      FROM $tableName p
      INNER JOIN ${ProductosCategoriasDb.tableName} pc
        ON p.idProducto = pc.idProducto
      WHERE pc.idCategoria = ?
    ''', [idCategoria]);

    List<ProductoTb> productos = [];

    for (final productoMap in productosMap) {
      ProductoTb producto = ProductoTb(
        idProducto: productoMap['idProducto'],
        idNegocio: productoMap['idNegocio'],
        nombreProducto: productoMap['nombreProducto'],
        precio: productoMap['precio'],
        descripcion: productoMap['descripcion'],
        cantidadDisponible: productoMap['cantidadDisponible'],
        oferta: productoMap['oferta'],
        imagePath: productoMap['imagePath'],
      );

      productos.add(producto);
    }

    return productos;
  }


}
