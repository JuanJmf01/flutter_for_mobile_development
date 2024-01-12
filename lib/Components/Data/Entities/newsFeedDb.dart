import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class NewsFeedDb {
  static Future<NewsFeedTb> getAllNewsFeed(int idUsuario) async {
    try {
      // Ejecutar ambas llamadas en paralelo utilizando Future.wait
      final List<NewsFeedTb> results = await Future.wait([
        getAllEnlaceProductos(idUsuario),
        //getAllEnlaceServicios(),
        //getAllPublicaciones(),
        //getAllProductReels(),
        //getAllServiceReels(),
        //getAllOnlyReels(),
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

  static Future<NewsFeedTb> getAllEnlaceProductos(int idUsuario) async {
    Dio dio = Dio();
    String url = MisRutas.rutaEnlaceProductos;
    Map<String, dynamic> data = {'idUsuario': idUsuario};

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

  static Future<NewsFeedTb> getAllEnlaceServicios() async {
    Dio dio = Dio();
    String url = MisRutas.rutaEnlaceServicios;

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        List<NewsFeedItem> newsFeed = (response.data as List<dynamic>)
            .map((data) => NewsFeedServiciosTb.fromJson(data))
            .toList();

        return NewsFeedTb(newsFeed);
      } else {
        throw Exception('Failed to fetch enlaceServicios');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  static Future<NewsFeedTb> getAllPublicaciones() async {
    Dio dio = Dio();
    String url = MisRutas.rutaPublicaciones;

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        List<NewsFeedItem> newsFeed = (response.data as List<dynamic>)
            .map((data) => NeswFeedPublicacionesTb.fromJson(data))
            .toList();

        return NewsFeedTb(newsFeed);
      } else {
        throw Exception('Failed to fetch enlaceServicios');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  static Future<NewsFeedTb> getAllProductReels() async {
    Dio dio = Dio();
    String url = MisRutas.rutaProductEnlaceReels;

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        List<NewsFeedItem> newsFeed = (response.data as List<dynamic>)
            .map((data) => NeswFeedReelProductTb.fromJsonReelProducto(data))
            .toList();

        return NewsFeedTb(newsFeed);
      } else {
        throw Exception('Failed to fetch enlaceProductReels');
      }
    } catch (error) {
      print('Error: $error');
      return NewsFeedTb([]);
    }
  }

  static Future<NewsFeedTb> getAllServiceReels() async {
    Dio dio = Dio();
    String url = MisRutas.rutaServiceEnlaceReels;

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        List<NewsFeedItem> newsFeed = (response.data as List<dynamic>)
            .map((data) => NeswFeedReelServiceTb.fromJsonReelServicio(data))
            .toList();

        return NewsFeedTb(newsFeed);
      } else if (response.statusCode == 404) {
        print("No se encontraron filas. Vacio");
        return NewsFeedTb([]);
      } else {
        throw Exception('Failed to fetch enlaceServiceReels');
      }
    } catch (error) {
      print('Error: $error');
      return NewsFeedTb([]);
    }
  }

  static Future<NewsFeedTb> getAllOnlyReels() async {
    Dio dio = Dio();
    String url = MisRutas.rutaOnlyReels;

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode == 200) {
        List<NewsFeedItem> newsFeed = (response.data as List<dynamic>)
            .map((data) => NeswFeedOnlyReelTb.fromJsonReel(data))
            .toList();

        return NewsFeedTb(newsFeed);
      } else if (response.statusCode == 404) {
        print("No se encontraron filas. Vacio");
        return NewsFeedTb([]);
      } else {
        throw Exception('Failed to fetch onlyReels');
      }
    } catch (error) {
      print('Error_:: $error');
      return NewsFeedTb([]);
    }
  }
}
