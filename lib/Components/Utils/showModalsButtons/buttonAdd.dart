import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/proServiciosProvider.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/globalButtonBase.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/smallButtonTopTab.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/itemForModalButons.dart';
import 'package:etfi_point/Pages/enlaces/crearEnlace.dart';
import 'package:etfi_point/Pages/crearReel.dart';
import 'package:etfi_point/Pages/proServicios/productos/productosGeneralForm.dart';
import 'package:etfi_point/Pages/proServicios/servicios/serviciosGeneralForm.dart';
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
    int idUsuario = Provider.of<UsuarioProvider>(context).idUsuarioActual;
    return GlobalButtonBase(
      itemsColumn: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmallButtonTopTab(),
          ItemForModalButtons(
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductosGeneralForm(
                            titulo: 'Agregar producto',
                            nameSavebutton: 'Crear',
                            exitoMessage: 'Producto creado exitosamente',
                          )));
            },
            padding: padding,
            icon: CupertinoIcons.cube_box,
            colorIcon: colorIcons,
            textItem: 'Nuevo producto',
          ),
          ItemForModalButtons(
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ServiciosGeneralForm(
                            titulo: "Agregar servicio",
                            nameSaveButton: "Agregasr",
                          )));
            },
            padding: padding,
            icon: CupertinoIcons.heart_circle,
            colorIcon: colorIcons,
            textItem: 'Nuevo servicio',
          ),
          ItemForModalButtons(
            onPress: () {
              irANuevoVinculo(idUsuario, context);
            },
            padding: padding,
            icon: CupertinoIcons.photo_on_rectangle,
            colorIcon: colorIcons,
            textItem: 'Nuevo vinculo',
          ),
          ItemForModalButtons(
            onPress: () {
              irANuevoReel(idUsuario, context);
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
