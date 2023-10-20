import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioSubCategoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
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

   static Future<List<ServicioTb>> getServiciosByNegocio(int idUsuario) async {
    Dio dio = Dio();

    try {
      int? idNegocio = await NegocioDb.checkBusinessExists(idUsuario);
      print('idNegocio: $idNegocio');
      if (idNegocio != null) {
        Response response =
            await dio.get('${MisRutas.rutaServiciosByNegocio}/$idNegocio');

        if (response.statusCode == 200) {
          print('llega dentro del if getserviciosByNegoicio');
          List<ServicioTb> servicios = List<ServicioTb>.from(response.data
              .map((servicioData) => ServicioTb.fromJson(servicioData)));
          print('servicios_: $servicios');
          return servicios;
        } else {
          print('Error: ${response.statusCode}');
          return [];
        }
      } else {
        print('idNegocio no encontrado. Crea un negocio');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

    static Future<ServicioTb> getServicio(int idServicio) async {
    Dio dio = Dio();

    try {
      Response response =
          await dio.get('${MisRutas.rutaServicios}/$idServicio');
      if (response.statusCode == 200) {
        ServicioTb servicio = ServicioTb.fromJson(response.data);
        return servicio;
      } else {
        throw Exception('Error en la respuesta: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
    }
  }

}
