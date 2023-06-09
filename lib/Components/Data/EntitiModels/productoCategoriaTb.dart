class ProductoCategoriaTb {
  final int? idProducto;
  final int? idCategoria;

  ProductoCategoriaTb({
    this.idCategoria, 
    this.idProducto,
  });

  Map<String, dynamic> toMap() {
    return {
      'idCategoria': idCategoria,
      'idProducto': idProducto,
    };
  }
}
