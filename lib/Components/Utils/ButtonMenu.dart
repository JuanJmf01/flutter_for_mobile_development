import 'package:etfi_point/Components/Auth/Pages/inicioSesion.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class ButtonMenu extends StatelessWidget {
 
  ButtonMenu({super.key});

  GoogleSignIn _googleSignIn = GoogleSignIn();


  void _handleSignOut() async {
  try {
    await _googleSignIn.disconnect();
    print('Sesión cerrada correctamente');
  } catch (error) {
    print('Error al cerrar sesión: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800], // Gris tirando a oscuro
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(width: 35.0, height: 5.0,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2.5),),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  _handleSignOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  LoginApp())
                  );

                },
                child: const Row(
                  children: [
                    Icon(Icons.exit_to_app_rounded, color: Colors.white,),
                    SizedBox(width: 7.0),
                    Text(
                      'Cerrar sesion',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold, // Texto más grueso
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //Divider(color: Colors.grey[300], indent: 20.0, endIndent: 20.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // Lógica para el botón 2
                },
                child: const Row(
                  children: [
                    Icon(Icons.check, color: Colors.white,),
                    SizedBox(width: 7.0),
                    Text(
                      'Botón 2',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold, // Texto más grueso
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0,),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // Lógica para el botón 3
                },
                child: const Row(
                  children: [
                    Icon(Icons.check, color: Colors.white,),
                    SizedBox(width: 7.0),
                    Text('Botón 3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
