class ProductoTb {
  final int idProducto;
  final int idNegocio;
  final String nombre;
  final double precio;
  final String? descripcion;
  final String? descripcionDetallada;
  final int cantidadDisponible;
  final int? oferta; // bool (0 or 1)
  final int? descuento;
  final DateTime? fechaCreacion;

  final String urlImage;
  final String nombreImage;
  //int? estado;

  ProductoTb(
      {required this.idProducto,
      required this.idNegocio,
      required this.nombre,
      required this.precio,
      this.descripcion,
      this.descripcionDetallada,
      required this.cantidadDisponible,
      this.oferta,
      this.descuento,
      required this.urlImage,
      required this.nombreImage,
      this.fechaCreacion
      //this.fechaDeCreacion,
      //this.estado,
      });

  factory ProductoTb.fromJson(Map<String, dynamic> json) {
    return ProductoTb(
      idProducto: json['idProducto'],
      idNegocio: json['idNegocio'],
      nombre: json['nombreProducto'],
      precio: json['precio'].toDouble(),
      descripcion: json['descripcion'],
      descripcionDetallada: json['descripcionDetallada'],
      cantidadDisponible: json['cantidadDisponible'],
      oferta: json['oferta'],
      descuento: json['descuento'],
      fechaCreacion: DateTime.parse(
          json['fechaCreacion']), // Convierte la cadena a DateTime
      urlImage: json['urlImage'],
      nombreImage: json['nombreImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'idNegocio': idNegocio,
      'nombreProducto': nombre,
      'precio': precio,
      'descripcion': descripcion,
      'descripcionDetallada': descripcionDetallada,
      'cantidadDisponible': cantidadDisponible,
      'oferta': oferta,
      'descuento': descuento,
      'fechaCreacion': fechaCreacion,
      'urlImage': urlImage,
      'nombreImage': nombreImage,
      //'fechaDeCreacion': fechaDeCreacion,
      //'estado': estado,
    };
  }

  @override
  String toString() {
    return 'ProductoTb{idProducto: $idProducto, nombreProducto: $nombre, nombreImage: $nombreImage}';
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
  final int? descuento;

  ProductoCreacionTb({
    required this.idNegocio,
    required this.nombreProducto,
    required this.precio,
    this.descripcion,
    this.descripcionDetallada,
    required this.cantidadDisponible,
    this.oferta,
    this.descuento,
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
      'descuento': descuento,
    };
  }

  @override
  String toString() {
    return 'ProductoCreacionTb{nombreProducto: $nombreProducto}';
  }
}
