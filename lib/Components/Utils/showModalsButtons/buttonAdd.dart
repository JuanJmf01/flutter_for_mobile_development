import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/proServiciosProvider.dart';
import 'package:etfi_point/Pages/crearProducto.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/itemForModalButons.dart';
import 'package:etfi_point/Pages/crearVinculo.dart';
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
            builder: (context) => CrearVinculo(
                  idUsuario: idUsuario,
                )));
  }

  @override
  Widget build(BuildContext context) {
    int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuarioActual;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          alignment: Alignment.center,
          child: Container(
            width: 35.0,
            height: 5.0,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ),
        ItemForModalButtons(
          onPress: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CrearProducto()));
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
          onPress: (){
            if(idUsuario != null){
              irANuevoVinculo(idUsuario, context);
            }
          },
          padding: padding,
          icon: CupertinoIcons.photo_on_rectangle,
          colorIcon: colorIcons,
          textItem: 'Nuevo vinculo',
        ),
        ItemForModalButtons(
          onPress: () {},
          padding: padding,
          icon: CupertinoIcons.rectangle_3_offgrid,
          colorIcon: colorIcons,
          textItem: 'Nuevo reel',
        )
      ]),
    );
  }
}
