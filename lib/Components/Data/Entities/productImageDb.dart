import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class ProductImageDb {
  static Future<ProductImagesTb> insertProductImages(
      ProductImageCreacionTb productImage) async {
    Dio dio = Dio();
    String url = MisRutas.rutaProductImages;
    Map<String, dynamic> data = productImage.toMap();

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
        ProductImagesTb productImage = ProductImagesTb.fromJson(response.data);

        return productImage;
      } else {
        throw Exception('Error en la respuesta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
      throw Exception('Error en la solicitud: $error');
    }
  }

  static Future<List<ProductImagesTb>> getProductSecondaryImages(
      int idProducto) async {
    Dio dio = Dio();

    try {
      Response response =
          await dio.get('${MisRutas.rutaProductImages}/$idProducto');

      if (response.statusCode == 200) {
        List<ProductImagesTb> productSecondaryImages =
            List<ProductImagesTb>.from(response.data
                .map((productoData) => ProductImagesTb.fromJson(productoData)));
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

  static Future<void> updateProductImage(
      ProductImageCreacionTb productImage) async {
    Dio dio = Dio();
    String url = MisRutas.rutaProductImages;

    try {
      Response response = await dio.patch(
        url,
        data: productImage.toMap(),
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
