class ProductoTb {
  int idProducto; // PK
  int idNegocio; // FK
  String nombreProducto;
  double precio;
  String? descripcion;
  String? descripcionDetallada;
  int cantidadDisponible;
  int? oferta; // bool (0 or 1)
  String urlImage;
  String nombreImage;
  //String? fechaDeCreacion;
  //int? estado;

  ProductoTb(
      {required this.idProducto,
      required this.idNegocio,
      required this.nombreProducto,
      required this.precio,
      this.descripcion,
      this.descripcionDetallada,
      required this.cantidadDisponible,
      this.oferta,
      required this.urlImage,
      required this.nombreImage
      //this.fechaDeCreacion,
      //this.estado,
      });

  factory ProductoTb.fromJson(Map<String, dynamic> json) {
    return ProductoTb(
      idProducto: json['idProducto'],
      idNegocio: json['idNegocio'],
      nombreProducto: json['nombreProducto'],
      precio: json['precio'].toDouble(),
      descripcion: json['descripcion'],
      descripcionDetallada: json['descripcionDetallada'],
      cantidadDisponible: json['cantidadDisponible'],
      oferta: json['oferta'],
      urlImage: json['urlImage'],
      nombreImage: json['nombreImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'idNegocio': idNegocio,
      'nombreProducto': nombreProducto,
      'precio': precio,
      'descripcion': descripcion,
      'cantidadDisponible': cantidadDisponible,
      'oferta': oferta,
      'urlImage': urlImage,
      'nombreImage': nombreImage,
      //'descripcionDetallada': descripcionDetallada,
      //'fechaDeCreacion': fechaDeCreacion,
      //'estado': estado,
    };
  }

  @override
  String toString() {
    return 'ProductoTb{idProducto: $idProducto, nombreProducto: $nombreProducto, urlImage: $urlImage, nombreImage: $nombreImage}';
  }
}

class ProductoCreacionTb {
  final int idNegocio; // FK
  final String nombreProducto;
  final double precio;
  final String? descripcion;
  final String? descripcionDetallada;
  final int cantidadDisponible;
  final int? oferta; // bool (0 or 1)
  final String? urlImage;

  ProductoCreacionTb({
    required this.idNegocio,
    required this.nombreProducto,
    required this.precio,
    this.descripcion,
    this.descripcionDetallada,
    required this.cantidadDisponible,
    this.oferta,
    this.urlImage,
  });

  //FromJson

  Map<String, dynamic> toMap() {
    return {
      'idNegocio': idNegocio,
      'nombreProducto': nombreProducto,
      'precio': precio,
      'descripcion': descripcion,
      'descripcionDetallada': descripcionDetallada,
      'cantidadDisponible': cantidadDisponible,
      'oferta': oferta,
      'urlImage': urlImage,
    };
  }

  @override
  String toString() {
    return 'ProductoCreacionTb{nombreProducto: $nombreProducto}';
  }
}
