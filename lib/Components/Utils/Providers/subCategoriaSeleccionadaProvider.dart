import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Data/Entities/subCategoriasDb.dart';
import 'package:flutter/cupertino.dart';

class SubCategoriaSeleccionadaProvider extends ChangeNotifier {
  List<SubCategoriaTb> _subCategoriasSeleccionadas = [];
  List<CategoriaTb> _allSubCategorias = [];
  List<bool> _isBlue = [];

  List<SubCategoriaTb> get subCategoriasSeleccionadas =>
      _subCategoriasSeleccionadas;

  List<CategoriaTb> get allSubCategorias => _allSubCategorias;

  List<bool> get isBlue => _isBlue;

  Future<void> obtenerSubCategoriasSeleccionadas(int idProducto) async {
    print("SE LLAMA A NEW PROVIDER");

    _subCategoriasSeleccionadas =
        await SubCategoriasDb.getSubCategoriasByProducto(idProducto);

    notifyListeners();
  }

  Future<void> obtenerAllSubCategorias() async {
    print("SE LLAMA A NEW PROVIDER");

    _allSubCategorias = await CategoriaDb.getAllCategorias();

    print("DISPONIBLESSS : $_allSubCategorias");

    notifyListeners();
  }

  void eliminarSubCategoria(
      SubCategoriaTb subCategoria, List<dynamic> subCategorias) {
    print("ANTES: $_subCategoriasSeleccionadas");
    _subCategoriasSeleccionadas.remove(subCategoria);

    notifyListeners();

    //generarSeleccionados(subCategorias);

    print("DESPUES: $_subCategoriasSeleccionadas");
  }

  Future<void> generarSeleccionados(List<dynamic> elementos) async {
    await Future.delayed(
        Duration.zero); // Esperar hasta que la construcción se complete
    print("ELEMENTOS PP : $elementos");
    print("SELECCCIONADOS PP: $_subCategoriasSeleccionadas");

    _isBlue = List.generate(elementos.length, (index) {
      final subCategoria = elementos[index];
      return _subCategoriasSeleccionadas.any((categoria) =>
          categoria.idCategoria == subCategoria.idCategoria &&
          categoria.nombre == subCategoria.nombre);
    });

    notifyListeners();

    print("SELEECTED P: $isBlue");
  }
}
