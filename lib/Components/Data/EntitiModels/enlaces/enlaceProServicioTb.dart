class EnlaceProductoCreacionTb {
  final int idProducto;
  final String? descripcion;

  EnlaceProductoCreacionTb({
    required this.idProducto,
    this.descripcion,
  });

  Map<String, dynamic> toMapEnlaceProducto() {
    return {
      'idProducto': idProducto,
      'descripcion': descripcion,
    };
  }
}

class EnlaceServicioCreacionTb {
  final int idServicio;
  final String? descripcion;

  EnlaceServicioCreacionTb({
    required this.idServicio,
    this.descripcion,
  });

  Map<String, dynamic> toMapEnlaceServicio() {
    return {
      'idServicio': idServicio,
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
