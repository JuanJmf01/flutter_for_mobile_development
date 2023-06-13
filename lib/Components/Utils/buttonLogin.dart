import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:etfi_point/main.dart';
import 'package:flutter/material.dart';
import 'package:etfi_point/Components/Auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ButtonLogin extends StatelessWidget {
  const ButtonLogin({super.key, this.titulo});

  final String? titulo;

  void newUser(UserCredential credenciales)async {
    final user = credenciales.user!;
    var name;
    var emailAdress;

    if(user != null){
      for(final providerProfile in user.providerData){
        name = providerProfile.displayName;
        emailAdress = providerProfile.email;
      }
    }

    UsuarioTb usuario = UsuarioTb(
      nombres: name,
      email: emailAdress
    );

    await UsuarioDb.insert(usuario);
    print(usuario);

  }

  void pruebaCrearUsuario() async{
     UsuarioTb usuario = UsuarioTb(
      nombres: 'prueba juan',
      email: 'pruebajuan@gmail.com'
    );  

    final idUsuarioPrueba = await UsuarioDb.insert(usuario);
    print('Funciona hasta aca');
    print(idUsuarioPrueba);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      decoration: const BoxDecoration(
        //color: Colors.grey[800], // Gris tirando a oscuro
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 35.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          //const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Title(color: Colors.black,
            child: Text(titulo ?? 'Iniciar sesion', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
            child: TextField(
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
                  pruebaCrearUsuario();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
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
                const Text(
                  'o continue con',
                ),
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
                try{
                  
                  UserCredential userCredential = await Auth.signInWithGoogle();
                  if (userCredential != null) {
                    final email = userCredential.user?.email;
                    bool userExists = await UsuarioDb.existsUserByEmail(email!);
                    if(!userExists){
                      newUser(userCredential);
                    }
                    if(context.mounted){
                      Navigator.pop(context);   
                      Navigator.pushReplacement(
                        context,MaterialPageRoute(builder: (context) => Menu(index: 1,)),
                      );
                    }
                    
                  }
                }catch(error, stacktrace){
                  print('Error al iniciar sesion con google $stacktrace');
                } 
                    
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
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
    );
  }
}
