class EnlaceProServicioImagesCreacionTb {
  final int idEnlaceProducto;
  final String nombreImage;
  final String urlImage;
  final double width;
  final double height;

  EnlaceProServicioImagesCreacionTb({
    required this.idEnlaceProducto,
    required this.nombreImage,
    required this.urlImage,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'idEnlaceProducto': idEnlaceProducto,
      'nombreImage': nombreImage,
      'urlImage': urlImage,
      'width': width,
      'height': height,
    };
  }
}
