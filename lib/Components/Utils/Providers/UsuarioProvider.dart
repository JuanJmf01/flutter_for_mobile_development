import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';

class UsuarioProvider extends ChangeNotifier {
  int? _idUsuarioActual;
  late UsuarioTb _usuarioActual;

  int? get idUsuarioActual => _idUsuarioActual;
  UsuarioTb get usuarioActual => _usuarioActual;

  Future<void> obtenerIdUsuarioActual() async {
    print('se llama a obtenerIdUsuario');
    if (FirebaseAuth.instance.currentUser != null) {
      String? email = FirebaseAuth.instance.currentUser?.email;
      if (email != null) {
        try {
          UsuarioTb? usuario = await UsuarioDb.getUsuarioByCorreo(email);
          if (usuario != null) {
            _idUsuarioActual = usuario.idUsuario;
            _usuarioActual = usuario;
          } else {
            print("IdUsuario es null en UsuarioProvider");
          }
          notifyListeners();
        } catch (e) {
          // Manejo de errores
          print('Error al obtener el idUsuario o usuario no inicia sesion: $e');
          throw Exception('Error al obtener el idUsuario');
        }
      }
    }
  }
}
