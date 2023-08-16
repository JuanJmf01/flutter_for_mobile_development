import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class ProductosSubCategorias {
  static Future<List<int>> getProductSelectedSubCategoies(int idProducto) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaProductosSubCategorias}/$idProducto';

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        List<int> idSubCategorias = [];

        for (var productoSubCategoria in response.data) {
          int idSubCategoria = productoSubCategoria['idSubCategoria'];
          idSubCategorias.add(idSubCategoria);
        }

        return idSubCategorias;
      } else {
        throw Exception('Failed to fetch product categories');
      }
    } catch (error) {
      throw Exception('Error de conexión: $error');
    }
  }
}
