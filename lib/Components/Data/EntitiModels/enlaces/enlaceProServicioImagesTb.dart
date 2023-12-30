//Agregar id primary key
class EnlaceProServicioImagesTb {
  final String nombreImage;
  final String urlImage;
  final double width;
  final double height;

  EnlaceProServicioImagesTb({
    required this.nombreImage,
    required this.urlImage,
    required this.width,
    required this.height,
  });


  // fromJsonEnlaceProducto y fromJsonEnlaceServicio son iguales. Verificar la necesidad de utilizar idEnlaceProducto y idEnlaceServicio respectivamente o utilizar un solo metodo de fabrica y no dos

  factory EnlaceProServicioImagesTb.fromJsonEnlaceProducto(Map<String, dynamic> json) {
    return EnlaceProServicioImagesTb(
      nombreImage: json['nombreImage'],
      urlImage: json['urlImage'],
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
    );
  }

  factory EnlaceProServicioImagesTb.fromJsonEnlaceServicio(Map<String, dynamic> json) {
    return EnlaceProServicioImagesTb(
      nombreImage: json['nombreImage'],
      urlImage: json['urlImage'],
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
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
