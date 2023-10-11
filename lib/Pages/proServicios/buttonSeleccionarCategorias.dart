import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Utils/buttonSeleccionarCategorias.dart';
import 'package:etfi_point/Components/Utils/elevatedGlobalButton.dart';
import 'package:flutter/material.dart';

class ButtonSeleccionarCategoriasProServicios extends StatelessWidget {
  const ButtonSeleccionarCategoriasProServicios({
    super.key,
    required this.categoriasDisponibles,
  });

  final List<CategoriaTb> categoriasDisponibles;

  @override
  Widget build(BuildContext context) {
    return ElevatedGlobalButton(
      nameSavebutton: 'Seleccionar categorias',
      onPress: () {
        print("ALLCATEGORIES_: $categoriasDisponibles");
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) => ButtonSeleccionarCategorias(
            categoriasDisponibles: categoriasDisponibles,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
        );
      },
      heightSizeBox: 52,
      widthSizeBox: double.infinity,
      borderRadius: BorderRadius.circular(30.0),
      backgroundColor: Colors.blue.withOpacity(0.06),
      paddingRight: 20.0,
      paddingLeft: 20.0,
      borderSideColor: Colors.blue,
      colorNameSaveButton: Colors.blue,
      widthBorderSide: 3.0,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      //color: Colors.blue.withOpacity(0.2),
    );
  }
}
