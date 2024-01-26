import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/enlaces/enlaceProServicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Entities/enlaces/enlaceProServicioDb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class NewsFeedDb {
  static Future<NewsFeedTb> getAllNewsFeed(int idUsuarioActual) async {
    List<int> idsEnlaceProductos =
        await EnlaceProServicioDb.getIdEnlaceProServicioSeguidos(
            idUsuarioActual, EnlaceProductoCreacionTb);
    List<int> idsEnlaceServicios =
        await EnlaceProServicioDb.getIdEnlaceProServicioSeguidos(
            idUsuarioActual, EnlaceServicioCreacionTb);
    List<int> idsEnlaceProductEnlaceReel =
        await EnlaceProServicioDb.getIdEnlaceProServicioSeguidos(
            idUsuarioActual, ProductEnlaceReelCreacionTb);

    print("SEGUIDOS: $idsEnlaceProductEnlaceReel");

    try {
      // Ejecutar ambas llamadas en paralelo utilizando Future.wait
      final List<NewsFeedTb> results = await Future.wait([
        //getEnlaceProductosBySeguidores(idUsuarioActual, idsEnlaceProductos),
        //getAllEnlaceServicios(idUsuarioActual, idsEnlaceServicios),
        // getAllPublicaciones(idUsuarioActual),
        getAllProductReels(idUsuarioActual, idsEnlaceProductEnlaceReel),
        // getAllServiceReels(idUsuarioActual),
        // getAllOnlyReels(idUsuarioActual),
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

  static Future<NewsFeedTb> getEnlaceProductosBySeguidores(
      int idUsuarioActual, List<int> enlaceProductos) async {
    if (enlaceProductos.isNotEmpty) {
      Dio dio = Dio();
      String url = MisRutas.rutaEnlaceProductosByEnlaceProducto;

      Map<String, dynamic> data = {
        'idUsuario': idUsuarioActual,
        'idEnlaceProductos': enlaceProductos
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
    } else {
      return NewsFeedTb([]);
    }
  }

  static Future<NewsFeedTb> getAllEnlaceServicios(
      int idUsuarioActual, List<int> enlaceServicios) async {
    if (enlaceServicios.isNotEmpty) {
      Dio dio = Dio();
      String url = MisRutas.rutaEnlaceServicioByEnlaceServicio;
      Map<String, dynamic> data = {
        'idUsuario': idUsuarioActual,
        'idEnlaceServicios': enlaceServicios,
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
    } else {
      return NewsFeedTb([]);
    }
  }

  static Future<NewsFeedTb> getAllPublicaciones(int idUsuarioActual) async {
    Dio dio = Dio();
    String url = MisRutas.rutaPublicaciones;
    Map<String, dynamic> data = {'idUsuario': idUsuarioActual};

    try {
      Response response = await dio.get(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        List<NewsFeedItem> newsFeed = (response.data as List<dynamic>)
            .map((data) => NeswFeedPublicacionesTb.fromJson(data))
            .toList();

        return NewsFeedTb(newsFeed);
      } else if (response.statusCode == 404) {
        print("No hay enlacesDeServicios que mostrar");
        return NewsFeedTb([]);
      } else {
        throw Exception('Failed to fetch enlaceServicios');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  static Future<NewsFeedTb> getAllProductReels(
      int idUsuarioActual, List<int> idsEnlaceProductEnlaceReel) async {
    Dio dio = Dio();
    String url = MisRutas.rutaProductEnlaceReels;
    Map<String, dynamic> data = {
      'idUsuario': idUsuarioActual,
      'idProductoEnlaceReels': [1,2]
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

  static Future<NewsFeedTb> getAllServiceReels(int idUsuarioActual) async {
    Dio dio = Dio();
    String url = MisRutas.rutaServiceEnlaceReels;
    Map<String, dynamic> data = {'idUsuario': idUsuarioActual};

    try {
      Response response = await dio.get(
        url,
        data: jsonEncode(data),
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

  static Future<NewsFeedTb> getAllOnlyReels(int idUsuarioActual) async {
    Dio dio = Dio();
    String url = MisRutas.rutaOnlyReels;
    Map<String, dynamic> data = {'idUsuario': idUsuarioActual};

    try {
      Response response = await dio.get(
        url,
        data: jsonEncode(data),
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
