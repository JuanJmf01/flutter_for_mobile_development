import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class NewsFeedDb {
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
            .map((data) => NeswFeedProductosTb.fromJson(data))
            .toList();

        return NewsFeedTb(newsFeed);
      } else {
        throw Exception('Failed to fetch enlaceProServicios');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
