import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Utils/categoriesList.dart';
import 'package:etfi_point/Components/Utils/divider.dart';
import 'package:etfi_point/Components/Utils/lineForDropdownButton.dart';
import 'package:flutter/material.dart';

class ButtonSeleccionarCategorias extends StatelessWidget {
  const ButtonSeleccionarCategorias({
    super.key,
    this.categoriasSeleccionadas,
    required this.categoriasDisponibles,
  });

  final List<CategoriaTb>? categoriasSeleccionadas;
  final List<CategoriaTb> categoriasDisponibles;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22.0),
          topRight: Radius.circular(22.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LineForDropdownButton(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 4.0),
                child: Text(
                  'Categorias seleccionadas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),

          //Categorias seleccionadas
          Padding(
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              child: CategoriesList(
                onlyShow: false,
                elementos: categoriasSeleccionadas ?? [],
                marginContainer: EdgeInsets.all(5.0),
                paddingContainer: EdgeInsets.all(12.0),
              )),

          const GlobalDivider(),

          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 4.0),
                child: Text(
                  'Todas las categorias',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),

          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              child: CategoriesList(
                onlyShow: true,
                elementos: categoriasDisponibles,
                marginContainer: EdgeInsets.all(5.0),
                paddingContainer: EdgeInsets.all(12.0),
              )),
        ],
      ),
    );
  }
}
