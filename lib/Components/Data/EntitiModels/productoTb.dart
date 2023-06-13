class ProductoTb {
  int? idProducto; //PK
  final int? idNegocio; //FK
  //final int? idCategoria; //FK
  String nombreProducto;
  double precio;
  String? descripcion;
  int cantidadDisponible;
  int? oferta; //bool (0 or 1)
  String imagePath;

  ProductoTb({
    this.idProducto,
    this.idNegocio,
    //this.idCategoria,
    required this.nombreProducto,
    required this.precio,
    this.descripcion,
    required this.cantidadDisponible,
    this.oferta,
    required this.imagePath,
  });

  get length => null;

  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'idNegocio': idNegocio,
      //'idCategoria': idCategoria,
      'nombreProducto': nombreProducto,
      'precio': precio,
      'descripcion': descripcion,
      'cantidadDisponible': cantidadDisponible,
      'oferta': oferta,
      'imagePath': imagePath,
    };
  }

  @override
  String toString() {
    return 'ProductoTb{idProducto: $idProducto, nombreProducto: $nombreProducto}';
  }
}
