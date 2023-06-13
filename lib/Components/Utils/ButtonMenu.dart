import 'package:etfi_point/Components/Auth/auth.dart';
import 'package:etfi_point/Components/Utils/buttonLogin.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/main.dart';
import 'package:flutter/material.dart';

class ButtonMenu extends StatelessWidget {
  ButtonMenu({super.key});

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
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 35.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () async {
                  if(Auth.isUserSignedIn()){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationDialog(
                          message: '¿Seguro que deseas cerrar sesion?',
                          onAcceptMessage: 'Aceptar',
                          onCancelMessage: 'Cancelar',
                          onAccept: () async {
                            await Auth.signOutDos();
                            if(context.mounted){
                              Navigator.of(context).pop();
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,MaterialPageRoute(builder: (context) => Menu(index: 0,)),
                              );
                            }
                           
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    );
                  }else{
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
                      Auth.isUserSignedIn()
                          ? Icons.exit_to_app_rounded
                          : Icons.login_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: 7.0),
                    Text(
                      Auth.isUserSignedIn() ? 'Cerrar sesion' : 'Iniciar Sesion',
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
                    builder: (BuildContext context) => const ButtonLogin(titulo: 'Iniciar sesion para continuar',),
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
                      'Botón 3',
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
