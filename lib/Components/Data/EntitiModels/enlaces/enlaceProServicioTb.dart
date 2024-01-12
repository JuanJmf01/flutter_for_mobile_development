class EnlaceProServicioCreacionTb {
  final int idProServicio;
  final String? descripcion;

  EnlaceProServicioCreacionTb({
    required this.idProServicio,
    this.descripcion,
  });

  Map<String, dynamic> toMapEnlaceProducto() {
    return {
      'idProducto': idProServicio,
      'descripcion': descripcion,
    };
  }

  Map<String, dynamic> toMapEnlaceServicio() {
    return {
      'idServicio': idProServicio,
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
