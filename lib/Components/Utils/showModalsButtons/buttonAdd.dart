import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/proServiciosProvider.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/globalButtonBase.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/smallButtonTopTab.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/itemForModalButons.dart';
import 'package:etfi_point/Screens/enlaces/crearEnlace.dart';
import 'package:etfi_point/Screens/crearReel.dart';
import 'package:etfi_point/Screens/proServicios/productos/productoGeneralForm.dart';
import 'package:etfi_point/Screens/proServicios/servicios/serviciosGeneralForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonAdd extends StatelessWidget {
  const ButtonAdd({super.key});

  final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10.0);
  final Color colorIcons = Colors.black54;

  void irANuevoVinculo(int idUsuario, BuildContext context) {
    context
        .read<ProServiciosProvider>()
        .obtenerProServiciosByNegocio(idUsuario);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CrearEnlace(
                  idUsuario: idUsuario,
                )));
  }

  void irANuevoReel(int idUsuario, BuildContext context) {
    context
        .read<ProServiciosProvider>()
        .obtenerProServiciosByNegocio(idUsuario);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CrearReel(
                  idUsuario: idUsuario,
                )));
  }

  @override
  Widget build(BuildContext context) {
    int? idUsuarioActual =
        Provider.of<UsuarioProvider>(context).idUsuarioActual;
    return GlobalButtonBase(
      itemsColumn: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SmallButtonTopTab(),
          ItemForModalButtons(
            onPress: () {
              if (idUsuarioActual != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            // const ProductoGeneralForm(
                            //   titulo: 'Agregar producto',
                            //   nameSavebutton: 'Crear',
                            //   exitoMessage: 'Producto creado exitosamente',
                            // ),
                            const ProductoGeneralForm()));
              } else {
                print("Manage logueo");
              }
            },
            padding: padding,
            icon: CupertinoIcons.cube_box,
            colorIcon: colorIcons,
            textItem: 'Nuevo producto',
          ),
          ItemForModalButtons(
            onPress: () {
              if (idUsuarioActual != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ServiciosGeneralForm(
                              titulo: "Agregar servicio",
                              nameSaveButton: "Agregasr",
                            )));
              } else {
                print("Manage logueo");
              }
            },
            padding: padding,
            icon: CupertinoIcons.heart_circle,
            colorIcon: colorIcons,
            textItem: 'Nuevo servicio',
          ),
          ItemForModalButtons(
            onPress: () {
              idUsuarioActual != null
                  ? irANuevoVinculo(idUsuarioActual, context)
                  : print("Manage logueo");
            },
            padding: padding,
            icon: CupertinoIcons.photo_on_rectangle,
            colorIcon: colorIcons,
            textItem: 'Nuevo vinculo',
          ),
          ItemForModalButtons(
            onPress: () {
              idUsuarioActual != null
                  ? irANuevoReel(idUsuarioActual, context)
                  : print("Manage logueo");
            },
            padding: padding,
            icon: CupertinoIcons.rectangle_3_offgrid,
            colorIcon: colorIcons,
            textItem: 'Nuevo reel',
          )
        ],
      ),
    );
  }
}
