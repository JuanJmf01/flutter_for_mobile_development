class PublicacionesTb {
  final int idNegocio;
  final String? descripcion;

  PublicacionesTb({
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


class RatingsPublicacionesTb {
  final int idUsuario;
  final int idPublicacion;
  final int? likes;

  RatingsPublicacionesTb({
    required this.idUsuario,
    required this.idPublicacion,
    this.likes,
  });

  Map<String, dynamic> toMapRatingFotoPublicacion() {
    return {
      'idUsuario': idUsuario,
      'idFotoPublicacion': idPublicacion,
      'likes': likes,
    };
  }

   Map<String, dynamic> toMapRatingReelPublicacion() {
    return {
      'idUsuario': idUsuario,
      'idReelPublicacion': idPublicacion,
      'likes': likes,
    };
  }
}
