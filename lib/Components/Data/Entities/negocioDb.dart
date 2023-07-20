import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/negocioTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';


class NegocioDb {
  // -------- Consultas despues de la migracion a mySQL --------- //

  /// The function `insertNegocio` sends a POST request to a specified URL with a JSON payload, and
  /// returns the ID of the inserted negocio if the request is successful.
  ///
  /// Args:
  ///   negocio (NegocioCreacionTb): The parameter "negocio" is of type "NegocioCreacionTb", which is a
  /// custom class representing a business entity. It contains the necessary data to create a new business
  /// entry.
  ///
  /// Returns:
  ///   a Future<int>.

  static Future<int> insertNegocio(NegocioCreacionTb negocio) async {
    Dio dio = Dio();
    //Se convierte un negocio de tipo negocioCreacionTb a un tipo Map<String, dynamic>
    //De esta manera podemos convertirlo a un json ya que la api recibe en json
    Map<String, dynamic> data = negocio.toMap();
    String url = MisRutas.rutaNegocios;

    try {
      Response response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));
      if (response.statusCode == 200) {
        int idNegocio = response.data;
        print('Negocio insertado correctamente (print)');
        return idNegocio;
      } else {
        throw Exception(
            'Error en la solicitud en insertNegocio: ${response.statusCode}');
      }
    } catch (error) {
      // Ocurrió un error en la conexión
      print('Error de conexión: $error');
      throw Exception('Error de conexión: $error');
    }
  }

  /// The function `getNegocio` retrieves a `NegocioTb` object from an API endpoint based in `idUsuario`.
  ///
  /// Args:
  ///   idUsuario (int): The parameter `idUsuario` is an integer representing the ID of the user. It is
  /// used to obtain the information of the corresponding business
  ///
  /// Returns:
  ///   a Future object that resolves to a NegocioTb object or null.
  static Future<NegocioTb?> getNegocio(int idUsuario) async {
    try {
      Dio dio = Dio();
      Response response = await dio.get('${MisRutas.rutaNegocios}/$idUsuario');
      if (response.statusCode == 200) {
        final negocioJson = response.data as Map<String, dynamic>;
        return NegocioTb.fromJson(negocioJson);
      } else if (response.statusCode == 404) {
        return null;
      }
    } catch (error) {
      print('Error al obtener el negocio: $error');
    }
    return null;
  }
}
