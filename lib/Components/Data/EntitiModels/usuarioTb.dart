class UsuarioTb {
  final int? idUsuario;
  String nombres;
  String apellidos;
  String email;
  String numeroCelular;
  int? domiciliario; //bool (0 or 1)
  String password;

  UsuarioTb({
    this.idUsuario,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.numeroCelular,
    this.domiciliario,
    required this.password
  });

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'numeroCelular': numeroCelular,
      'domiciliario': domiciliario,
      'password': password,
    };
  } 

}