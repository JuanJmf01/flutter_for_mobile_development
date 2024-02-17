import 'package:dio/dio.dart';

import 'package:etfi_point/Data/models/subCategoriaTb.dart';
import 'package:etfi_point/config/routes/routes.dart';

class SubCategoriasDb {
  static Future<List<SubCategoriaTb>> getSubCategoriasByProducto(
      String url) async {
    Dio dio = Dio();

    try {
      Response response = await dio.get(url,
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data;
        List<SubCategoriaTb> subCategorias = jsonList.map((json) {
          return SubCategoriaTb.fromJson(json);
        }).toList();

        return subCategorias;
      } else {
        throw Exception('Error en la solicitud ${response.statusCode}');
      }
    } catch (error) {
      print("No se encontraron categorias o ha ocurrido un error $error");
      return [];
    }
  }

  static Future<List<SubCategoriaTb>> getSubCategorias(int idCategoria) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaSubCategoriasByCategoria}/$idCategoria';

    try {
      Response response = await dio.get(url,
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));

      if (response.statusCode == 200) {
        List<SubCategoriaTb> subCategorias = List<SubCategoriaTb>.from(response
            .data
            .map((subCategoria) => SubCategoriaTb.fromJson(subCategoria)));

        return subCategorias;
      } else {
        throw Exception('Error en la solicitud ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
