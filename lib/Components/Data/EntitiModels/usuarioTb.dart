class UsuarioTb {
  final int? idUsuario;
  String? nombres;
  String? apellidos;
  String email;
  String? numeroCelular;
  int? domiciliario; //bool (0 or 1)

  UsuarioTb({
    this.idUsuario,
    this.nombres,
    this.apellidos,
    required this.email,
    this.numeroCelular,
    this.domiciliario,
  });

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'numeroCelular': numeroCelular,
      'domiciliario': domiciliario,
    };
  } 

}