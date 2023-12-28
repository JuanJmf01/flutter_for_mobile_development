class ReelCreacionTb {
  final int idNegocio;
  final String? urlReel;
  final String? descripcion;

  ReelCreacionTb({
    required this.idNegocio,
    this.urlReel,
    this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'idNegocio': idNegocio,
      'urlReel': urlReel,
      'descripcion': descripcion,
    };
  }
}


class ProductEnlaceReelCreacionTb {
  final int idProducto;
  final String? urlReel;
  final String? descripcion;

  ProductEnlaceReelCreacionTb({
    required this.idProducto,
    this.urlReel,
    this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'urlReel': urlReel,
      'descripcion': descripcion,
    };
  }
}

class ServiceEnlaceReelCreacionTb {
  final int idServicio;
  final String? urlReel;
  final String? descripcion;

  ServiceEnlaceReelCreacionTb({
    required this.idServicio,
    this.urlReel,
    this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'idServicio': idServicio,
      'urlReel': urlReel,
      'descripcion': descripcion,
    };
  }
}

