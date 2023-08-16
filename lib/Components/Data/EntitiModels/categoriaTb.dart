import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';

class CategoriaTb {
  final int? idCategoria;
  final String nombre;
  final List<SubCategoriaTb>? subCategoriasSeleccionadas;
  final String? imagePath;

  CategoriaTb(
      {this.idCategoria,
      required this.nombre,
      this.subCategoriasSeleccionadas,
      this.imagePath});

 CategoriaTb copyWith({
    int? idCategoria,
    String? nombre,
    List<SubCategoriaTb>? subCategoriasSeleccionadas,
    String? imagePath,
  }) {
    return CategoriaTb(
      idCategoria: idCategoria ?? this.idCategoria,
      nombre: nombre ?? this.nombre,
      subCategoriasSeleccionadas:
          subCategoriasSeleccionadas ?? this.subCategoriasSeleccionadas,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  factory CategoriaTb.fromJson(Map<String, dynamic> json) {
    return CategoriaTb(
      idCategoria: json['idCategoria'],
      nombre: json['nombre'],
      imagePath: json['imagePath'],
    );
  }

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
    return 'CategoriaTb{nombre: $nombre, subCategoriasSeleccionadas: $subCategoriasSeleccionadas}';
  }
}