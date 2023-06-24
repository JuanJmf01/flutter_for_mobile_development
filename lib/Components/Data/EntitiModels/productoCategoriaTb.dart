class ProductoCategoriaTb {
  final int idProducto;
  final int idCategoria;

  ProductoCategoriaTb({
    required this.idCategoria, 
    required this.idProducto,
  });

  factory ProductoCategoriaTb.fromJson(Map<String, dynamic> json) {
    return ProductoCategoriaTb(
      idProducto: json['idProducto'],
      idCategoria: json['idCategoria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idCategoria': idCategoria,
      'idProducto': idProducto,
    };
  }
}
