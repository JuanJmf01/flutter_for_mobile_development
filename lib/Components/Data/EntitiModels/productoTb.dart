class ProductoTb {
  int? idProducto; // PK
  int idNegocio; // FK
  String nombreProducto;
  double precio;
  String? descripcion;
  int cantidadDisponible;
  int? oferta; // bool (0 or 1)
  String imagePath;
  //String? descripcionDetallada;
  //String? fechaDeCreacion;
  //int? estado;

  ProductoTb({
    this.idProducto,
    required  this.idNegocio,
    required this.nombreProducto,
    required this.precio,
    this.descripcion,
    required this.cantidadDisponible,
    this.oferta,
    required this.imagePath,
    //this.descripcionDetallada,
    //this.fechaDeCreacion,
    //this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'idNegocio': idNegocio,
      'nombreProducto': nombreProducto,
      'precio': precio,
      'descripcion': descripcion,
      'cantidadDisponible': cantidadDisponible,
      'oferta': oferta,
      'imagePath': imagePath,
      //'descripcionDetallada': descripcionDetallada,
      //'fechaDeCreacion': fechaDeCreacion,
      //'estado': estado,
    };
  }

  @override
  String toString() {
    return 'ProductoTb{idProducto: $idProducto, nombreProducto: $nombreProducto}';
  }
}

class ProductoCreacionTb {
  final int idNegocio; // FK
  final String nombreProducto;
  final double precio;
  final String? descripcion;
  final int cantidadDisponible;
  final int? oferta; // bool (0 or 1)
  final String imagePath;

  ProductoCreacionTb({
    required this.idNegocio,
    required this.nombreProducto,
    required this.precio,
    this.descripcion,
    required this.cantidadDisponible,
    this.oferta,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'idNegocio': idNegocio,
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
    return 'ProductoCreacionTb{nombreProducto: $nombreProducto}';
  }
}
