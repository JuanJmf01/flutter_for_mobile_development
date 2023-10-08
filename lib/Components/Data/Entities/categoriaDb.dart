import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class CategoriaDb {
  static Future<List<CategoriaTb>> getAllCategorias() async {
    Dio dio = Dio();
    String url = MisRutas.rutaCategorias2;

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
}
