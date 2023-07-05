import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';

class UsuarioProvider extends ChangeNotifier {
  int? _idUsuario;

  int? get idUsuario => _idUsuario;

  Future<void> obtenerIdUsuario() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String? email = FirebaseAuth.instance.currentUser?.email;
      if (email != null) {
        try {
          int? idUsuario = await UsuarioDb.getIdUsuarioByCorreo(email);
          if (idUsuario != null) {
            _idUsuario = idUsuario;
            notifyListeners();
          }else{
            print('ID Usuario null: $_idUsuario');
          }
        } catch (e) {
          // Manejo de errores
          print('Error al obtener el idUsuario o usuario no inicia sesion: $e');
          throw Exception('Error al obtener el idUsuario');
        }
      }
    }
  }
}
