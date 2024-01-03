class ReelCreacionTb {
  final int idNegocio;
  final String urlReel;
  final String nombreReel;
  final String? descripcion;

  ReelCreacionTb({
    required this.idNegocio,
    required this.urlReel,
    required this.nombreReel,
    this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'idNegocio': idNegocio,
      'urlReel': urlReel,
      'nombreReel': nombreReel,
      'descripcion': descripcion,
    };
  }
}

class ProductEnlaceReelCreacionTb {
  final int idProducto;
  final String urlReel;
  final String nombreReel;
  final String? descripcion;

  ProductEnlaceReelCreacionTb({
    required this.idProducto,
    required this.urlReel,
    required this.nombreReel,
    this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'urlReel': urlReel,
      'nombreReel': nombreReel,
      'descripcion': descripcion,
    };
  }
}

class ServiceEnlaceReelCreacionTb {
  final int idServicio;
  final String urlReel;
  final String nombreReel;
  final String? descripcion;

  ServiceEnlaceReelCreacionTb({
    required this.idServicio,
    required this.urlReel,
    required this.nombreReel,
    this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'idServicio': idServicio,
      'urlReel': urlReel,
      'nombreReel': nombreReel,
      'descripcion': descripcion,
    };
  }
}
