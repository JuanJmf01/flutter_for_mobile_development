import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Data/models/newsFeedTb.dart';
import 'package:etfi_point/config/routes/routes.dart';

/// En esta clase se realizan las consultas relacionadas a los enlaces
/// de productos y enlaces de servicios. Genericamente; 'enlacePublicaciones'
///

class EnlacePublicacionesDb {

    // EnlacePublicacionesImages 

  static Future<NewsFeedTb> getAllEnlacePublicacionesImages(
      int idUsuarioActual) async {
    try {
      // Ejecutar ambas llamadas en paralelo utilizando Future.wait
      final List<NewsFeedTb> results = await Future.wait([
        getEnlaceProductosByUsuario(idUsuarioActual),
        //getEnlaceServiciosByUsuario(idUsuarioActual),
      ]);

      // Combinar las respuestas en una sola lista de NewsFeedItem
      List<NewsFeedItem> combinedList = [];
      for (var result in results) {
        combinedList.addAll(result.newsFeed);
      }

      combinedList.sort((a, b) {
        DateTime fechaA = a.getFechaCreacion();
        DateTime fechaB = b.getFechaCreacion();

        return fechaB.compareTo(fechaA);
      });

      return NewsFeedTb(combinedList);
    } catch (error) {
      throw Exception('Error fetching enlaces: $error');
    }
  }
  
  static Future<NewsFeedTb> getEnlaceProductosByUsuario(
      int idUsuarioActual) async {
    Dio dio = Dio();
    String url = MisRutas.rutaEnlaceProductos;

    Map<String, dynamic> data = {
      'idUsuario': idUsuarioActual,
      'offSet': 0,
    };

    try {
      Response response = await dio.get(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print("Dataaaa:  ${response.data}");
        List<NewsFeedItem> newsFeed = (response.data as List<dynamic>)
            .map((data) => NewsFeedProductosTb.fromJson(data))
            .toList();

        return NewsFeedTb(newsFeed);
      } else {
        throw Exception('Failed to fetch enlaceProductos');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  static Future<NewsFeedTb> getEnlaceServiciosByUsuario(
      int idUsuarioActual, String url) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaEnlaceServicios}/$idUsuarioActual';

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print("Dataaaa:  ${response.data}");
        List<NewsFeedItem> newsFeed = (response.data as List<dynamic>)
            .map((data) => NewsFeedServiciosTb.fromJson(data))
            .toList();

        return NewsFeedTb(newsFeed);
      } else {
        throw Exception('Failed to fetch enlaceProductos');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }


  // EnlacePublicacionesReels 





}
