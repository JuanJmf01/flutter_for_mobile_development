class UsuarioTb {
  final int idUsuario;
  String nombres;
  String? apellidos;
  String email;
  String? numeroCelular;
  int? domiciliario; //bool (0 or 1)

  UsuarioTb({
    required this.idUsuario,
    required this.nombres,
    this.apellidos,
    required this.email,
    this.numeroCelular,
    this.domiciliario,
  });

   factory UsuarioTb.fromJson(Map<String, dynamic> json) {
    return UsuarioTb(
      idUsuario: json['idUsuario'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      email: json['email'],
      numeroCelular: json['numeroCelular'],
      domiciliario: json['domiciliario'],
    );
  }

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

class UsuarioCreacionTb {
  String? nombres;
  String? apellidos;
  String email;
  String? numeroCelular;
  int? domiciliario; // bool (0 or 1)

  UsuarioCreacionTb({
    this.nombres,
    this.apellidos,
    required this.email,
    this.numeroCelular,
    this.domiciliario,
  });

  //Al recibir un JSON de la API debe ser convertico a un instancia de tipo UsuarioCreacionTb para que sea utilizada
  factory UsuarioCreacionTb.fromJson(Map<String, dynamic> json) {
    return UsuarioCreacionTb(
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      email: json['email'],
      numeroCelular: json['numeroCelular'],
      domiciliario: json['domiciliario'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'numeroCelular': numeroCelular,
      'domiciliario': domiciliario,
    };
  }
}
