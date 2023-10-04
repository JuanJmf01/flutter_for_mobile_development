import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Utils/Providers/subCategoriaSeleccionadaProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({
    super.key,
    this.padding,
    required this.elementos,
    this.categoriasSeleccionadas,
    required this.marginContainer,
    required this.paddingContainer,
    this.color,
    this.sizeTextCategoria,
    this.colorTextCategoria,
    required this.onlyShow,
    this.onTap,
  });

  final EdgeInsets? padding;
  final List<dynamic> elementos;
  final List<dynamic>? categoriasSeleccionadas;
  final EdgeInsets marginContainer;
  final EdgeInsets paddingContainer;
  final Color? color;
  final double? sizeTextCategoria;
  final Color? colorTextCategoria;
  final bool onlyShow;
  final VoidCallback? onTap;

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  List<bool> isBlue = [];

  List<SubCategoriaTb> elementos = [];
  List<SubCategoriaTb> subCateSelected = [];

  void toggleColor(int index) {
    setState(() {
      isBlue[index] = !isBlue[index];
    });
  }

  void generarSeleccionados() {
    if (widget.categoriasSeleccionadas != null) {
      print("ALLSUBCAT : $elementos");
      print("MISSUBCATE : ${widget.categoriasSeleccionadas}");

      isBlue = List.generate(elementos.length, (index) {
        final elemento = elementos[index];
        return widget.categoriasSeleccionadas?.any((categoria) =>
                categoria.idCategoria == elemento.idCategoria &&
                categoria.nombre == elemento.nombre) ??
            false;
      });
      print("AZUL : $isBlue");
    } else {
      print("ALLSUBCAT : $elementos");
      print("MISSUBCATE : $subCateSelected");

      isBlue = List.generate(elementos.length, (index) {
        final elemento = elementos[index];
        return subCateSelected?.any((categoria) =>
                categoria.idCategoria == elemento.idCategoria &&
                categoria.nombre == elemento.nombre) ??
            false;
      });
      print("AZUL : $isBlue");
    }
  }

  void inicializarElementos() {
    List<SubCategoriaTb> auxElementos = [
      SubCategoriaTb(idSubCategoria: 1, idCategoria: 1, nombre: "SubCate1"),
      SubCategoriaTb(idSubCategoria: 2, idCategoria: 1, nombre: "SubCate2"),
      SubCategoriaTb(idSubCategoria: 4, idCategoria: 2, nombre: "SubCate4"),
      SubCategoriaTb(idSubCategoria: 5, idCategoria: 2, nombre: "SubCate5"),
      SubCategoriaTb(idSubCategoria: 6, idCategoria: 3, nombre: "SubCate6"),
    ];

    List<SubCategoriaTb> auxSubCateSelected = [
      SubCategoriaTb(idSubCategoria: 2, idCategoria: 1, nombre: "SubCate2"),
      SubCategoriaTb(idSubCategoria: 3, idCategoria: 2, nombre: "SubCate3"),
    ];

    elementos = auxElementos;
    subCateSelected = auxSubCateSelected;
  }

  @override
  void initState() {
    super.initState();
    inicializarElementos();
    generarSeleccionados();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: Align(
        alignment: Alignment.centerLeft, // Alinea los elementos a la izquierda.
        child: Wrap(
          children: widget.elementos.map((elemento) {
            int index = widget.elementos.indexOf(elemento);
            String nombreElemento = '';
            int idCategoria = 0;
            if (elemento is CategoriaTb || elemento is SubCategoriaTb) {
              nombreElemento = elemento.nombre;
              idCategoria = elemento.idCategoria;
            }
            return GestureDetector(
              onTap: () {
                if (widget.onlyShow) {
                  toggleColor(index);
                }
              },
              child: Container(
                margin: widget.marginContainer,
                padding: widget.paddingContainer,
                decoration: BoxDecoration(
                  color: widget.onlyShow
                      ? isBlue[index]
                          ? Colors.blue
                          : Colors.white
                      : widget.color ?? Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      nombreElemento,
                      style: TextStyle(
                          fontSize: widget.sizeTextCategoria ?? 16,
                          fontWeight: FontWeight.w600,
                          color: widget.onlyShow
                              ? isBlue[index]
                                  ? Colors.white
                                  : Colors.black
                              : widget.colorTextCategoria ?? Colors.white),
                    ),
                    GestureDetector(
                        onTap: () {
                          if (elemento is CategoriaTb) {
                            setState(() {
                              widget.elementos.remove(elemento);
                            });
                          } else if (elemento is SubCategoriaTb) {
                            setState(() {
                              widget.elementos.remove(elemento);
                              subCateSelected.remove(elemento);
                              context
                                  .read<SubCategoriaSeleccionadaProvider>()
                                  .eliminarSelectedSubCate(elemento);
                              generarSeleccionados();
                            });
                          }
                        },
                        child: !widget.onlyShow
                            ? Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 19,
                              )
                            : SizedBox.shrink())
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
