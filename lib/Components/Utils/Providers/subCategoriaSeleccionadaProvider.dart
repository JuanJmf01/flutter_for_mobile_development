import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Data/Entities/subCategoriasDb.dart';
import 'package:flutter/cupertino.dart';

class SubCategoriaSeleccionadaProvider extends ChangeNotifier {
  List<SubCategoriaTb> _subCategoriasSeleccionadas = [];
  List<CategoriaTb> _allSubCategorias = [];
  List<bool> _isBlue = [];
  List<dynamic> _subCategoriasActuales = [];

  List<SubCategoriaTb> get subCategoriasSeleccionadas =>
      _subCategoriasSeleccionadas;

  List<CategoriaTb> get allSubCategorias => _allSubCategorias;

  List<bool> get isBlue => _isBlue;

  List<dynamic> get subCategoriasActuales => _subCategoriasActuales;

  Future<void> obtenerSubCategoriasSeleccionadas(int idProducto) async {
    _subCategoriasSeleccionadas =
        await SubCategoriasDb.getSubCategoriasByProducto(idProducto);

    notifyListeners();
  }

  Future<void> obtenerAllSubCategorias() async {
    _allSubCategorias = await CategoriaDb.getAllCategorias();
    notifyListeners();
  }

  Future<void> generarSeleccionados(List<dynamic> elementos) async {
    print("ALLSUBCAT : $_allSubCategorias");
    print("MISSUBCATE : $_subCategoriasSeleccionadas");

    _isBlue = List.generate(elementos.length, (index) {
      final elemento = elementos[index];
      return _subCategoriasSeleccionadas.any((categoria) =>
          categoria.idCategoria == elemento.idCategoria &&
          categoria.nombre == elemento.nombre);
    });
    print("MIS ACTUALES AZUL : $isBlue");
  }

  void eliminarSelectedSubCate(SubCategoriaTb subCategoria) {
    print("LLEGA A ELIMINAR: $subCategoria");
    _subCategoriasSeleccionadas.removeWhere(
        (element) => element.idSubCategoria == subCategoria.idSubCategoria);
    print("MOSTRAR ELIMINACION: $_subCategoriasSeleccionadas");

    generarSeleccionados(_subCategoriasActuales);

    // List<dynamic> elementosActuales = [];
    // print("MIS ACTUALES ELEMENTOS : $elementos");

    // if (elementos == null) {
    //   if (!_subCategoriasActuales.contains(subCategoria)) {
    //     generarSeleccionados(_subCategoriasActuales);

    //     print("MIS ACTUALES RENDERIZAR");
    //   } else {
    //     print("MIS ACTUALES NULL");
    //     for (var categoria in _allSubCategorias) {
    //       for (var subCate in categoria.subCategorias) {
    //         if (subCate.idCategoria == subCategoria.idCategoria) {
    //           if (subCate.nombre == subCategoria.nombre) {
    //             elementosActuales.addAll(categoria.subCategorias);
    //           }
    //         }
    //       }
    //     }
    //   }
    // } else {
    //   print("MIS ACTUALES NO NULL");
    //   elementosActuales = elementos;
    // }

    // print("MIS ACTUALES BEACH : $elementosActuales");

    notifyListeners();
  }

  void agregarSubCategoria(SubCategoriaTb subCategoria) {
    print("LLEGA A AGREGACION: $subCategoria");
    _subCategoriasSeleccionadas.add(subCategoria);
    print("MOSTRAR AGREGACION: $_subCategoriasSeleccionadas");

    notifyListeners();
  }

  void definirSubCategoriasActuales(subCategoriasPorIndice) {
    _subCategoriasActuales = subCategoriasPorIndice;
    print("MIS ACTUALES ELEMENTS : $_subCategoriasActuales");
  }
}
