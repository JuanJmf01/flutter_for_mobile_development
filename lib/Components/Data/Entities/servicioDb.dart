import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioSubCategoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/serviciosSubCategoriasDb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class ServicioDb {
  static Future<int> insertServicio(ServicioCreacionTb servicio,
      List<SubCategoriaTb> categoriasSeleccionadas) async {
    print('Servicio: $servicio');
    print('categorias: $categoriasSeleccionadas');

    Dio dio = Dio();
    Map<String, dynamic> data = servicio.toMap();
    String url = MisRutas.rutaServicios;

    try {
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
      if (response.statusCode == 200) {
        print('Servicio insertado correctamenre (print)');
        print(response.data);
        int idServicio = response.data;

        // Insert categorias seleccionadas
        for (var subCategoria in categoriasSeleccionadas) {
          ProServicioSubCategoriaTb servicioSubCategoria =
              ProServicioSubCategoriaTb(
                  idProServicio: idServicio,
                  idCategoria: subCategoria.idCategoria,
                  idSubCategoria: subCategoria.idSubCategoria);

          await ServiciosSubCategoriasDb.insertSubCategoriasSeleccionadas(
              servicioSubCategoria);
        }
        return idServicio;
      } else {
        throw Exception(
            'Error en la solicitud en insertServicio: ${response.statusCode}');
      }
    } catch (error) {
      print('Ha ocurrido un error $error');
      throw Exception('Error de conexión: $error');
    }
  }
}
