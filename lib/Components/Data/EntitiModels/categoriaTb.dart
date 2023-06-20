class CategoriaTb {
  final int? idCategoria;
  final String nombre;
  final String? imagePath;

  CategoriaTb({
    this.idCategoria, 
    required this.nombre,
    this.imagePath
  });

  Map<String, dynamic> toMap() {
    return {
      'idCategoria': idCategoria,
      'nombre': nombre,
      'imagePath': imagePath,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoriaTb &&
        other.idCategoria == idCategoria &&
        other.nombre == nombre;
  }

  @override
  int get hashCode => idCategoria.hashCode ^ nombre.hashCode;

  @override
  String toString() {
    return 'CategoriaTb{idCategoria: $idCategoria, nombre: $nombre}';
  }
}
