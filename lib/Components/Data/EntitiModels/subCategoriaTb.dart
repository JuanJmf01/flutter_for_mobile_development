class SubCategoriaTb {
  final int idSubCategoria;
  final int idCategoria;
  final String nombre;

  SubCategoriaTb({
    required this.idSubCategoria,
    required this.idCategoria,
    required this.nombre,
  });

  Map<String, dynamic> toMap() {
    return {
      'idSubCategoria': idSubCategoria,
      'idCategoria': idCategoria,
      'nombre': nombre,
    };
  }

  factory SubCategoriaTb.fromJson(Map<String, dynamic> json) {
    return SubCategoriaTb(
      idSubCategoria: json['idSubCategoria'],
      idCategoria: json['idCategoria'],
      nombre: json['nombre'],
    );
  }
  
  @override
  String toString() {
    return 'ProductoTb{idSubCategoria: $idSubCategoria, idCategoria: $idCategoria, nombre: $nombre}';
  }
}

class SubCategoriaCreacionTb {
  final int idCategoria;
  final String nombre;

  SubCategoriaCreacionTb({
    required this.idCategoria,
    required this.nombre,
  });

  Map<String, dynamic> toMap() {
    return {
      'idCategoria': idCategoria,
      'nombre': nombre,
    };
  }

  factory SubCategoriaCreacionTb.fromMap(Map<String, dynamic> map) {
    return SubCategoriaCreacionTb(
      idCategoria: map['idCategoria'],
      nombre: map['nombre'],
    );
  }
}
