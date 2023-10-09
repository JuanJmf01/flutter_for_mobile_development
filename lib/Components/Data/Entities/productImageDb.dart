import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

/// The `ProductImageDb` class contains static methods for inserting, retrieving, updating, and deleting
/// product images from a database using HTTP requests.

class ProductImageDb {
  /// The function `insertProductImages` sends a POST request to a specified URL with the provided
  /// product image data and returns the inserted product image if successful.
  ///
  /// Args:
  ///   productImage (ProductImageCreacionTb): The parameter `productImage` is an instance of the class
  /// `ProductImageCreacionTb`. It represents the data of a product image that needs to be inserted into
  /// the database.
  ///
  /// Returns:
  ///   a Future object of type ProductImagesTb.
  static Future<ProservicioImagesTb> insertProductImages(
      ProServicioImageCreacionTb productImage) async {
    Dio dio = Dio();
    String url = MisRutas.rutaProductImages;
    Map<String, dynamic> data = productImage.toMapProductos();

    try {
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('productImage insertado correctamente (print)');
        ProservicioImagesTb productImage = ProservicioImagesTb.fromJsonProductos(response.data);

        return productImage;
      } else {
        throw Exception('Error en la respuesta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
      throw Exception('Error en la solicitud: $error');
    }
  }

 /// The function `getProductSecondaryImages` retrieves a list of secondary images for a product using
 /// an HTTP GET request.
 /// 
 /// Args:
 ///   idProducto (int): The parameter `idProducto` is an integer that represents the ID of a product.
 /// It is used to fetch the secondary images of a product from the database.
 /// 
 /// Returns:
 ///   a Future object that resolves to a List of ProductImagesTb objects.
  static Future<List<ProservicioImagesTb>> getProductSecondaryImages(
      int idProducto) async {
    Dio dio = Dio();

    try {
      Response response =
          await dio.get('${MisRutas.rutaProductImages}/$idProducto');

      if (response.statusCode == 200) {
        List<ProservicioImagesTb> productSecondaryImages =
            List<ProservicioImagesTb>.from(response.data
                .map((productoData) => ProservicioImagesTb.fromJsonProductos(productoData)));
        print('productoImageingetSecond: $productSecondaryImages');
        return productSecondaryImages;
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

 /// The function `updateProductImage` sends a PATCH request to update a product image by nameImage using the Dio
 /// package in Dart.
 /// 
 /// Args:
 ///   productImage (ProductImageCreacionTb): The parameter `productImage` is an instance of the class
 /// `ProductImageCreacionTb`. It represents the product image that needs to be updated.
 // POR AHORA NO UTILIZAREMOS LA ACTUALIZACION DE LA IMAGEN EN LA BASE DE
 // DATOS YA QUE NO ES NECESARIO. NOTA: NO HAY METODO DE CONSULTA PARA 
 //ACTUALIZACION DE LA IMANGE EN LA API
  static Future<void> updateProductImage(
      ProServicioImageCreacionTb productImage) async {
    Dio dio = Dio();
    String url = MisRutas.rutaProductImages;

    try {
      Response response = await dio.patch(
        url,
        data: productImage.toMapProductos(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('productImage actualizado correctamente');
        print(response.data);
        // Realiza las operaciones necesarias con la respuesta
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      // Ocurrió un error en la conexión
      print('Error de conexiónnP: $error');
    }
  }



/// The function `deleteProductImages` sends a DELETE request to a specified URL to delete product
/// images associated with a given product ID and returns a boolean value indicating whether the deletion was successful.
/// 
/// Args:
///   idProducto (int): The parameter `idProducto` is the ID of the product whose images need to be
/// deleted.
/// 
/// Returns:
///   a Future<bool>.
  static Future<bool> deleteProductImages(int idProducto) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaProductImages}/$idProducto';

    try {
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 202) {
        print('ProductImages eliminados correctamente');
        return true;
      } else if (response.statusCode == 404) {
        print('ProductImages no encontrado');
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
    return false;
  }

 /// The function `deleteProductImage` sends a DELETE request to a specified URL to delete a product
 /// image and returns a boolean value indicating whether the deletion was successful.
 /// 
 /// Args:
 ///   idProductImage (int): The id of the product image that needs to be deleted.
 /// 
 /// Returns:
 ///   a Future<bool>.
  static Future<bool> deleteProuctImage(int idProductImage) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaProductImage}/$idProductImage';

    try {
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 202) {
        print('ProductImage eliminado correctamente');
        return true;
      } else if (response.statusCode == 404) {
        print('ProductImage no encontrado');
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
    return false;
  }
}
