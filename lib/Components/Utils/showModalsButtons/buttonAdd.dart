import 'package:etfi_point/Pages/productosGeneralForm.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/itemForModalButons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonAdd extends StatelessWidget {
  const ButtonAdd({super.key});

  final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10.0);
  final Color colorIcons = Colors.black54;

  @override
  Widget build(BuildContext context) {
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductosGeneralForm(
                        titulo: 'Nuevo producto',
                        nameSavebutton: 'Publicar',
                        exitoMessage: 'Producto agregado correctamente')));
          },
          padding: padding,
          icon: CupertinoIcons.cube_box,
          colorIcon: colorIcons,
          textItem: 'Nuevo producto',
        ),
        ItemForModalButtons(
          onPress: () {},
          padding: padding,
          icon: CupertinoIcons.heart_circle,
          colorIcon: colorIcons,
          textItem: 'Nuevo servicio',
        ),
        ItemForModalButtons(
          onPress: () {},
          padding: padding,
          icon: CupertinoIcons.photo_on_rectangle,
          colorIcon: colorIcons,
          textItem: 'Nueva imagen',
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
