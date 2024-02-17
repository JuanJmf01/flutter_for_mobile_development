import 'package:etfi_point/Data/models/subCategoriaTb.dart';

class CategoriaTb {
  final int idCategoria;
  final String nombre;
  final List<SubCategoriaTb> subCategorias;

  CategoriaTb({
    required this.idCategoria,
    required this.nombre,
    required this.subCategorias,
  });

  factory CategoriaTb.fromJson(Map<String, dynamic> json) {
    List<SubCategoriaTb> subCategoriasList = [];
    if (json['subCategorias'] != null) {
      var subCategoriasJson = json['subCategorias'] as List;
      subCategoriasList = subCategoriasJson
          .map((subCategoria) => SubCategoriaTb.fromJson(subCategoria))
          .toList();
    }

    return CategoriaTb(
      idCategoria: json['idCategoria'],
      nombre: json['nombre'],
      subCategorias: subCategoriasList,
    );
  }


  CategoriaTb copyWith({
    int? idCategoria,
    String? nombre,
    List<SubCategoriaTb>? subCategorias,
  }) {
    return CategoriaTb(
      idCategoria: idCategoria ?? this.idCategoria,
      nombre: nombre ?? this.nombre,
      subCategorias: subCategorias ?? this.subCategorias,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoriaTb &&
        other.idCategoria == idCategoria &&
        other.nombre == nombre;
  }

  @override
  int get hashCode => idCategoria.hashCode ^ nombre.hashCode;
  @override
  String toString() {
    return 'CategoriaTb{idCategoria: $idCategoria, nombre: $nombre, subCategorias: $subCategorias}';
  }
}


// class ListaCategorias{
//   final CategoriaTb categorias;
//   final List<SubCategoriaTb> subCategorias;


//   ListaCategorias({
//     required this.categorias,
//     required this.subCategorias
//   });

// }
