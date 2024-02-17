class SeguidoresTb {
  final int idSeguidor;
  final int idUsuarioSeguidor;
  final int idUsuarioSeguido;

  SeguidoresTb({
    required this.idSeguidor,
    required this.idUsuarioSeguidor,
    required this.idUsuarioSeguido,
  });
}

class SeguidoresCreacionTb {
  final int idUsuarioSeguidor;
  final int idUsuarioSeguido;

  SeguidoresCreacionTb({
    required this.idUsuarioSeguidor,
    required this.idUsuarioSeguido,
  });

  Map<String, dynamic> toMap() {
    return {
      'idUsuarioSeguidor': idUsuarioSeguidor,
      'idUsuarioSeguido': idUsuarioSeguido,
    };
  }
}
