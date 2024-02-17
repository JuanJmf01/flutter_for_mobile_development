import 'package:dio/dio.dart';
import 'package:etfi_point/Data/models/proServicioImagesTb.dart';
import 'package:etfi_point/config/routes/routes.dart';

class ServiceImageDb {


 /// The function `insertServiceImage` sends a POST request to a specified URL with the provided service
 /// image data and returns the inserted service image if successful.
 /// 
 /// Args:
 ///   serviceImage (ProServicioImageCreacionTb): The parameter `serviceImage` is an instance of the
 /// class `ProServicioImageCreacionTb`. It represents the data of a service image that needs to be
 /// inserted into a database.
 /// 
 /// Returns:
 ///   a Future object of type ProservicioImagesTb.
  static Future<ProservicioImagesTb> insertServiceImage(
      ProServicioImageCreacionTb serviceImage) async {
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

  /// The function `getServiceSecondaryImages` retrieves a list of secondary images for a given service
  /// ID using the Dio package in Dart.
  /// 
  /// Args:
  ///   idServicio (int): The parameter `idServicio` is an integer that represents the ID of a service.
  /// It is used to fetch the secondary images associated with that service.
  /// 
  /// Returns:
  ///   a Future object that resolves to a List of ProservicioImagesTb objects.
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

  /// The function `deleteServiceImages` sends a DELETE request to a specified URL to delete service
  /// images and returns a boolean value indicating whether the deletion was successful or not.
  /// 
  /// Args:
  ///   idServicio (int): The parameter `idServicio` is an integer that represents the ID of the service
  /// for which you want to delete the images.
  /// 
  /// Returns:
  ///   a Future<bool>.
  static Future<bool> deleteServiceImages(int idServicio) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaServiceImages}/$idServicio';

    try {
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 202) {
        print('ServiceImages eliminados correctamente');
        return true;
      } else if (response.statusCode == 404) {
        print('ServiceImages no encontrado');
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
    return false;
  }

  /// The function `deleteServiceImage` is a static method that sends a DELETE request to a specified
  /// URL to delete a service image, and returns a boolean value indicating whether the deletion was
  /// successful or not.
  /// 
  /// Args:
  ///   idServiceImage (int): The parameter `idServiceImage` is the ID of the service image that you
  /// want to delete.
  /// 
  /// Returns:
  ///   a Future<bool>.
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
