import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class UsuarioDb {
  static const tableName = "usuarios";

  // Obtener idUsuario mediante el correo en firebase

// -------- Consultas despues de la migracion a mySQL --------- //

  static Future<void> insertUsuario(UsuarioCreacionTb usuario) async {
    Dio dio = Dio();
    //Se convierte un usuario de tipo UsuarioCreacionTb a un tipo Map<String, dynamic>
    //De esta manera podemos convertirlo a un json ya que la api recibe en json
    Map<String, dynamic> data = usuario.toMap();
    String url = MisRutas.rutaUsuarios;

    try {
      Response response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('Usuario insertado correctamente (print)');
        print(response.data);
        // Realiza las operaciones necesarias con la respuesta
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      // Ocurrió un error en la conexión
      print('Error de conexión: $error');
    }
  }

  static Future<UsuarioTb?> getUsuarioByCorreo(String correo) async {
    Dio dio = Dio();
    String url = MisRutas.rutaUsuarios;

    try {
      Map<String, dynamic> data = {
        'email': correo,
      };

      Response response = await dio.get(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        UsuarioTb usuario = UsuarioTb.fromJson(response.data);
        return usuario;
      }else if(response.statusCode == 404){
        return null;
      } else {
        throw Exception('Error en la respuesta: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
    }
  }

  static Future<bool> ifExistsUserByEmail(String email) async {
    try {
      print('ifExistsUserByEmail llega aca');
      UsuarioTb? usuario = await getUsuarioByCorreo(email);

      if (usuario != null) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      //throw Exception('Error en la respuesta: $error');
      print('Error en la  respuesta ifExistUserByEmail: $error');
      return false;
    }
  }
}
