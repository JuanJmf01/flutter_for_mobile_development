import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Data/models/Publicaciones/enlaces/enlaceProServicioTb.dart';
import 'package:etfi_point/Data/models/newsFeedTb.dart';
import 'package:etfi_point/Data/models/Publicaciones/noEnlaces/publicacionesTb.dart';
import 'package:etfi_point/Data/services/api/Publicaciones/enlaces/enlaceProServicioDb.dart';
import 'package:etfi_point/Data/services/api/Publicaciones/no%20enlaces/publicacionesDb.dart';
import 'package:etfi_point/config/routes/routes.dart';

class NewsFeedDb {
  static Future<NewsFeedTb> getAllNewsFeed(int idUsuarioActual) async {
    List<int> idsEnlaceProductos =
        await EnlaceProServicioDb.getIdEnlaceProServicioSeguidos(
            idUsuarioActual, EnlaceProductoCreacionTb);
    List<int> idsEnlaceServicios =
        await EnlaceProServicioDb.getIdEnlaceProServicioSeguidos(
            idUsuarioActual, EnlaceServicioCreacionTb);
    List<int> idsProductEnlaceReel =
        await EnlaceProServicioDb.getIdEnlaceProServicioSeguidos(
            idUsuarioActual, ProductEnlaceReelCreacionTb);
    List<int> idsServiceEnlaceReel =
        await EnlaceProServicioDb.getIdEnlaceProServicioSeguidos(
            idUsuarioActual, ServiceEnlaceReelCreacionTb);
    List<int> idsReelsPublicacion =
        await PublicacionesDb.getIdsPublicacionesSeguidas(
            idUsuarioActual, ReelCreacionTb);
    List<int> idsFotoPublicacion =
        await PublicacionesDb.getIdsPublicacionesSeguidas(
            idUsuarioActual, PublicacionesCreacionTb);

    print("SEGUIDOS: $idsEnlaceServicios");

    try {
      // Ejecutar ambas llamadas en paralelo utilizando Future.wait
      final List<NewsFeedTb> results = await Future.wait([
        getEnlaceProductosBySeguidos(idUsuarioActual, idsEnlaceProductos),
        getEnlaceServiciosBySeguidos(idUsuarioActual, idsEnlaceServicios),
        getFotoPublicacionesBySeguidos(idUsuarioActual, idsFotoPublicacion),
        getProductReelsBySeguidos(idUsuarioActual, idsProductEnlaceReel),
        getServiceReelsBySeguidos(idUsuarioActual, idsServiceEnlaceReel),
        getReelsPublicacionBySeguidos(idUsuarioActual, idsReelsPublicacion),
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

  static Future<NewsFeedTb> getEnlaceProductosBySeguidos(
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

  static Future<NewsFeedTb> getEnlaceServiciosBySeguidos(
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

  static Future<NewsFeedTb> getFotoPublicacionesBySeguidos(
      int idUsuarioActual, List<int> idsFotoPublicacion) async {
    if (idsFotoPublicacion.isNotEmpty) {
      Dio dio = Dio();
      String url = MisRutas.rutaPublicacionesByIdPublicacion;
      Map<String, dynamic> data = {
        'idUsuario': idUsuarioActual,
        'idsFotosPublicacion': idsFotoPublicacion
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
    } else {
      return NewsFeedTb([]);
    }
  }

  static Future<NewsFeedTb> getProductReelsBySeguidos(
      int idUsuarioActual, List<int> idsEnlaceProductEnlaceReel) async {
    if (idsEnlaceProductEnlaceReel.isNotEmpty) {
      Dio dio = Dio();
      String url = MisRutas.rutaProductEnlaceReelById;
      Map<String, dynamic> data = {
        'idUsuario': idUsuarioActual,
        'idProductoEnlaceReels': idsEnlaceProductEnlaceReel
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
    } else {
      return NewsFeedTb([]);
    }
  }

  static Future<NewsFeedTb> getServiceReelsBySeguidos(
      int idUsuarioActual, List<int> idsServiceEnlaceReel) async {
    if (idsServiceEnlaceReel.isNotEmpty) {
      Dio dio = Dio();
      String url = MisRutas.rutaServiceEnlaceReelById;
      Map<String, dynamic> data = {
        'idUsuario': idUsuarioActual,
        'idServicioEnlaceReels': idsServiceEnlaceReel
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
    } else {
      return NewsFeedTb([]);
    }
  }

  static Future<NewsFeedTb> getReelsPublicacionBySeguidos(
      int idUsuarioActual, List<int> idsReelsPublicacion) async {
    if (idsReelsPublicacion.isNotEmpty) {
      Dio dio = Dio();
      String url = MisRutas.rutaReelByIdReelPublicacion;
      Map<String, dynamic> data = {
        'idUsuario': idUsuarioActual,
        'idsReelPublicacion': idsReelsPublicacion
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
              .map((data) => NeswFeedReelPublicacionTb.fromJsonReel(data))
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
        throw Exception('Error: $error');
      }
    } else {
      return NewsFeedTb([]);
    }
  }
}
