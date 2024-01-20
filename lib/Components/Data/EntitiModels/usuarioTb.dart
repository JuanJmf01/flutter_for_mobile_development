class UsuarioTb {
  int idUsuario;
  String nombres;
  String? apellidos;
  String? email;
  String? numeroCelular;
  String? urlFotoPerfil;
  String? urlFotoPortada;

  UsuarioTb({
    required this.idUsuario,
    required this.nombres,
    this.apellidos,
    this.email,
    this.numeroCelular,
    this.urlFotoPerfil,
    this.urlFotoPortada,
  });

  factory UsuarioTb.fromJson(Map<String, dynamic> json) {
    return UsuarioTb(
      idUsuario: json['idUsuario'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      email: json['email'],
      numeroCelular: json['numeroCelular'],
      urlFotoPerfil: json['urlFotoPerfil'],
      urlFotoPortada: json['urlFotoPortada'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'numeroCelular': numeroCelular,
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


class UsuarioPrincipalProfileTb {
  int idUsuario;
  String nombres;
  String? apellidos;
  String? email;
  String? numeroCelular;
  String? urlFotoPerfil;
  String? urlFotoPortada;
  int seguidores;
  int siguiendo;

  UsuarioPrincipalProfileTb({
    required this.idUsuario,
    required this.nombres,
    this.apellidos,
    this.email,
    this.numeroCelular,
    this.urlFotoPerfil,
    this.urlFotoPortada,
    required this.seguidores,
    required this.siguiendo,
  });

  factory UsuarioPrincipalProfileTb.fromJson(Map<String, dynamic> json) {
    return UsuarioPrincipalProfileTb(
      idUsuario: json['idUsuario'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      email: json['email'],
      numeroCelular: json['numeroCelular'],
      urlFotoPerfil: json['urlFotoPerfil'],
      urlFotoPortada: json['urlFotoPortada'],
      seguidores: json['seguidores'],
      siguiendo: json['siguiendo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'numeroCelular': numeroCelular,
    };
  }
}



