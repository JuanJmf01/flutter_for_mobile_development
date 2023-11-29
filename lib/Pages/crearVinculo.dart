import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrearVinculo extends StatefulWidget {
  const CrearVinculo({super.key});

  @override
  State<CrearVinculo> createState() => _CrearVinculoState();
}

class _CrearVinculoState extends State<CrearVinculo> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  int indicePagina = 1;

  void guardar() {
    print("Guardar");
  }

  @override
  Widget build(BuildContext context) {
    bool isUserSignedIn = context.watch<LoginProvider>().isUserSignedIn;
    //int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuario;

    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(240, 245, 251, 1.0),
            iconTheme: IconThemeData(color: Colors.black, size: 30),
            toolbarHeight: 60,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Crear vinculo",
                  style: TextStyle(color: Colors.black),
                ),
                GlobalTextButton(
                  onPressed: () {
                    if (isUserSignedIn && indicePagina == 2) {
                      guardar();
                    } else {
                      setState(() {
                        indicePagina += 1;
                      });
                    }
                  },
                  textButton: indicePagina == 1 ? 'Siguiente' : 'Guardar',
                  fontSizeTextButton: 19,
                  letterSpacing: 0.3,
                )
              ],
            )),
        backgroundColor: Color.fromRGBO(240, 245, 251, 1.0),
        body: const Column(
          children: [
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "¿Que producto/servicio deseas enlazar?",
                      style: TextStyle(
                          fontSize: 17.5, fontWeight: FontWeight.w500),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
