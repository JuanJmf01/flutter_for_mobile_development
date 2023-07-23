import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosSubCategorias.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class subCategoriasDb {
  static Future<SubCategoriaTb> getSubCategoria(int idSubCategoria) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaSubCategorias}/$idSubCategoria';

    try {
      Response response = await dio.get(url,
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));

      if (response.statusCode == 200) {
        SubCategoriaTb subCategoria = SubCategoriaTb.fromJson(response.data);

        return subCategoria;
      } else {
        throw Exception('Error en la solicitud ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  static Future<List<SubCategoriaTb>> getSubCategoriasSeleccionadas(
      int idProducto) async {
    Dio dio = Dio();

    try {
      List<int> idSubCategoriesByProduct =
          await ProductosSubCategorias.getProductSelectedSubCategoies(
              idProducto);

      List<SubCategoriaTb> subCategorias = [];

      for (int idSubCategoria in idSubCategoriesByProduct) {
        SubCategoriaTb subCategoria = await getSubCategoria(idSubCategoria);
        subCategorias.add(subCategoria);
      }

      return subCategorias;
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
    }
  }
}
