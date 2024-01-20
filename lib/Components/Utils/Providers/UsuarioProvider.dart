import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';

class UsuarioProvider extends ChangeNotifier {
  // VERIFICAR LA OPCION DE UTILIZAR UNA VERIABLE ENTERA PARA ID NEGOCIO ACTUAL EN CASO DE QUE EL UISAURIO ACTUAL TENGA UN NEGOCIO
  late int _idUsuarioActual;
  late UsuarioTb _usuarioActual;

  int get idUsuarioActual => _idUsuarioActual;
  UsuarioTb get usuarioActual => _usuarioActual;

  Future<int> obtenerIdUsuarioActual() async {
    print('se llama a obtenerIdUsuario');
    if (FirebaseAuth.instance.currentUser != null) {
      String? email = FirebaseAuth.instance.currentUser?.email;
      if (email != null) {
        try {
          UsuarioTb? usuario = await UsuarioDb.getUsuarioByCorreo(email);
          if (usuario != null) {
            _idUsuarioActual = usuario.idUsuario;
            _usuarioActual = usuario;
            notifyListeners();
            return usuario.idUsuario;
          } else {
            print("IdUsuario es null en UsuarioProvider");
          }
        } catch (e) {
          // Manejo de errores
          print('Error al obtener el idUsuario o usuario no inicia sesión: $e');
          throw Exception('Error al obtener el idUsuario');
        }
      }
    }
    throw Exception('Error al obtener el idUsuario');
  }
}
