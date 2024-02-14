import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllCategoriasProvider =
    FutureProvider.family<List<CategoriaTb>, String>((ref, url) async {
  return CategoriaDb.getAllCategorias(url);
});


final subCategoriasSeleccionadas = StateProvider<List<SubCategoriaTb>>((ref) {
  return [];
});
