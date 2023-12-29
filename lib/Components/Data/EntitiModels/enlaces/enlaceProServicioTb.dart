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
