import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Data/models/proServicioSubCategoriaTb.dart';
import 'package:etfi_point/Data/models/productoTb.dart';
import 'package:etfi_point/Data/models/subCategoriaTb.dart';
import 'package:etfi_point/Data/services/api/negocioDb.dart';
import 'package:etfi_point/Data/services/api/productImageDb.dart';
import 'package:etfi_point/Data/services/api/proServiceSubCategoriasDb.dart';
import 'package:etfi_point/Data/services/api/ratingsDb.dart';
import 'package:etfi_point/config/routes/routes.dart';

/// The `ProductoDb` class contains static methods for performing CRUD operations on the "productos"

class ProductoDb {
  static const tableName = "productos";

  // -------- Consultas despues de la migracion a mySQL --------- //

  //Insertar un producto requiere insertar categorias por id en productosCategorias (tabla)

  /// The function `insertProducto` is used to insert a product into a database along with its selected
  /// categories.
  ///
  /// Args:
  ///   producto (ProductoCreacionTb): The parameter "producto" is of type "ProductoCreacionTb", which is
  /// a custom class representing the data of a product to be inserted.
  ///   categoriasSeleccionadas: The parameter "categoriasSeleccionadas" is a list of selected categories
  /// for a product. Each element in the list represents a category and contains information such as the
  /// category ID.
  ///
  /// Returns:
  ///   a Future<int>.
  static Future<int> insertProducto(ProductoCreacionTb producto,
      List<SubCategoriaTb> categoriasSeleccionadas) async {

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

        // Insert categorias seleccionadas
        for (var subCategoria in categoriasSeleccionadas) {
          ProServicioSubCategoriaTb productoSubCategoria =
              ProServicioSubCategoriaTb(
                  idProServicio: idProducto,
                  idCategoria: subCategoria.idCategoria,
                  idSubCategoria: subCategoria.idSubCategoria);

          await ProServiceSubCategoriasDb.insertSubCategoriasSeleccionadas(
              productoSubCategoria, ProductoTb);
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

  /// The function `getProducto` retrieves a product from an API using its ID and returns it as a
  /// `ProductoTb` object.
  ///
  /// Args:
  ///   idProducto (int): The parameter `idProducto` is an integer that represents the ID of the product
  /// that we want to retrieve from the database.
  ///
  /// Returns:
  ///   a Future object of type ProductoTb.
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

  /// The function `getProductosByNegocio` retrieves a list of products associated with a business based
  /// on the provided user ID.
  ///
  /// Args:
  ///   idUsuario (int): The parameter `idUsuario` is an integuer that represents the ID of the user
  /// for whom we want to retrieve the products. with the parameter ´idUsuario´ we consult the ´idNegocio´
  /// and finally retrieve all the products related to ´´idNegocio´´
  ///
  /// Returns:
  ///   a Future object that resolves to a List of ProductoTb objects.
  static Future<List<ProductoTb>> getProductosByNegocio(int idUsuario) async {
    Dio dio = Dio();

    try {
      //NegocioTb? negocio = await NegocioDb.getNegocio(idUsuario);
      //int? idNegocio = negocio?.idNegocio;

      int? idNegocio = await NegocioDb.checkBusinessExists(idUsuario);
      print('idNegocio: $idNegocio');
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

  /// The function `updateProducto` updates a product in a database by sending a PATCH request with the
  /// updated product data and also updates the categories associated with the product.
  ///
  /// Args:
  ///   producto (ProductoTb): An object of type ProductoTb, which represents a product.
  ///   categoriasSeleccionadas: A list of selected categories for the product. Each category is
  /// represented by an object with an idCategoria property.

  static Future<void> updateProducto(
      ProductoTb producto, List<SubCategoriaTb> categoriasSeleccionadas) async {
    print("CATEGORIAS SELECCIONADAS : $categoriasSeleccionadas");

    int idProducto = producto.idProducto;
    Dio dio = Dio();
    String url = '${MisRutas.rutaProductos}/$idProducto';

    try {
      String urlSubCategorias =
          '${MisRutas.rutaProductosSubCategorias}/$idProducto';
      await ProServiceSubCategoriasDb.deleteProServicioSubCategories(
          idProducto, urlSubCategorias);
      for (var subCategoria in categoriasSeleccionadas) {
        ProServicioSubCategoriaTb productoCategoria = ProServicioSubCategoriaTb(
          idSubCategoria: subCategoria.idSubCategoria,
          idProServicio: idProducto,
          idCategoria: subCategoria.idCategoria,
        );

        await ProServiceSubCategoriasDb.insertSubCategoriasSeleccionadas(
            productoCategoria, ProductoTb);
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

  /// The function `deleteProducto` deletes a product from the database along with its associated
  /// categories, images, and ratings.
  ///
  /// Args:
  ///   idProducto (int): The parameter `idProducto` is an integer that represents the ID of the product
  /// that needs to be deleted.
  static Future<void> deleteProducto(int idProducto) async {
    Dio dio = Dio();
    String urlSubCategorias =
        '${MisRutas.rutaProductosSubCategorias}/$idProducto';
    try {
      bool result =
          await ProServiceSubCategoriasDb.deleteProServicioSubCategories(
              idProducto, urlSubCategorias);
      if (result) {
        result = await ProductImageDb.deleteProductImages(idProducto);
      } else {
        print('problemas al eliminar ProductImages');
      }

      print('resulDelete_: $result');
      if (result) {
        String urlRating = '${MisRutas.rutaRatings}/$idProducto';

        await RatingsDb.deleteRatingsByProServicio(idProducto, urlRating);
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

  /// The function `updateProductDescripcionDetallada` updates the detailed description of a product by
  /// sending a PATCH request to the server.
  ///
  /// Args:
  ///   descripcionDetallada (String): The `descripcionDetallada` parameter is a string that represents
  /// the updated detailed description of a product.
  ///   idProducto (int): The id of the product for which you want to update the detailed description.
  ///
  /// Returns:
  ///   a `Future<bool>`.
  static Future<bool> updateProductDescripcionDetallada(
      String descripcionDetallada, int idProducto) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaDescripcionDetallada}/$idProducto';

    try {
      Response response = await dio.patch(
        url,
        data: jsonEncode({"descripcionDetallada": descripcionDetallada}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('Descripcion detallada actualizada correctamente');
        print(response.data);
        return true;
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error de conexión en updateProductDescripcionDetallada: $error');
      return false;
    }
  }
}
