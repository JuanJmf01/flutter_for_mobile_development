import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';

class EnlacePublicacionesTb extends NewsFeedItem {
  final int idEnlaceProServicio;
  final int idProServicio;
  final String? descripcion;
  final String fechaCreacion;
  final List<EnlaceImagesPublicaciones> enlaceProServicioImages;

  EnlacePublicacionesTb({
    required this.idEnlaceProServicio,
    required this.idProServicio,
    this.descripcion,
    required this.fechaCreacion,
    required this.enlaceProServicioImages,
  });

  factory EnlacePublicacionesTb.fromJson(Map<String, dynamic> json) {
    List<EnlaceImagesPublicaciones> enlacePublicacionesImagesList = [];
    if (json['enlaceProServicioImages'] != null) {
      var enlaceProServicioImagesJson = json['enlaceProServicioImages'] as List;
      enlacePublicacionesImagesList = enlaceProServicioImagesJson
          .map((enlaceProductoImage) =>
              EnlaceImagesPublicaciones.fromJson(enlaceProductoImage))
          .toList();
    }

    return EnlacePublicacionesTb(
      idEnlaceProServicio: json['idEnlaceProServicio'],
      idProServicio: json['idProServicio'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
      enlaceProServicioImages: enlacePublicacionesImagesList,
    );
  }
  
  @override
  DateTime getFechaCreacion() {
    return DateTime.parse(fechaCreacion);
  }
}

class EnlaceImagesPublicaciones {
  final int idEnlaceProServicioImage;
  final String nombreImage;
  final String urlImage;
  final double width;
  final double height;

  EnlaceImagesPublicaciones({
    required this.idEnlaceProServicioImage,
    required this.nombreImage,
    required this.urlImage,
    required this.width,
    required this.height,
  });

  factory EnlaceImagesPublicaciones.fromJson(Map<String, dynamic> json) {
    return EnlaceImagesPublicaciones(
      idEnlaceProServicioImage: json['idEnlaceProServicioImage'],
      nombreImage: json['nombreImage'],
      urlImage: json['urlImage'],
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
    );
  }
}
