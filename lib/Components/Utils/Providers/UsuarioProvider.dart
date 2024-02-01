import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';

class UsuarioProvider extends ChangeNotifier {
  // VERIFICAR LA OPCION DE UTILIZAR UNA VERIABLE ENTERA PARA ID NEGOCIO ACTUAL EN CASO DE QUE EL UISAURIO ACTUAL TENGA UN NEGOCIO
  int? _idUsuarioActual;
  UsuarioTb? _usuarioActual;

  int? get idUsuarioActual => _idUsuarioActual;
  UsuarioTb? get usuarioActual => _usuarioActual;

  Future<int?> obtenerIdUsuarioActual() async {
    if (FirebaseAuth.instance.currentUser != null) {
      print('se llama a obtenerIdUsuario');
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
          // Manej  o de errores
          print('Error al obtener el idUsuario o usuario no inicia sesión: $e');
          throw Exception('Error al obtener el idUsuario');
        }
      }
    } else {
      print("Wl usuario no esta logueado");
      if (_idUsuarioActual != null) {
        _idUsuarioActual = null;
        notifyListeners();
      }
      if (_usuarioActual != null) {
        _usuarioActual = null;
        notifyListeners();
      }
    }
    return null;
  }
}
