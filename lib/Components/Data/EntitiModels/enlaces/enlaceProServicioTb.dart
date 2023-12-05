import 'package:etfi_point/Components/Data/EntitiModels/enlaces/enlaceProServicioImagesTb.dart';

class EnlaceProservicioTb {
  final int idEnlaceProducto;
  final int idProducto;
  final String descripcion;
  final List<EnlaceProServicioImagesTb> enlaceProServicioImages;

  EnlaceProservicioTb({
    required this.idEnlaceProducto,
    required this.idProducto,
    required this.descripcion,
    required this.enlaceProServicioImages,
  });

  factory EnlaceProservicioTb.fromJsonEnlaceProducto(
      Map<String, dynamic> json) {
    List<EnlaceProServicioImagesTb> enlaceProductoImagesList = [];
    if (json['enlaceProductosImages'] != null) {
      var enlaceProductosImagesJson = json['enlaceProductosImages'] as List;
      enlaceProductoImagesList = enlaceProductosImagesJson
          .map((enlaceProductoImagen) =>
              EnlaceProServicioImagesTb.fromJson(enlaceProductoImagen))
          .toList();
    }

    return EnlaceProservicioTb(
      idEnlaceProducto: json['idEnlaceProducto'],
      idProducto: json['idProducto'],
      descripcion: json['descripcion'],
      enlaceProServicioImages: enlaceProductoImagesList,
    );
  }
}

class EnlaceProServicioCreacionTb {
  final int idProServicio;
  final String? descripcion;

  EnlaceProServicioCreacionTb({
    required this.idProServicio,
    this.descripcion,
  });

  Map<String, dynamic> toMapEnlaceProducto() {
    return {
      'idProducto': idProServicio,
      'descripcion': descripcion,
    };
  }

  Map<String, dynamic> toMapEnlaceServicio() {
    return {
      'idServicio': idProServicio,
      'descripcion': descripcion,
    };
  }
}
