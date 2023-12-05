//Agregar id primary key
class EnlaceProServicioImagesTb {
  final int idEnlaceProServicio;
  final String nombreImage;
  final String urlImage;
  final double width;
  final double height;

  EnlaceProServicioImagesTb({
    required this.idEnlaceProServicio,
    required this.nombreImage,
    required this.urlImage,
    required this.width,
    required this.height,
  });

  factory EnlaceProServicioImagesTb.fromJson(Map<String, dynamic> json) {
    return EnlaceProServicioImagesTb(
      idEnlaceProServicio: json['idEnlaceProServicio'],
      nombreImage: json['nombreImage'],
      urlImage: json['urlImage'],
      width: json['width'],
      height: json['height'],
    );
  }
}

class EnlaceProServicioImagesCreacionTb {
  final int idEnlaceProServicio;
  final String nombreImage;
  final String urlImage;
  final double width;
  final double height;

  EnlaceProServicioImagesCreacionTb({
    required this.idEnlaceProServicio,
    required this.nombreImage,
    required this.urlImage,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toMapEnlaceProducto() {
    return {
      'idEnlaceProducto': idEnlaceProServicio,
      'nombreImage': nombreImage,
      'urlImage': urlImage,
      'width': width,
      'height': height,
    };
  }

  Map<String, dynamic> toMapEnlaceServicio() {
    return {
      'idEnlaceServicio': idEnlaceProServicio,
      'nombreImage': nombreImage,
      'urlImage': urlImage,
      'width': width,
      'height': height,
    };
  }
}
