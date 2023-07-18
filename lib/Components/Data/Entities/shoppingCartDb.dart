import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/shoppingCartTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class ShoppingCartDb {
  static const tableName = "shoppingCart";

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
      print('Error: $error');
      return [];
    }
  }
}
