class EnlaceProServicioCreacionTb {
  final int idProServicio;
  final String? descripcion;

  EnlaceProServicioCreacionTb({
    required this.idProServicio,
    this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProServicio,
      'descripcion': descripcion,
    };
  }
}
