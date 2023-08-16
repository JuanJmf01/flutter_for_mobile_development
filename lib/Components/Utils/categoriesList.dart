import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList(
      {super.key,
      this.padding,
      required this.elementos,
      required this.marginContainer,
      required this.paddingContainer,
      this.color,
      this.sizeTextCategoria,
      this.colorTextCategoria,
      //this.subCategoriasSeleccionadas,
      this.onTap});

  final EdgeInsets? padding;
  final List<dynamic> elementos;
  final EdgeInsets marginContainer;
  final EdgeInsets paddingContainer;
  final Color? color;
  final double? sizeTextCategoria;
  final Color? colorTextCategoria;
  //final List<SubCategoriaTb>? subCategoriasSeleccionadas;
  final VoidCallback? onTap;

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: Wrap(
          children: widget.elementos.map((elemento) {
        String nombreElemento = '';
        int idCategoria = 0;
        if (elemento is CategoriaTb || elemento is SubCategoriaTb) {
          nombreElemento = elemento.nombre;
          idCategoria = elemento.idCategoria;
        }
        return Container(
          margin: widget.marginContainer,
          padding: widget.paddingContainer,
          decoration: BoxDecoration(
              color: widget.color ?? Colors.blue,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                nombreElemento,
                style: TextStyle(
                  fontSize: widget.sizeTextCategoria ?? 16,
                  fontWeight: FontWeight.w600,
                  color: widget.colorTextCategoria ?? Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (elemento is CategoriaTb &&
                      elemento.subCategoriasSeleccionadas != null) {
                    print('Estas seguto que deseas eliminar');
                    setState(() {
                      widget.elementos.remove(elemento);
                    });
                  } else {
                    print('Borrar automaticamente');
                  }
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 19,
                ),
              )
            ],
          ),
        );
      }).toList()),
    );
  }
}
