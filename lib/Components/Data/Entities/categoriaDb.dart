import 'package:etfi_point/Components/Data/DB.dart';
import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosCategoriasDb.dart';
import 'package:sqflite/sqflite.dart';

class CategoriaDb {
  static const tableName = "categorias";
  static Future<void> createTableCategorias(Database db) async {
    await db.execute(
        "CREATE TABLE $tableName (idCategoria INTEGER PRIMARY KEY, nombre TEXT, imagePath TEXT)");
  }

  static Future<int> insert(CategoriaTb categoria) async {
    Database database = await DB.openDB();

    return database.insert("categorias", categoria.toMap());
  }

  static Future<List<CategoriaTb>> categorias() async {
    Database database = await DB.openDB();
    final List<Map<String, dynamic>> nombresMap =
        await database.query(tableName);
    final List<CategoriaTb> categoriasList = List.generate(
      nombresMap.length,
      (i) => CategoriaTb(
        idCategoria: nombresMap[i]['idCategoria'],
        nombre: nombresMap[i]['nombre'],
        imagePath: nombresMap[i]['imagePath'],
      ),
    );

    //Imprimir los productos en la consola
    for (var categoria in categoriasList) {
      print(categoria);
    }

    return categoriasList;
  }

  static Future<int?> obtenerIdCategoriaPorNombre(
      String nombreCategoria) async {
    Database database = await DB.openDB();
    List<Map<String, dynamic>> resultado = await database.query(
      'categorias',
      columns: ['idCategoria'],
      where: 'nombre = ?',
      whereArgs: [nombreCategoria],
    );
    if (resultado.isNotEmpty) {
      return resultado.first['idCategoria'];
    } else {
      return null;
    }
  }

  //Obtenemos una sola categoria (el nombre) por un idCategoria
  static Future<Map<int, String>> obtenerCategoriasPorId(int idCategoria) async {
    Database database = await DB.openDB();
    List<Map<String, dynamic>> resultado = await database.query(
      tableName,
      columns: ["idCategoria", "nombre"],
      where: "idCategoria = ?",
      whereArgs: [idCategoria],
    );
    Map<int, String> categorias = {};
    resultado.forEach((map) {
      int idCategoria = map["idCategoria"] as int;
      String nombreCategoria = map["nombre"] as String;
      categorias[idCategoria] = nombreCategoria;
    });

    return categorias;
  }

  //Obtenemos todas la categorias en una lista de un producto especifico
  static Future<List<CategoriaTb>> getCategoriasSeleccionadas(int idProducto) async {
    try {
      //Obtenemos una lista de idCategorias que pertenescan unicamnete a idProducto
      final idCategoriasDeProducto = await ProductosCategoriasDb.getIdCategoriasPorIdProducto(idProducto);
      final categoriasSeleccionadas = <CategoriaTb>[];

      //Recorremos 'idCategoriasDeProducto' y en cada ciclo llamamos al metodo 'obtenerCategoriasPorId'
      //'obtenerCategoriasPorId' nos retorna una categoria (nombre de la categoria) y lo guardamos en la lista 'categoriasSeleccionadas'
      for (int idCategoria in idCategoriasDeProducto) {
        final categoriaMap = await obtenerCategoriasPorId(idCategoria);
        if (categoriaMap.isNotEmpty) {
          final nombreCategoria = categoriaMap[idCategoria];
          if (nombreCategoria != null) {
            final categoria = CategoriaTb(
              idCategoria: idCategoria,
              nombre: nombreCategoria,
            );
            categoriasSeleccionadas.add(categoria);
          }
        }
      }

      return categoriasSeleccionadas;
    } catch (error) {
      print('Error al obtener las categorías seleccionadas: $error');
      return [];
    }
  }
}
