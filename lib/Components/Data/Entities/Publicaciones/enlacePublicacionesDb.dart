import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/enlacePublicacionesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:etfi_point/Pages/NewsFeed/newsFeed.dart';

/// En esta clase se realizan las consultas relacionadas a los enlaces
/// de productos y enlaces de servicios. Genericamente; 'enlacePublicaciones'

class EnlacePublicacionesDb {
  static Future<NewsFeedTb> getEnlacePublicaciones(int idUsuario) async {
    Dio dio = Dio();
    try {
      Response response =
          await dio.get('${MisRutas.rutaEnlacesPublicaciones}/$idUsuario');

      if (response.statusCode == 200) {
        List<NewsFeedItem> newsFeed = (response.data as List<dynamic>)
            .map((data) => EnlacePublicacionesTb.fromJson(data))
            .toList();
        return NewsFeedTb(newsFeed);
      } else {
        print('Error: ${response.statusCode}');
        return NewsFeedTb([]);
      }
    } catch (error) {
      print('Error: $error');
      return NewsFeedTb([]);
    }
  }
}
