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
