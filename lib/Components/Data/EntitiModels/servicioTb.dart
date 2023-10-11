class ServicioTb {
  final int idServicio;
  final int idProducto;
  final int idNegocio;
  final String nombre;
  final String? descripcion;
  final String? descripcionDetallada;
  final double precio;
  final int oferta;
  final String urlImage;
  final String nombreImage;

  ServicioTb(
      {required this.idServicio,
      required this.idProducto,
      required this.idNegocio,
      required this.nombre,
      this.descripcion,
      this.descripcionDetallada,
      required this.precio,
      required this.oferta,
      required this.urlImage,
      required this.nombreImage});

  factory ServicioTb.fromJson(Map<String, dynamic> json) {
    return ServicioTb(
      idServicio: json['idServicio'],
      idProducto: json['idProducto'],
      idNegocio: json['idNegocio'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      descripcionDetallada: json['descripcionDetallada'],
      precio: json['precio'].toDouble(),
      oferta: json['oferta'],
      urlImage: json['urlImage'],
      nombreImage: json['nombreImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idServicio': idServicio,
      'idProducto': idProducto,
      'idNegocio': idNegocio,
      'nombre': nombre,
      'descripcion': descripcion,
      'descripcionDetallada': descripcionDetallada,
      'precio': precio,
      'oferta': oferta,
      'urlImage': urlImage,
      'nombreImage': nombreImage,
    };
  }

  @override
  String toString() {
    return 'ProductoTb{idServicio: $idServicio, nombreServicio: $nombre, nombreImage: $nombreImage}';
  }
}

class ServicioCreacionTb {
  final int idNegocio;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int oferta;

  ServicioCreacionTb({
    required this.idNegocio,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.oferta,
  });

  Map<String, dynamic> toMap() {
    return {
      'idNegocio': idNegocio,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'oferta': oferta,
    };
  }

  @override
  String toString() {
    return 'ServicioCreacionTb{nombreServicio: $nombre}';
  }
}
