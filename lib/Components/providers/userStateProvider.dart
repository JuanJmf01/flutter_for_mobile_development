import 'package:etfi_point/Components/Auth/auth.dart';
import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStateProvider = StateProvider<bool>((ref) {
  return Auth.isUserSignedIn();
});

final getCurrentUserProvider = FutureProvider<int?>((ref) async {
  User? firebaseUser = Auth.getCurrentUser();
  print("FIREBASE USER: ${firebaseUser?.email}");
  if (firebaseUser != null) {
    String? email = firebaseUser.email;
    if (email != null) {
      UsuarioTb? user = await UsuarioDb.getUsuarioByCorreo(email);
      if (user != null) {
        return user.idUsuario;
      }
    }
  }
  return null;
});
