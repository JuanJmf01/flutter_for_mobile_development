import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Data/Entities/subCategoriasDb.dart';
import 'package:flutter/cupertino.dart';

class SubCategoriaSeleccionadaProvider extends ChangeNotifier {
  List<SubCategoriaTb> _subCate = [];
  List<SubCategoriaTb> _allSubCat = [];
  List<bool> _isBlue = [];

  List<SubCategoriaTb> get subCate => _subCate;
  List<SubCategoriaTb> get allSubCat => _allSubCat;
  List<bool> get isBlue => _isBlue;

  Future<void> obtenerSubCategorias() async {
    print("ENTRA DE NUEVO ACA");
    List<SubCategoriaTb> auxSubCate = [
      SubCategoriaTb(idSubCategoria: 1, idCategoria: 1, nombre: "SubCate1"),
      SubCategoriaTb(idSubCategoria: 2, idCategoria: 1, nombre: "SubCate2"),
      SubCategoriaTb(idSubCategoria: 3, idCategoria: 2, nombre: "SubCate3"),
    ];

    List<SubCategoriaTb> auxAllsubCate = [
      SubCategoriaTb(idSubCategoria: 1, idCategoria: 1, nombre: "SubCate1"),
      SubCategoriaTb(idSubCategoria: 2, idCategoria: 1, nombre: "SubCate2"),
      SubCategoriaTb(idSubCategoria: 4, idCategoria: 2, nombre: "SubCate4"),
      SubCategoriaTb(idSubCategoria: 5, idCategoria: 2, nombre: "SubCate5"),
      SubCategoriaTb(idSubCategoria: 6, idCategoria: 3, nombre: "SubCate6"),
    ];

    _subCate = auxSubCate;
    _allSubCat = auxAllsubCate;

    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  void eliminarSelectedSubCate(SubCategoriaTb subCategoria) {
    print("LLEGA A ELIMINAR: $subCategoria");
    _subCate.removeWhere((element) => element.idSubCategoria == subCategoria.idSubCategoria);
    print("MOSTRAR ELIMINACION: $_subCate");

    generarSeleccionados();

    notifyListeners();
  }

  void agregarSubCategoria(SubCategoriaTb subCategoria){
    print("LLEGA A AGREGACION: $subCategoria");
    _subCate.add(subCategoria);
    print("MOSTRAR AGREGACION: $_subCate");

    notifyListeners();

  }

  Future<void> generarSeleccionados() async {
    print("ALLSUBCAT : $_allSubCat");
    print("MISSUBCATE : $_subCate");

    _isBlue = List.generate(_allSubCat.length, (index) {
      final elemento = _allSubCat[index];
      return _subCate.any((categoria) =>
          categoria.idCategoria == elemento.idCategoria &&
          categoria.nombre == elemento.nombre);
    });
    print("AZUL : $isBlue");
  }

  // List<SubCategoriaTb> _subCategoriasSeleccionadas = [];
  // List<CategoriaTb> _allSubCategorias = [];

  // List<SubCategoriaTb> get subCategoriasSeleccionadas =>
  //     _subCategoriasSeleccionadas;

  // List<CategoriaTb> get allSubCategorias => _allSubCategorias;

  // Future<void> obtenerSubCategoriasSeleccionadas(int idProducto) async {
  //   _subCategoriasSeleccionadas =
  //       await SubCategoriasDb.getSubCategoriasByProducto(idProducto);

  //   notifyListeners();
  // }

  // Future<void> obtenerAllSubCategorias() async {
  //   _allSubCategorias = await CategoriaDb.getAllCategorias();
  //   notifyListeners();
  // }

  // void eliminarSubCategoria(
  //     SubCategoriaTb subCategoria) {
  //   _subCategoriasSeleccionadas.remove(subCategoria);

  //   notifyListeners();

  // }
}
