class ProductoSubCategoriaTb {
  final int idSubCategoria;
  final int idProducto;
  final int idCategoria;

  ProductoSubCategoriaTb({
    required this.idSubCategoria,
    required this.idCategoria, 
    required this.idProducto,
  });

  factory ProductoSubCategoriaTb.fromJson(Map<String, dynamic> json) {
    return ProductoSubCategoriaTb(
      idSubCategoria: json['idSubCategoria'],
      idProducto: json['idProducto'],
      idCategoria: json['idCategoria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idSubCategoria': idSubCategoria,
      'idCategoria': idCategoria,
      'idProducto': idProducto,
    };
  }
}
