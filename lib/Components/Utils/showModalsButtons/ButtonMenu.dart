import 'package:etfi_point/Components/Auth/auth.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/lineForDropdownButton.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/buttonLogin.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// UTILIZAR  LA CLASE globalButtonBase

class ButtonMenu extends StatelessWidget {
  ButtonMenu({super.key});

  @override
  Widget build(BuildContext context) {
    bool isUserSignedIn = context.watch<LoginProvider>().isUserSignedIn;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800], // Gris tirando a oscuro
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LineForDropdownButton(),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () async {
                  if (isUserSignedIn) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationDialog(
                            message: '¿Seguro que deseas cerrar sesion?',
                            onAcceptMessage: 'Aceptar',
                            onCancelMessage: 'Cancelar',
                            onAccept: () async {
                              await Auth.signOut(context);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                //Navigator.pop(context);
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => Menu(
                                //             currentIndex: 0,
                                //           )),
                                // );
                              }
                            },
                            onCancel: () {
                              Navigator.of(context).pop();
                            },
                          );
                        });
                  } else {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) => const ButtonLogin(),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      isUserSignedIn
                          ? Icons.exit_to_app_rounded
                          : Icons.login_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: 7.0),
                    Text(
                      isUserSignedIn ? 'Cerrar sesion' : 'Iniciar Sesion',
                      style: const TextStyle(
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
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) => const ButtonLogin(
                      titulo: 'Iniciar sesion para continuar',
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    SizedBox(width: 7.0),
                    Text(
                      '',
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
            padding: const EdgeInsets.symmetric(
              horizontal: 4.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // Lógica para el botón 3
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    SizedBox(width: 7.0),
                    Text(
                      'Boton 3',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
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
