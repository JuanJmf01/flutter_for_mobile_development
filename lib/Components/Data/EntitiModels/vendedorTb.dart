// No se a utilizar

class VendedorTb {
  final int? idVendedor;
  String nombres;
  String apellidos;
  String email;
  String? nombreNegocio;
  String? descripcionNegocio;
  String? facebook;
  String? instagram;
  int? domiciliario;
  int? vendedor;
  String password;

  VendedorTb(
      {this.idVendedor,
      required this.nombres,
      required this.apellidos,
      required this.email,
      this.nombreNegocio,
      this.descripcionNegocio,
      this.facebook,
      this.instagram,
      this.domiciliario,
      this.vendedor,
      required this.password});

  Map<String, dynamic> toMap() {
    return {
      'idVendedor': idVendedor,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'nombreNegocio': nombreNegocio,
      'descripcionNegocio': descripcionNegocio,
      'facebook': facebook,
      'instagram': instagram,
      'domiciliario': domiciliario,
      'vendedor': vendedor,
      'password': password,
    };
  }
}
