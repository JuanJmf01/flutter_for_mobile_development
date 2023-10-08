import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Data/Entities/subCategoriasDb.dart';
import 'package:flutter/cupertino.dart';

class SubCategoriaSeleccionadaProvider extends ChangeNotifier {
  List<SubCategoriaTb> _subCategoriasSeleccionadas = [];
  List<CategoriaTb> _allSubCategorias = [];
  List<bool> _isBlue = [];
  List<SubCategoriaTb> _subCategoriasActuales = [];

  List<SubCategoriaTb> get subCategoriasSeleccionadas =>
      _subCategoriasSeleccionadas;

  List<CategoriaTb> get allSubCategorias => _allSubCategorias;
  List<bool> get isBlue => _isBlue;
  List<SubCategoriaTb> get subCategoriasActuales => _subCategoriasActuales;

  Future<void> obtenerSubCategoriasSeleccionadas(int idProducto) async {
    _subCategoriasSeleccionadas =
        await SubCategoriasDb.getSubCategoriasByProducto(idProducto);

    notifyListeners();
  }

  Future<void> obtenerAllSubCategorias() async {
    _allSubCategorias = await CategoriaDb.getAllCategorias();
    notifyListeners();
  }

  Future<void> generarSeleccionados(List<SubCategoriaTb> elementos) async {
    _isBlue = List.generate(elementos.length, (index) {
      final elemento = elementos[index];
      return _subCategoriasSeleccionadas.any((categoria) =>
          categoria.idCategoria == elemento.idCategoria &&
          categoria.nombre == elemento.nombre);
    });
  }

  void eliminarSelectedSubCate(SubCategoriaTb subCategoria) {
    _subCategoriasSeleccionadas.removeWhere(
        (element) => element.idSubCategoria == subCategoria.idSubCategoria);

    generarSeleccionados(_subCategoriasActuales);

    notifyListeners();
  }

  void agregarSubCategoria(SubCategoriaTb subCategoria) {
    _subCategoriasSeleccionadas.add(subCategoria);

    notifyListeners();
  }

  void definirSubCategoriasActuales(subCategoriasPorIndice) {
    _subCategoriasActuales = subCategoriasPorIndice;
  }
}
