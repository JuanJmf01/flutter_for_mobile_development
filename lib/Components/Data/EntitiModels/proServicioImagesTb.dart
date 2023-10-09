import 'package:multi_image_picker/multi_image_picker.dart';

class ProservicioImagesTb extends ImageListItem {
  final int idProServicioImage;
  final int idProServicio;
  final String nombreImage;
  final String urlImage;
  final double width;
  final double height;
  final int isPrincipalImage;

  ProservicioImagesTb(
      {required this.idProServicioImage,
      required this.idProServicio,
      required this.nombreImage,
      required this.urlImage,
      required this.width,
      required this.height,
      required this.isPrincipalImage});

  factory ProservicioImagesTb.fromJsonProductos(Map<String, dynamic> json) {
    return ProservicioImagesTb(
      idProServicioImage: json['idProductImage'],
      idProServicio: json['idProducto'],
      nombreImage: json['nombreImage'],
      urlImage: json['urlImage'],
      width: double.parse(json['width']),
      height: double.parse(json['height']),
      isPrincipalImage: json['isPrincipalImage'],
    );
  }

  factory ProservicioImagesTb.fromJsonServicios(Map<String, dynamic> json) {
    return ProservicioImagesTb(
      idProServicioImage: json['idProductImage'],
      idProServicio: json['idProducto'],
      nombreImage: json['nombreImage'],
      urlImage: json['urlImage'],
      width: double.parse(json['width']),
      height: double.parse(json['height']),
      isPrincipalImage: json['isPrincipalImage'],
    );
  }

  ProservicioImagesTb copyWith({
    int? idProServicioImage,
    int? idProServicio,
    String? nombreImage,
    String? urlImage,
    double? width,
    double? height,
    int? isPrincipalImage,
  }) {
    return ProservicioImagesTb(
      idProServicioImage: idProServicioImage ?? this.idProServicioImage,
      idProServicio: idProServicio ?? this.idProServicio,
      nombreImage: nombreImage ?? this.nombreImage,
      urlImage: urlImage ?? this.urlImage,
      width: width ?? this.width,
      height: height ?? this.height,
      isPrincipalImage: isPrincipalImage ?? this.isPrincipalImage,
    );
  }

  @override
  String toString() {
    return 'ProductImagesTb{idProServicio: $idProServicio, nombreImage: $nombreImage, urlImage: $urlImage}';
  }
}

class ProServicioImageCreacionTb {
  final int idProServicio;
  final String nombreImage;
  final String urlImage;
  final double width;
  final double height;
  final int isPrincipalImage;

  ProServicioImageCreacionTb(
      {required this.idProServicio,
      required this.nombreImage,
      required this.urlImage,
      required this.width,
      required this.height,
      required this.isPrincipalImage});

  //No estan en uso
  // factory ProServicioImageCreacionTb.fromJsonproductos(Map<String, dynamic> json) {
  //   return ProServicioImageCreacionTb(
  //     idProServicio: json['idProducto'],
  //     nombreImage: json['nombreImage'],
  //     urlImage: json['urlImage'],
  //     width: json['width'],
  //     height: json['height'],
  //     isPrincipalImage: json['isPrincipalImage'],
  //   );
  // }

  //  factory ProServicioImageCreacionTb.fromJsonServicios(Map<String, dynamic> json) {
  //   return ProServicioImageCreacionTb(
  //     idProServicio: json['idProducto'],
  //     nombreImage: json['nombreImage'],
  //     urlImage: json['urlImage'],
  //     width: json['width'],
  //     height: json['height'],
  //     isPrincipalImage: json['isPrincipalImage'],
  //   );
  // }

  Map<String, dynamic> toMapProductos() {
    return {
      'idProducto': idProServicio,
      'nombreImage': nombreImage,
      'urlImage': urlImage,
      'width': width.toStringAsFixed(2), // Convertir a cadena con 2 decimales
      'height': height.toStringAsFixed(2), // Convertir a cadena con 2 decimales
      'isPrincipalImage': isPrincipalImage,
    };
  }

    Map<String, dynamic> toMapServicios() {
    return {
      'idProducto': idProServicio,
      'nombreImage': nombreImage,
      'urlImage': urlImage,
      'width': width.toStringAsFixed(2), // Convertir a cadena con 2 decimales
      'height': height.toStringAsFixed(2), // Convertir a cadena con 2 decimales
      'isPrincipalImage': isPrincipalImage,
    };
  }

  @override
  String toString() {
    return 'RatingsTb{idProServicio: $idProServicio, isPrincipalImage: $isPrincipalImage}';
  }
}

class ProductImageToUpdate extends ImageListItem {
  final String nombreImage;
  final Asset newImage;

  ProductImageToUpdate({
    required this.nombreImage,
    required this.newImage,
  });

  @override
  String toString() {
    return 'ProductImageToUpdate{nombreImage: $nombreImage, newImage: $newImage}';
  }
}

class ProductImageToUpload extends ImageListItem {
  final String nombreImage;
  final Asset newImage;
  final double width;
  final double height;

  ProductImageToUpload({
    required this.nombreImage,
    required this.newImage,
    required this.width,
    required this.height,
  });

  @override
  String toString() {
    return 'ProductImageToUpload{nombreImage: $nombreImage, newImage: $newImage}';
  }
}

class ImageList {
  final List<ImageListItem> items;

  ImageList(this.items);
}

abstract class ImageListItem {}
