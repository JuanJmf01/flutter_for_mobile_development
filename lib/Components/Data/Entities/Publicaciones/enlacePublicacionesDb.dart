import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

/// En esta clase se realizan las consultas relacionadas a los enlaces
/// de productos y enlaces de servicios. Genericamente; 'enlacePublicaciones'
///

class EnlacePublicacionesDb {
  static Future<NewsFeedTb> getAllNewsFeed(int idUsuarioActual) async {
    try {
      // Ejecutar ambas llamadas en paralelo utilizando Future.wait
      final List<NewsFeedTb> results = await Future.wait([
        getEnlaceProductosByUsuario(idUsuarioActual),
        getEnlaceServiciosByUsuario(idUsuarioActual),
        
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
    String url =
        '${MisRutas.rutaEnlaceProductos}/$idUsuarioActual';

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
      int idUsuarioActual) async {
    Dio dio = Dio();
    String url =
        '${MisRutas.rutaEnlaceServicios}/$idUsuarioActual';

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

  // static Future<NewsFeedTb> getEnlacePublicaciones(int idUsuario) async {
  //   Dio dio = Dio();
  //   try {
  //     Response response =
  //         await dio.get('${MisRutas.rutaEnlacesPublicaciones}/$idUsuario');

  //     if (response.statusCode == 200) {
  //       List<NewsFeedItem> newsFeed = (response.data as List<dynamic>)
  //           .map((data) => EnlacePublicacionesTb.fromJson(data))
  //           .toList();
  //       return NewsFeedTb(newsFeed);
  //     } else {
  //       print('Error: ${response.statusCode}');
  //       return NewsFeedTb([]);
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     return NewsFeedTb([]);
  //   }
  // }
}
