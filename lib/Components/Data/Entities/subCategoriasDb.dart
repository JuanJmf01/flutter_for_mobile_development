import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/proServiceSubCategoriasDb.dart';

import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class SubCategoriasDb {
  static Future<SubCategoriaTb> getSubCategoria(
      int idSubCategoria, Type objectType) async {
    Dio dio = Dio();
    String url = '';
    if (objectType == ProductoTb) {
      url = '${MisRutas.rutaSubCategorias}/$idSubCategoria';
    } else if (objectType == ServicioTb) {
      print("id subcategorias_: $idSubCategoria");
      url = '${MisRutas.rutaSubCategoriaServicios}/$idSubCategoria';
    }

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

  static Future<List<SubCategoriaTb>> getSubCategoriasByProducto(
      int idProServicio, Type objectType) async {
    try {
      List<int> idSubCategoriesByProduct =
          await ProServiceSubCategoriasDb.getProServiceSelectedSubCategoies(
              idProServicio, objectType);

      print("subcategorias: $idSubCategoriesByProduct");

      List<SubCategoriaTb> subCategorias = [];

      for (int idSubCategoria in idSubCategoriesByProduct) {
        SubCategoriaTb subCategoria =
            await getSubCategoria(idSubCategoria, objectType);
        subCategorias.add(subCategoria);
      }

      return subCategorias;
    } catch (error) {
      print('No hay subCategorias que mostrar');
      return [];
      // throw Exception('Error en la solicitud: $error');
    }
  }
}
