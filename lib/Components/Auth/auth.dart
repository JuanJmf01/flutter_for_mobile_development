import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Auth {
  static Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
      throw Exception(
          'Error al iniciar sesión con Google'); // Lanza una excepción en caso de error
    }
  }

  static User? getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  //Iniciar sesion
  static bool isUserSignedIn() {
    User? user = getCurrentUser();
    return user != null;
  }

  //Cerrar sesion dos
  static signOutDos(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      await _googleSignIn.disconnect();
      if (context.mounted) {
        context.read<LoginProvider>().checkUserSignedIn();
        
      }
      print('Sesión cerrada correctamente');
    } catch (error) {
      print('Error al cerrar sesión: $error');
    }
  }
}
