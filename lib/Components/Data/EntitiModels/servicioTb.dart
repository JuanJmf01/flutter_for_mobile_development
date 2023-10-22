class ServicioTb {
  final int idServicio;
  final int idNegocio;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int oferta;
  final String urlImage;
  final String nombreImage;
  final int? descuento;

  ServicioTb({
    required this.idServicio,
    required this.idNegocio,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.oferta,
    required this.urlImage,
    required this.nombreImage,
    this.descuento,
  });

  factory ServicioTb.fromJson(Map<String, dynamic> json) {
    return ServicioTb(
      idServicio: json['idServicio'],
      idNegocio: json['idNegocio'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: json['precio'].toDouble(),
      oferta: json['oferta'],
      descuento: json['descuento'],
      urlImage: json['urlImage'],
      nombreImage: json['nombreImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idServicio': idServicio,
      'idNegocio': idNegocio,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'oferta': oferta,
      'descuento': descuento,
      'urlImage': urlImage,
      'nombreImage': nombreImage,
    };
  }

  @override
  String toString() {
    return 'ServicioTb{idServicio: $idServicio, nombreServicio: $nombre, nombreImage: $nombreImage, urlImage: $urlImage}';
  }
}

class ServicioCreacionTb {
  final int idNegocio;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int oferta;
  final int? descuento;

  ServicioCreacionTb({
    required this.idNegocio,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.oferta,
    this.descuento,
  });

  Map<String, dynamic> toMap() {
    return {
      'idNegocio': idNegocio,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'oferta': oferta,
      'descuento': descuento,
    };
  }

  @override
  String toString() {
    return 'ServicioCreacionTb{nombreServicio: $nombre}';
  }
}
