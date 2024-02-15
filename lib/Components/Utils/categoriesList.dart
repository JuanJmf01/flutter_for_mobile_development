import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/providers/categoriasProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesList extends ConsumerStatefulWidget {
  const CategoriesList(
      {super.key,
      this.padding,
      required this.elementos,
      this.categoriasSeleccionadas,
      required this.marginContainer,
      required this.paddingContainer,
      this.color,
      this.sizeTextCategoria,
      this.colorTextCategoria,
      required this.onlyShow,
      this.delete});

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

  @override
  CategoriesListState createState() => CategoriesListState();
}

class CategoriesListState extends ConsumerState<CategoriesList> {
  List<bool> isBlue = [];

  void deleteSubCategorie(SubCategoriaTb elemento) {
    final subCategoriasSelected = ref.read(subCategoriasSelectedProvider);

    final updatedList = subCategoriasSelected
        .where((element) => element.idSubCategoria != elemento.idSubCategoria)
        .toList();
    ref.read(subCategoriasSelectedProvider.notifier).state = updatedList;
  }

  @override
  Widget build(BuildContext context) {
    isBlue = ref.read(generarSeleccionados);

    print("Mensaje : $isBlue");

    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          children: widget.elementos.map((elemento) {
            int index = widget.elementos.indexOf(elemento);
            return GestureDetector(
              onTap: () {
                if (widget.onlyShow && isBlue.isNotEmpty) {
                  if (isBlue[index] == true) {
                    deleteSubCategorie(elemento);
                  } else {
                    final subCategoriasSelected =
                        ref.read(subCategoriasSelectedProvider);

                    final subCategorias = [...subCategoriasSelected, elemento];
                    ref
                        .read(subCategoriasSelectedProvider.notifier)
                        .update((state) => subCategorias);
                  }
                }
              },
              child: Container(
                margin: widget.marginContainer,
                padding: widget.paddingContainer,
                decoration: BoxDecoration(
                  color: widget.onlyShow && isBlue.isNotEmpty
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
                          color: widget.onlyShow && isBlue.isNotEmpty
                              ? isBlue[index]
                                  ? Colors.white
                                  : Colors.black
                              : widget.colorTextCategoria ?? Colors.white),
                    ),
                    widget.delete != null && widget.delete == true
                        ? GestureDetector(
                            onTap: () {
                              deleteSubCategorie(elemento);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 19,
                            ),
                          )
                        : SizedBox.shrink()
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
