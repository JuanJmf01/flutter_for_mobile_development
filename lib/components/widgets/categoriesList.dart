import 'package:etfi_point/Data/models/subCategoriaTb.dart';
import 'package:etfi_point/Data/services/providers/categoriasProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesList extends ConsumerWidget {
  const CategoriesList({
    super.key,
    this.padding,
    required this.elementos,
    required this.deleteOption,
  });

  final EdgeInsets? padding;
  final List<SubCategoriaTb> elementos;
  final bool deleteOption;

  void deleteSubCategorie(SubCategoriaTb elemento, WidgetRef ref) {
    final subCategoriasSelected = ref.read(subCategoriasSelectedProvider);

    final updatedList = subCategoriasSelected
        .where((element) => element.idSubCategoria != elemento.idSubCategoria)
        .toList();
    ref.read(subCategoriasSelectedProvider.notifier).state = updatedList;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBlue = ref.read(generarSeleccionados);

    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          children: elementos.map((elemento) {
            int index = elementos.indexOf(elemento);
            return GestureDetector(
              onTap: () {
                if (!deleteOption && isBlue.isNotEmpty) {
                  if (isBlue[index]) {
                    deleteSubCategorie(elemento, ref);
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
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: !deleteOption && isBlue.isNotEmpty && index < isBlue.length 
                      ? isBlue[index]
                          ? Colors.blue
                          : Colors.white
                      : Colors.blue,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: !deleteOption && isBlue.isNotEmpty
                              ? isBlue[index]
                                  ? Colors.white
                                  : Colors.black
                              : Colors.white),
                    ),
                    deleteOption
                        ? GestureDetector(
                            onTap: () {
                              deleteSubCategorie(elemento, ref);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 19,
                            ),
                          )
                        : const SizedBox.shrink()
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

