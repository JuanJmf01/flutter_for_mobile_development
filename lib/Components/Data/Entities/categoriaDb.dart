import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:etfi_point/Components/Utils/Providers/subCategoriaSeleccionadaProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  static void obtenerCategorias(
      {int? idProducto, required BuildContext context, required String url}) async {
    print("ENTRA PRIMERO AQUI");

    await context
        .read<SubCategoriaSeleccionadaProvider>()
        .obtenerAllSubCategorias(url);

    if (idProducto != null) {
      await context
          .read<SubCategoriaSeleccionadaProvider>()
          .obtenerSubCategoriasSeleccionadas(idProducto);
    }
  }
}
