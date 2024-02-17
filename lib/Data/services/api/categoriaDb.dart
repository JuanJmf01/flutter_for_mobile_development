import 'package:dio/dio.dart';
import 'package:etfi_point/Data/models/categoriaTb.dart';

// Test here
class CategoriaDb {
  static Future<List<CategoriaTb>> getAllCategorias(String url) async {
    Dio dio = Dio();

    try {
      Response response = await dio.get(url,
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));

      if (response.statusCode == 200) {
        List<CategoriaTb> categorias = (response.data as List<dynamic>)
            .map((data) => CategoriaTb.fromJson(data))
            .toList();
        //print('MisCategorias y subCateogirias: $categorias');
        return categorias;
      } else {
        throw Exception('Failed to fetch category');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  // static void obtenerCategorias(
  //   BuildContext context,
  //   String url,
  // ) async {
  //   await context
  //       .read<SubCategoriaSeleccionadaProvider>()
  //       .obtenerAllSubCategorias(url);
  // }
}
