class RatingsEnlaceProServicioTb {
  final int idUsuario;
  final int idEnlaceProServicio;
  final int likes;

  RatingsEnlaceProServicioTb({
    required this.idUsuario,
    required this.idEnlaceProServicio,
    required this.likes,
  });

  Map<String, dynamic> toMapEnlaceProducto() {
    return {
      'idUsuario': idUsuario,
      'idEnlaceProducto': idEnlaceProServicio,
      'likes': likes,
    };
  }

  Map<String, dynamic> toMapEnlaceServicio() {
    return {
      'idUsuario': idUsuario,
      'idEnlaceServicio': idEnlaceProServicio,
      'likes': likes,
    };
  }

  Map<String, dynamic> toMapEnlaceVidProducto() {
    return {
      'idUsuario': idUsuario,
      'idProductEnlaceReel': idEnlaceProServicio,
      'likes': likes,
    };
  }

   Map<String, dynamic> toMapEnlaceVidServicio() {
    return {
      'idUsuario': idUsuario,
      'idServiceEnlaceReel': idEnlaceProServicio,
      'likes': likes,
    };
  }
}
