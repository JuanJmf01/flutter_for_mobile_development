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

  @override
  String toString() {
    return 'ProductoTb{idUsuario: $idUsuario, nombres: $nombres, urlFotoPerfil: $urlFotoPerfil, urlFotoPortada: $urlFotoPortada,}';
  }
}

class UsuarioCreacionTb {
  String? nombres; //No deberia ser null
  String? apellidos;
  String email;
  String? numeroCelular;
  String? urlFotoPerfil;
  String? urlFotoPortada;

  UsuarioCreacionTb({
    this.nombres,
    this.apellidos,
    required this.email,
    this.numeroCelular,
    this.urlFotoPerfil,
    this.urlFotoPortada,
  });

  factory UsuarioCreacionTb.fromJson(Map<String, dynamic> json) {
    return UsuarioCreacionTb(
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
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'numeroCelular': numeroCelular,
      'urlFotoPerfil': urlFotoPerfil,
      'urlFotoPortada': urlFotoPortada,
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
