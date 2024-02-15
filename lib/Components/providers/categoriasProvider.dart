import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
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
  final subCategoriesSelected = ref.watch(subCategoriasSelectedProvider);

  final subCategoriesByIndice = ref.watch(subCategoriesByIndiceProvider);

  List<bool> isSelected = subCategoriesByIndice.map((elemento) {
    return subCategoriesSelected.contains(elemento);
  }).toList();


  print("bools 2 $subCategoriesSelected");
  print("bools 3 $subCategoriesByIndice");

  return isSelected;
});
