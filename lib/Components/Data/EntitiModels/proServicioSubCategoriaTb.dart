class ProServicioSubCategoriaTb {
  final int idProServicio;
  final int idCategoria;
  final int idSubCategoria;

  ProServicioSubCategoriaTb({
    required this.idProServicio,
    required this.idCategoria,
    required this.idSubCategoria,
  });

  // factory ProductoSubCategoriaTb.fromJsonProducto(Map<String, dynamic> json) {
  //   return ProductoSubCategoriaTb(
  //     idProServicio: json['idProducto'],
  //     idCategoria: json['idCategoria'],
  //     idSubCategoria: json['idSubCategoria'],
  //   );
  // }

  Map<String, dynamic> toMapProducto() {
    return {
      'idProducto': idProServicio,
      'idCategoria': idCategoria,
      'idSubCategoria': idSubCategoria,
    };
  }

  factory ProServicioSubCategoriaTb.fromJsonServicio(Map<String, dynamic> json) {
    return ProServicioSubCategoriaTb(
      idProServicio: json['idProducto'],
      idCategoria: json['idCategoria'],
      idSubCategoria: json['idSubCategoria'],
    );
  }

  Map<String, dynamic> toMapServicio() {
    return {
      'idServicio': idProServicio,
      'idCategoria': idCategoria,
      'idSubCategoria': idSubCategoria,
    };
  }

  
}
