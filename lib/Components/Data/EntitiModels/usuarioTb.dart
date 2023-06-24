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



  factory UsuarioTb.fromMap(Map<String, dynamic> map) {
    return UsuarioTb(
      idUsuario: map['idUsuario'],
      nombres: map['nombres'],
      apellidos: map['apellidos'],
      email: map['email'],
      numeroCelular: map['numeroCelular'],
      domiciliario: map['domiciliario'],
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

    factory UsuarioCreacionTb.fromJson(Map<String, dynamic> json) {
    return UsuarioCreacionTb(
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      email: json['email'],
      numeroCelular: json['numeroCelular'],
      domiciliario: json['domiciliario'],
    );
  }


   factory UsuarioCreacionTb.fromMap(Map<String, dynamic> map) {
    return UsuarioCreacionTb(
      nombres: map['nombres'],
      apellidos: map['apellidos'],
      email: map['email'],
      numeroCelular: map['numeroCelular'],
      domiciliario: map['domiciliario'],
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
