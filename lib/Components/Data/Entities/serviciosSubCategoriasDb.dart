import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioSubCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class ServiciosSubCategoriasDb {
  static Future<void> insertSubCategoriasSeleccionadas(
      ProServicioSubCategoriaTb productoSubCategoria) async {
    print("LLEGA productoSubCategoria_: $productoSubCategoria");
    Dio dio = Dio();
    Map<String, dynamic> data = productoSubCategoria.toMapServicio();
    String url = MisRutas.rutaServiciosSubCategorias;

    try {
      Response response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('servicioSubCategoria insertado correctamente (print)');
        print(response.data);
        // Realiza las operaciones necesarias con la respuesta
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      // Ocurrió un error en la conexión
      print('Error de conexiónN: $error');
    }
  }
}
