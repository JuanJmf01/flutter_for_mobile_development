import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginApp extends StatelessWidget {
  const LoginApp({super.key});


Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inicio de sesión',
      theme: ThemeData(
        primaryColor: Colors.blue, // Color principal azul
      ),
      home: Scaffold(
        backgroundColor: Colors.grey[200], // Color de fondo gris claro
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinear contenido en la parte inferior
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 220.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                          child:  TextField(
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                            ),
                          ),
                        ),
                        const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: ElevatedButton(
                              onPressed: () {

                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                              child: const Text('Iniciar sesión', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1.2,
                                  indent: 20.0,
                                  endIndent: MediaQuery.of(context).size.width / 2 - 195.0,
                                ),
                              ),
                              const Text('o continue con',),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1.2,
                                  indent: MediaQuery.of(context).size.width / 2 - 195.0,
                                  endIndent: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            icon: const Icon(Icons.abc),
                           onPressed: () async {
    UserCredential? userCredential = await signInWithGoogle();
    if (userCredential != null) {
      // El usuario ha iniciado sesión exitosamente con Google
      // Puedes realizar acciones adicionales aquí, como navegar a una pantalla principal o guardar los datos del usuario en tu base de datos
      print(userCredential);
    }
  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes una cuenta?'),
                  TextButton(
                    onPressed: () {
                      // Acción al presionar el botón de "Regístrate"
                    },
                    child: const Text(
                      'Regístrate',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
