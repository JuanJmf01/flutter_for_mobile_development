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
    this.delete,
    this.seleccionSubCategorias,
  });

  final EdgeInsets? padding;
  final List<SubCategoriaTb> elementos;
  final List<SubCategoriaTb>? categoriasSeleccionadas;
  final EdgeInsets marginContainer;
  final EdgeInsets paddingContainer;
  final Color? color;
  final double? sizeTextCategoria;
  final Color? colorTextCategoria;
  final bool onlyShow;
  final bool? delete;
  final bool? seleccionSubCategorias;

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  List<bool> isBlue = [];
  List<SubCategoriaTb> elementos = [];
  List<SubCategoriaTb> subCateSelected = [];
  List<SubCategoriaTb> subCategoriasActuales = [];

  bool delete = false;

  void toggleColor(int index) {
    setState(() {
      isBlue[index] = !isBlue[index];
    });
  }

  void generarSeleccionadas() async {
    await context
        .read<SubCategoriaSeleccionadaProvider>()
        .generarSeleccionados(widget.elementos);
  }

  void defSubCategoriasActuales(){
     if (widget.elementos.isNotEmpty && widget.categoriasSeleccionadas != null) {
      context
          .read<SubCategoriaSeleccionadaProvider>()
          .definirSubCategoriasActuales(widget.elementos);
    }
  }

  @override
  void initState() {
    super.initState();
    //inicializarElementos();
    elementos = widget.elementos;
    if (widget.categoriasSeleccionadas != null) {
      subCateSelected = widget.categoriasSeleccionadas!;
    }
    generarSeleccionadas();
    defSubCategoriasActuales();

    delete = widget.delete ?? false;

  }

  @override
  Widget build(BuildContext context) {
    isBlue = context.watch<SubCategoriaSeleccionadaProvider>().isBlue;

    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          children: widget.elementos.map((elemento) {
            int index = widget.elementos.indexOf(elemento);
            return GestureDetector(
              onTap: () {
                if (widget.onlyShow) {
                  toggleColor(index);
                  if (isBlue[index] == false) {
                    setState(() {
                      context
                          .read<SubCategoriaSeleccionadaProvider>()
                          .eliminarSelectedSubCate(elemento);
                    });
                  } else {
                    setState(() {
                      context
                          .read<SubCategoriaSeleccionadaProvider>()
                          .agregarSubCategoria(elemento);
                    });
                  }
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
                      elemento.nombre,
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
                          setState(() {
                            widget.elementos.remove(elemento);
                            subCateSelected.remove(elemento);
                            context
                                .read<SubCategoriaSeleccionadaProvider>()
                                .eliminarSelectedSubCate(elemento);
                          });
                        },
                        child: delete
                            ? const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 19,
                              )
                            : const SizedBox.shrink())
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
