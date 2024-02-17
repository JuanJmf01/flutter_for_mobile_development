import 'package:etfi_point/Data/models/categoriaTb.dart';
import 'package:etfi_point/Data/models/subCategoriaTb.dart';
import 'package:etfi_point/Data/services/api/categoriaDb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllCategoriasProvider =
    FutureProvider.family<List<CategoriaTb>, String>((ref, url) async {
  return CategoriaDb.getAllCategorias(url);
});

final subCategoriasSelectedProvider =
    StateProvider<List<SubCategoriaTb>>((ref) {
  return [];
});

final subCategoriesByIndiceProvider =
    StateProvider<List<SubCategoriaTb>>((ref) {
  return [];
});

final generarSeleccionados = StateProvider<List<bool>>((ref) {
  final List<SubCategoriaTb> subCategoriesSelected =
      ref.watch(subCategoriasSelectedProvider);

  final List<SubCategoriaTb> subCategoriesByIndice =
      ref.watch(subCategoriesByIndiceProvider);

  List<bool> isSelected = List.filled(subCategoriesByIndice.length, false);

  for (int i = 0; i < subCategoriesByIndice.length; i++) {
    SubCategoriaTb subCategoria = subCategoriesByIndice[i];
    isSelected[i] = subCategoriesSelected.any((selected) =>
        selected.idCategoria == subCategoria.idCategoria &&
        selected.nombre == subCategoria.nombre);
  }

  return isSelected;
});
