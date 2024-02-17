import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Data/models/proServicioSubCategoriaTb.dart';
import 'package:etfi_point/Data/models/servicioTb.dart';
import 'package:etfi_point/Data/models/subCategoriaTb.dart';
import 'package:etfi_point/Data/services/api/negocioDb.dart';
import 'package:etfi_point/Data/services/api/proServiceSubCategoriasDb.dart';
import 'package:etfi_point/Data/services/api/ratingsDb.dart';
import 'package:etfi_point/Data/services/api/serviceImageDb.dart';
import 'package:etfi_point/config/routes/routes.dart';

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
            idSubCategoria: subCategoria.idSubCategoria,
          );

          await ProServiceSubCategoriasDb.insertSubCategoriasSeleccionadas(
              servicioSubCategoria, ServicioTb);
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

  static Future<void> deleteServicio(int idServicio) async {
    Dio dio = Dio();
    String urlSubCategorias =
        '${MisRutas.rutaServiciosSubCategorias}/$idServicio';
    try {
      bool result =
          await ProServiceSubCategoriasDb.deleteProServicioSubCategories(
              idServicio, urlSubCategorias);
      if (result) {
        result = await ServiceImageDb.deleteServiceImages(idServicio);
      } else {
        print('problemas al eliminar ServiceImage');
      }

      print('resulDelete_: $result');
      if (result) {
        String urlRating = '${MisRutas.rutaServiceRatings}/$idServicio';

        await RatingsDb.deleteRatingsByProServicio(idServicio, urlRating);
        Response response =
            await dio.delete('${MisRutas.rutaServicios}/$idServicio');

        if (response.statusCode == 202) {
          print('Servicio eliminado correctamente');
        } else if (response.statusCode == 404) {
          print('Servicio no encontrado');
        } else {
          print('Error: ${response.statusCode}');
        }
      } else {
        print('No se pudieron eliminar servicioSubCategoria');
      }
    } catch (error) {
      print('Error in delete service: $error');
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

  static Future<void> updateServicio(
      ServicioTb servicio, List<SubCategoriaTb> categoriasSeleccionadas) async {
    print("CATEGORIAS SELECCIONADAS : $categoriasSeleccionadas");

    int idServicio = servicio.idServicio;
    Dio dio = Dio();
    String url = '${MisRutas.rutaServicios}/$idServicio';

    try {
      String urlSubCategorias =
          '${MisRutas.rutaServiciosSubCategorias}/$idServicio';
      await ProServiceSubCategoriasDb.deleteProServicioSubCategories(
          idServicio, urlSubCategorias);
      for (var subCategoria in categoriasSeleccionadas) {
        ProServicioSubCategoriaTb servicioCategoria = ProServicioSubCategoriaTb(
          idSubCategoria: subCategoria.idSubCategoria,
          idProServicio: idServicio,
          idCategoria: subCategoria.idCategoria,
        );

        await ProServiceSubCategoriasDb.insertSubCategoriasSeleccionadas(
            servicioCategoria, ServicioTb);
      }

      Response response = await dio.patch(
        url,
        data: servicio.toMap(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('Servicio actualizado correctamente');
        print(response.data);
        // Realiza las operaciones necesarias con la respuesta
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      // Ocurrió un error en la conexión
      print('Error de conexión: $error');
    }
  }
}
