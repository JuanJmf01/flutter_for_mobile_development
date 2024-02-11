import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:etfi_point/Components/Utils/ElevatedGlobalButton.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Components/Utils/lineForDropdownButton.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/globalButtonBase.dart';
import 'package:flutter/material.dart';
import 'package:etfi_point/Components/Auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class ButtonLogin extends StatefulWidget {
  const ButtonLogin({super.key, this.titulo});

  final String? titulo;

  @override
  State<ButtonLogin> createState() => _ButtonLoginState();
}

class _ButtonLoginState extends State<ButtonLogin> {
  bool _isPressed = false;

  void newUser(UserCredential credenciales) async {
    final user = credenciales.user;
    String? name;
    String? emailAdress;

    if (user != null) {
      for (final providerProfile in user.providerData) {
        name = providerProfile.displayName;
        emailAdress = providerProfile.email;
      }
    }

    if (emailAdress != null) {
      UsuarioCreacionTb usuario =
          UsuarioCreacionTb(nombres: name, email: emailAdress);
      await UsuarioDb.insertUsuario(usuario);

      print('Creando usuario antes de pedir id: $usuario');
    }
  }

  void logInWithGoogle(BuildContext context) async {
    try {
      UserCredential? userCredential = await Auth.signInWithGoogle();
      String? email = userCredential?.user?.email;
      if (email != null && userCredential != null) {
        bool userExists = await UsuarioDb.ifExistsUserByEmail(email);

        if (!userExists) {
          newUser(userCredential);
        }

        if (context.mounted) {
          context.read<LoginProvider>().checkUserSignedIn();
          context.read<UsuarioProvider>().obtenerIdUsuarioActual();
          print("Entra a leerlo Funciona");

          // if (mounted) {
          //   Navigator.pop(context);
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const Home()),
          //   );
          // }
        }
      }
    } catch (error, stacktrace) {
      print('Error al iniciar sesion con google $stacktrace');
    }
  }

  void _onTap() {
    setState(() {
      _isPressed = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _isPressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalButtonBase(
      itemsColumn: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LineForDropdownButton(),
          //const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Title(
                color: Colors.black,
                child: Text(
                  widget.titulo ?? 'Iniciar sesion',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                )),
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
          ElevatedGlobalButton(
              paddingTop: 40.0,
              nameSavebutton: 'Iniciar sesion',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              borderRadius: BorderRadius.circular(30.0),
              widthSizeBox: double.infinity,
              heightSizeBox: 50,
              onPress: () {
                print('inicio sesion');
              }),
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _onTap();
                  logInWithGoogle(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isPressed ? 55.0 : 65.0,
                  height: _isPressed ? 55.0 : 65.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'lib/images/GooglePng.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿No tienes una cuenta?',
                  style: TextStyle(fontSize: 14.5),
                ),
                GlobalTextButton(
                  onPressed: () {},
                  textButton: 'Regístrate',
                  color: Colors.blue,
                  fontSizeTextButton: 15,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
