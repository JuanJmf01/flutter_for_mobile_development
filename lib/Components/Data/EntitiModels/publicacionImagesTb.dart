class PublicacionImagesTb {
  final String nombreImage;
  final String urlImage;
  final double width;
  final double height;

  PublicacionImagesTb({
    required this.nombreImage,
    required this.urlImage,
    required this.width,
    required this.height,
  });

  factory PublicacionImagesTb.fromJson(Map<String, dynamic> json) {
    return PublicacionImagesTb(
      nombreImage: json['nombreImage'],
      urlImage: json['urlImage'],
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
    );
  }
}

class PublicacionImagesCreacionTb {
  final int idPublicacion;
  final String nombreImage;
  final String urlImage;
  final double width;
  final double height;

  PublicacionImagesCreacionTb({
    required this.idPublicacion,
    required this.nombreImage,
    required this.urlImage,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toMapPublicacion() {
    return {
      'idPublicacion': idPublicacion,
      'nombreImage': nombreImage,
      'urlImage': urlImage,
      'width': width,
      'height': height,
    };
  }
}
