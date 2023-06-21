import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosCategoriasDb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
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

  //Save actualiza o crea un nuevo producto. Si producto != null entt se trata de actualizacion de producto
  //Si producto == null entonces se trata de una creacion de producto


  //Inserta un producto y los idCategoria en la tabla productosCategoria con su respectivo idproducto
  static Future<int> insert(
      ProductoCreacionTb producto, categoriasSeleccionadas) async {
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

  //Actualiza un producto y actualiza las los idCategoria y idProducto en la tabla productosCategorias en caso de ser cambiadas por el usuario
  static Future<void> update(
      ProductoTb producto, List<CategoriaTb> categoriasSeleccionadas) async {
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

  //Retorna un solo producto. lo bisca por id
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

  //Retorna todos los productos
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

  static Future<List<ProductoTb>> getProductosByCategoria(
      int idCategoria) async {
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

  // Traer todos los productos por negocio (productos que tenga cada vendedor)
  static Future<List<ProductoTb>> getProductosByIdNegocio() async {
    try {
      int? idUsuario = await UsuarioDb.getIdUsuario();
      int? idNegocio = await NegocioDb.findIdNegocioByIdUsuario(idUsuario!);
      if (idNegocio != null) {
        Database database = await DB.openDB();

        List<Map<String, dynamic>> results = await database.query(
          tableName,
          where: 'idNegocio = ?',
          whereArgs: [idNegocio],
        );

        List<ProductoTb> productosList = results.map((map) {
          return ProductoTb(
            idProducto: map['idProducto'],
            idNegocio: map['idNegocio'],
            nombreProducto: map['nombreProducto'],
            precio: map['precio'],
            descripcion: map['descripcion'],
            cantidadDisponible: map['cantidadDisponible'],
            oferta: map['oferta'],
            imagePath: map['imagePath'],
          );
        }).toList();

        return productosList;
      } else {
        print('No se encontró el idNegocio correspondiente al idUsuario');
        return [];
      }
    } catch (e) {
      print('Error al obtener los productos por idNegocio: $e');
      return [];
    }
  }

  // Retornamos una lista de productos por idCategorias
static Future<List<ProductoTb>> getProductosPorIdProducto(int idProducto) async {

  //Obtenemos todas las categorias en una lista 
  final List<int> idCategorias = await ProductosCategoriasDb.getIdCategoriasPorIdProducto(idProducto);
  final Set<int> idProductosSinRepetir = {};
  final List<ProductoTb> productos = [];

  //Pasamos categoria por categoria al metodo 'getProductosByCategoria' y vamos insertando uno a uno en una lista
  for (int idCategoria in idCategorias) {
    final List<ProductoTb> productosPorCategoria = await getProductosByCategoria(idCategoria);
    print(productos);
    productos.addAll(productosPorCategoria);
  }

  productos.removeWhere((producto) => producto.idProducto == idProducto);
  productos.retainWhere((producto) => idProductosSinRepetir.add(producto.idProducto!));

  return productos;
}




}

