class NegocioTb {
  final int? idNegocio; //PK
  final int? idUsuario; //FK
  String? nombreNegocio;
  String? descripcionNegocio;
  String? facebook;
  String? instagram;
  int? vendedor;    //bool (0 or 1)

  NegocioTb({
    this.idNegocio,
    this.idUsuario,
    this.nombreNegocio,
    this.descripcionNegocio,
    this.facebook,
    this.instagram,
    this.vendedor,
  });

  Map<String, dynamic> toMap() {
    return {
      'idNegocio': idNegocio,
      'idUsuario': idUsuario,
      'nombreNegocio': nombreNegocio,
      'descripcionNegocio': descripcionNegocio,
      'facebook': facebook,
      'instagram': instagram,
      'vendedor': vendedor,
    };
  }
}
