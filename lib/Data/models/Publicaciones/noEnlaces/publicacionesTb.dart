class PublicacionesCreacionTb {
  final int idNegocio;
  final String? descripcion;

  PublicacionesCreacionTb({
    required this.idNegocio,
    this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'idNegocio': idNegocio,
      'descripcion': descripcion,
    };
  }
}

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

