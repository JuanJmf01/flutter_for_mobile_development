import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  /// The function `signInWithGoogle` signs in a user using their Google account credentials and returns
  /// a `UserCredential` object.
  ///
  /// Returns:
  ///   a Future<UserCredential>.
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
      return null;
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
      return null;
    }
  }

  /// The function getCurrentUser() returns the currently authenticated user, or null if there is no
  /// authenticated user.
  ///
  /// Returns:
  ///   The method is returning the current user, which is of type User.
  static User? getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;

    return user;
  }

  //Iniciar sesion
  /// The function "isUserSignedIn" checks if a user is currently signed in.
  ///
  /// Returns:
  ///   The function isUserSignedIn() returns a boolean value.
  static bool isUserSignedIn() {
    User? user = getCurrentUser();
    print('if is null: $user');
    return user != null;
  }

  /// The `signOut` function is responsible for signing out the currently authenticated user.
  static Future<bool> signOt() async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.disconnect();
      print('Sesión cerrada correctamente');
      return true;
    } catch (error) {
      print('Error al cerrar sesión: $error');
      return false;
    }
  }
}
