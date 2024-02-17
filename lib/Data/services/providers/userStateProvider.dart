import 'package:etfi_point/Data/services/Auth/auth.dart';
import 'package:etfi_point/Data/services/api/usuarioDb.dart';
import 'package:etfi_point/Data/models/usuarioTb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStateProvider = StateProvider<bool>((ref) {
  return Auth.isUserSignedIn();
});

final getCurrentUserProvider = FutureProvider<int?>((ref) async {
  bool result = ref.watch(userStateProvider);
  if (result) {
    User? firebaseUser = Auth.getCurrentUser();
    String? email = firebaseUser?.email;
    if (email != null) {
      UsuarioTb? user = await UsuarioDb.getUsuarioByCorreo(email);
      if (user != null) {
        return user.idUsuario;
      }
    }
  }
  return null;
});
