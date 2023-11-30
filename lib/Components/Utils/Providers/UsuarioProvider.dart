import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';

class UsuarioProvider extends ChangeNotifier {
  int? _idUsuario;
  late UsuarioTb _usuario;

  int? get idUsuario => _idUsuario;
  UsuarioTb get usuario => _usuario;

  Future<void> obtenerIdUsuario() async {
    print('se llama a obtenerIdUsuario');
    if (FirebaseAuth.instance.currentUser != null) {
      String? email = FirebaseAuth.instance.currentUser?.email;
      if (email != null) {
        try {
          UsuarioTb usuario = await UsuarioDb.getUsuarioByCorreo(email);
          _idUsuario = usuario.idUsuario;
          _usuario = usuario;
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
