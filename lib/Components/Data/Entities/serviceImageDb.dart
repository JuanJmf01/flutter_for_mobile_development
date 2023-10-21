import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class ServiceImageDb {
  static Future<ProservicioImagesTb> insertServiceImage(
      ProServicioImageCreacionTb serviceImage) async {
    print("MI SERVICIO IMAGE: $serviceImage");
    Dio dio = Dio();
    String url = MisRutas.rutaServiceImages;
    Map<String, dynamic> data = serviceImage.toMapServicios();

    try {
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('serviceImage insertado correctamente (print)');
        ProservicioImagesTb serviceImage =
            ProservicioImagesTb.fromJsonServicios(response.data);

        return serviceImage;
      } else {
        throw Exception('Error en la respuesta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
      throw Exception('Error en la solicitud: $error');
    }
  }

  // Verificar la posibilidad de eliminar este metodo y hacerlo uno solo junto con 'getProductSecondaryImages'
  static Future<List<ProservicioImagesTb>> getServiceSecondaryImages(
      int idServicio) async {
    Dio dio = Dio();

    try {
      Response response =
          await dio.get('${MisRutas.rutaServiceImages}/$idServicio');

      if (response.statusCode == 200) {
        List<ProservicioImagesTb> productSecondaryImages =
            List<ProservicioImagesTb>.from(response.data.map((serviceData) =>
                ProservicioImagesTb.fromJsonServicios(serviceData)));
        print('ServicioImageingetSecond: $productSecondaryImages');
        return productSecondaryImages;
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  static Future<bool> deleteServiceImage(int idServiceImage) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaServiceImage}/$idServiceImage';
    print("URL : $url");

    try {
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 202) {
        print('ServiceImage eliminado correctamente');
        return true;
      } else if (response.statusCode == 404) {
        print('ServiceImage no encontrado');
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión en: $error');
    }
    return false;
  }
}
