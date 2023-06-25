class NegocioTb {
  final int idNegocio; //PK
  final int? idUsuario; //FK
  String? nombreNegocio;
  String? descripcionNegocio;
  String? facebook;
  String? instagram;
  int? vendedor; //bool (0 or 1)

  NegocioTb({
    required this.idNegocio,
    this.idUsuario,
    this.nombreNegocio,
    this.descripcionNegocio,
    this.facebook,
    this.instagram,
    this.vendedor,
  });

  factory NegocioTb.fromJson(Map<String, dynamic> json) {
    return NegocioTb(
      idNegocio: json['idNegocio'],
      idUsuario: json['idUsuario'],
      nombreNegocio: json['nombreNegocio'],
      descripcionNegocio: json['descripcionNegocio'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      vendedor: json['vendedor'],
    );
  }

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

class NegocioCreacionTb {
  final int idUsuario; // FK
  String? nombreNegocio;
  String? descripcionNegocio;
  String? facebook;
  String? instagram;
  int? vendedor; // bool (0 or 1)

  NegocioCreacionTb({
    required this.idUsuario,
    this.nombreNegocio,
    this.descripcionNegocio,
    this.facebook,
    this.instagram,
    this.vendedor,
  });

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'nombreNegocio': nombreNegocio,
      'descripcionNegocio': descripcionNegocio,
      'facebook': facebook,
      'instagram': instagram,
      'vendedor': vendedor,
    };
  }
}
