import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class NewsFeedDb {
  static Future<NewsFeedTb> getAllEnlaces() async {
    try {
      // Ejecutar ambas llamadas en paralelo utilizando Future.wait
      final List<NewsFeedTb> results = await Future.wait([
        getAllEnlaceProductos(),
        getAllEnlaceServicios(),
      ]);

      // Combinar las respuestas en una sola lista de NewsFeedItem
      List<NewsFeedItem> combinedList = [];
      for (var result in results) {
        combinedList.addAll(result.newsFeed);
      }

      return NewsFeedTb(combinedList);
    } catch (error) {
      throw Exception('Error fetching enlaces: $error');
    }
  }

  static Future<NewsFeedTb> getAllEnlaceProductos() async {
    Dio dio = Dio();
    String url = MisRutas.rutaEnlaceProductos;

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
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
}
