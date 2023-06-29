import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/negocioTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class NegocioDb {
  static const tableName = "negocios";

  // -------- Consultas despues de la migracion a mySQL --------- //

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

  //Funcion para obtener un unico negocio por idUsuario
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
