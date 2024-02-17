import 'package:etfi_point/Data/services/Auth/auth.dart';
import 'package:etfi_point/components/widgets/lineForDropdownButton.dart';
import 'package:etfi_point/components/widgets/showModalsButtons/buttonLogin.dart';
import 'package:etfi_point/components/widgets/confirmationDialog.dart';
import 'package:etfi_point/Data/services/providers/userStateProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// UTILIZAR  LA CLASE globalButtonBase

class ButtonMenu extends ConsumerWidget {
  const ButtonMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //bool isUserSignedIn = context.watch<LoginProvider>().isUserSignedIn;
    final isUserSignedIn = ref.watch(userStateProvider);

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
                              bool result = await Auth.signOt();
                              if (result) {
                                ref
                                    .read(userStateProvider.notifier)
                                    .update((state) => false);
                              }
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                Navigator.pop(context);
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
                    const SizedBox(width: 7.0),
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
