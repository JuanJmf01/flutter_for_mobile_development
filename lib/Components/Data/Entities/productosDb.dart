import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/negocioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoCategoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosCategoriasDb.dart';
import 'package:etfi_point/Components/Data/Entities/ratingsDb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class ProductoDb {
  static const tableName = "productos";

  // static Future<List<ProductoTb>> getProductosByCategoria2(
  //     int idCategoria) async {
  //   Database database = await DB.openDB();

  //   final List<Map<String, dynamic>> productosMap = await database.rawQuery('''
  //     SELECT p.* 
  //     FROM $tableName p
  //     INNER JOIN ${ProductosCategoriasDb.tableName} pc
  //       ON p.idProducto = pc.idProducto
  //     WHERE pc.idCategoria = ?
  //   ''', [idCategoria]);

  //   List<ProductoTb> productos = [];

  //   for (final productoMap in productosMap) {
  //     ProductoTb producto = ProductoTb(
  //       idProducto: productoMap['idProducto'],
  //       idNegocio: productoMap['idNegocio'],
  //       nombreProducto: productoMap['nombreProducto'],
  //       precio: productoMap['precio'],
  //       descripcion: productoMap['descripcion'],
  //       cantidadDisponible: productoMap['cantidadDisponible'],
  //       oferta: productoMap['oferta'],
  //       urlImage: productoMap['imagePath'],
  //     );

  //     productos.add(producto);
  //   }
  //   return productos;
  // }

  // Retornamos una lista de productos por idCategorias
  // static Future<List<ProductoTb>> getProductosByCategoria(
  //     int idProducto) async {
  //   //Obtenemos todas las categorias en una lista
  //   final List<int> idCategorias =
  //       await ProductosCategoriasDb.getIdCategoriasPorIdProducto(idProducto);
  //   final Set<int> idProductosSinRepetir = {};
  //   final List<ProductoTb> productos = [];

  //   //Pasamos categoria por categoria al metodo 'getProductosByCategoria' y vamos insertando uno a uno en una lista
  //   for (int idCategoria in idCategorias) {
  //     final List<ProductoTb> productosPorCategoria =
  //     //Realizar una consulta que se encargue de retornar productos por idCategoria
  //         await getProductosByCategoria2(idCategoria);
  //     print(productos);
  //     productos.addAll(productosPorCategoria);
  //   }

  //   productos.removeWhere((producto) => producto.idProducto == idProducto);
  //   productos.retainWhere(
  //       (producto) => idProductosSinRepetir.add(producto.idProducto!));

  //   return productos;
  // }

  // -------- Consultas despues de la migracion a mySQL --------- //

  //Insertar un producto requiere insertar categorias por id en productosCategorias (tabla)
  static Future<int> insertProducto(
      ProductoCreacionTb producto, categoriasSeleccionadas) async {
    print('Producto: $producto');
    print('categorias: $categoriasSeleccionadas');

    Dio dio = Dio();
    Map<String, dynamic> data = producto.toMap();
    String url = MisRutas.rutaProductos;

    try {
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
      if (response.statusCode == 200) {
        print('Producto insertado correctamenre (print)');
        print(response.data);
        int idProducto = response.data;

        // Insertar categorías seleccionadas
        for (var i = 0; i < categoriasSeleccionadas.length; i++) {
          ProductoCategoriaTb productoCategoria = ProductoCategoriaTb(
            idProducto: idProducto,
            idCategoria: categoriasSeleccionadas[i].idCategoria,
          );

          await ProductosCategoriasDb.insertCategoriasSeleccionadas(
              productoCategoria);
        }
        return idProducto;
      } else {
        throw Exception(
            'Error en la solicitud en insertProducto: ${response.statusCode}');
      }
    } catch (error) {
      print('Ha ocurrido un error $error');
      throw Exception('Error de conexión: $error');
    }
  }

  static Future<ProductoTb> getProducto(int idProducto) async {
    Dio dio = Dio();

    try {
      Response response =
          await dio.get('${MisRutas.rutaProductos}/$idProducto');
      if (response.statusCode == 200) {
        ProductoTb producto = ProductoTb.fromJson(response.data);
        return producto;
      } else {
        throw Exception('Error en la respuesta: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
    }
  }

  static Future<List<ProductoTb>> getProductosByNegocio(idUsuario) async {
    Dio dio = Dio();

    try {
      NegocioTb? negocio = await NegocioDb.getNegocio(idUsuario);
      int? idNegocio = negocio?.idNegocio;
      print('idNegocio : $idNegocio');
      if (idNegocio != null) {
        Response response =
            await dio.get('${MisRutas.rutaProductosByNegocio}/$idNegocio');

        if (response.statusCode == 200) {
          print('llega dentro del if getProductosByNegoicio');
          List<ProductoTb> productos = List<ProductoTb>.from(response.data
              .map((productoData) => ProductoTb.fromJson(productoData)));
          print('productos_: $productos');
          return productos;
        } else {
          print('Error: ${response.statusCode}');
          return [];
        }
      } else {
        print('idNegocio no encontrado. Crea un negocio');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  static Future<void> updateProducto(
      ProductoTb producto, categoriasSeleccionadas) async {
    int idProducto = producto.idProducto;
    Dio dio = Dio();
    String url = '${MisRutas.rutaProductos}/$idProducto';

    try {
      await ProductosCategoriasDb.deleteProductosCategorias(idProducto);
      for (var i = 0; i < categoriasSeleccionadas.length; i++) {
        ProductoCategoriaTb productoCategoria = ProductoCategoriaTb(
          idProducto: idProducto,
          idCategoria: categoriasSeleccionadas[i].idCategoria,
        );

        await ProductosCategoriasDb.insertCategoriasSeleccionadas(
            productoCategoria);
      }

      Response response = await dio.patch(
        url,
        data: producto.toMap(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('Producto actualizado correctamente');
        print(response.data);
        // Realiza las operaciones necesarias con la respuesta
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      // Ocurrió un error en la conexión
      print('Error de conexión: $error');
    }
  }

  static Future<void> deleteProducto(int idProducto) async {
    Dio dio = Dio();

    try {
      bool result =
          await ProductosCategoriasDb.deleteProductosCategorias(idProducto);
      if (result) {
        result = await productImageDb.deleteProductImages(idProducto);
      } else {
        print('problemas al eliminar ProductImages');
      }

      print('resulDelete_: $result');
      if (result) {
        await RatingsDb.deleteRatings(idProducto);
        Response response =
            await dio.delete('${MisRutas.rutaProductos}/$idProducto');

        if (response.statusCode == 202) {
          print('Producto eliminado correctamente');
        } else if (response.statusCode == 404) {
          print('Producto no encontrado');
        } else {
          print('Error: ${response.statusCode}');
        }
      } else {
        print('No se pudieron eliminar productosCategorias');
      }
    } catch (error) {
      print('Error in delete product: $error');
    }
  }
}
