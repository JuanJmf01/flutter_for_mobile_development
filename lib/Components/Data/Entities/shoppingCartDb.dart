import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/shoppingCartTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:etfi_point/Components/Utils/Providers/shoppingCartProvider.dart';

class ShoppingCartDb {
  /// Insert a shopping cart product into the database using Dio.
  ///
  /// [shoppingCartProduct]: The product to be inserted.
  ///
  /// If the product already exists in the cart (status code 409), it prints a message indicating so.
  ///
  /// For other status codes, it throws an Exception with the corresponding error message.
  ///
  /// In case of a DioException, it handles the 409 status code separately for the existing product case,

  static Future<bool> insertShoppingCartProduct(
      ShoppingCartCreacionTb shoppingCartProduct) async {
    Dio dio = Dio();
    String url = MisRutas.rutaShoppingCart;

    Map<String, dynamic> data = shoppingCartProduct.toMap();

    try {
      Response response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print(
            'ShoppingCardProduct insertado correctamente. id: ${response.data}');
        return true;
      } else if (response.statusCode == 409) {
        print('Ya existe');
        return false;
      } else {
        throw Exception(
            'Error en la solicitud en insertProducto: ${response.statusCode}');
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 409) {
          print('El producto ya existe en el carrito');
          return false;
        } else {
          throw Exception('Error de conexión: ${error.message}');
        }
      } else {
        throw Exception('Error: $error');
      }
    }
  }

  static Future<List<ShoppingCartProductTb>> shoppingCardByUsuario(
      int idUsuario) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaShoppingCart}/$idUsuario';

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('exito ShoppingCardByProducto');
        List<ShoppingCartProductTb> shoppingCartProducts =
            List<ShoppingCartProductTb>.from(response.data.map(
                (shoppingProducto) =>
                    ShoppingCartProductTb.fromJson(shoppingProducto)));
        print('ProductCarrito_: $shoppingCartProducts');

        return shoppingCartProducts;
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Errorrr: $error');
      return [];
    }
  }

  static Future<void> updateCantidadProductCart(
      int idCarrito, int cantidad) async {
    Dio dio = Dio();

    String url = '${MisRutas.rutaShoppingCart}/$idCarrito';

    Map<String, dynamic> data = {
      'cantidad': cantidad,
    };

    try {
      Response response = await dio.patch(
        url,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('Cantidad actualizada correectamente');
        print(response.data);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  static Future<void> deleteShoppingCart(int idPoductCart) async {
    Dio dio = Dio();

    String url = '${MisRutas.rutaShoppingCart}/$idPoductCart';

    try {
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 202) {
        print('ShoppingCartProducto eliminado correctamente');
      } else if (response.statusCode == 404) {
        print('ShoppingCartProducto no encontrado');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in delete product: $error');
    }
  }

  // No se esta utilizando pero elimina todos los productos aue un usuario tenga en su carrito
  // static Future<void> deleteShopingCardByUser(int idProducto) async {
  //   Dio dio = Dio();

  //   try {
  //     Response response =
  //         await dio.delete('${MisRutas.rutaShoppingCartByProduct}/$idProducto');

  //     if (response.statusCode == 202) {
  //       print('ShoppingCartProducto eliminado correctamente');
  //     } else if (response.statusCode == 404) {
  //       print('ShoppingCartProducto no encontrado');
  //     } else {
  //       print('Error: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error in delete product: $error');
  //   }
  // }
}
