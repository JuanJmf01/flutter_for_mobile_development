import 'package:multi_image_picker/multi_image_picker.dart';

class ProductImagesTb extends ImageListItem{
  final int idProductImage;
  final int idProducto;
  final String nombreImage;
  final String urlImage;
  final double width;
  final double height;
  final int isPrincipalImage;

  ProductImagesTb(
      {required this.idProductImage,
      required this.idProducto,
      required this.nombreImage,
      required this.urlImage,
      required this.width,
      required this.height,
      required this.isPrincipalImage});

  factory ProductImagesTb.fromJson(Map<String, dynamic> json) {
    return ProductImagesTb(
      idProductImage: json['idProductImage'],
      idProducto: json['idProducto'],
      nombreImage: json['nombreImage'],
      urlImage: json['urlImage'],
      width: double.parse(json['width']),
      height: double.parse(json['height']),
      isPrincipalImage: json['isPrincipalImage'],
    );
  }

  ProductImagesTb copyWith({
    int? idProductImage,
    int? idProducto,
    String? nombreImage,
    String? urlImage,
    double? width,
    double? height,
    int? isPrincipalImage,
  }) {
    return ProductImagesTb(
      idProductImage: idProductImage ?? this.idProductImage,
      idProducto: idProducto ?? this.idProducto,
      nombreImage: nombreImage ?? this.nombreImage,
      urlImage: urlImage ?? this.urlImage,
      width: width ?? this.width,
      height: height ?? this.height,
      isPrincipalImage: isPrincipalImage ?? this.isPrincipalImage,
    );
  }

  @override
  String toString() {
    return 'ProductImagesTb{idProducto: $idProducto, nombreImage: $nombreImage, isPrincipalImage: $isPrincipalImage}';
  }
}

class ProductImageCreacionTb {
  final int idProducto;
  final String nombreImage;
  final String urlImage;
  final double width;
  final double height;
  final int isPrincipalImage;

  ProductImageCreacionTb(
      {required this.idProducto,
      required this.nombreImage,
      required this.urlImage,
      required this.width,
      required this.height,
      required this.isPrincipalImage});

  factory ProductImageCreacionTb.fromJson(Map<String, dynamic> json) {
    return ProductImageCreacionTb(
      idProducto: json['idProducto'],
      nombreImage: json['nombreImage'],
      urlImage: json['urlImage'],
      width: json['width'],
      height: json['height'],
      isPrincipalImage: json['isPrincipalImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'nombreImage': nombreImage,
      'urlImage': urlImage,
      'width': width.toStringAsFixed(2), // Convertir a cadena con 2 decimales
      'height': height.toStringAsFixed(2), // Convertir a cadena con 2 decimales
      'isPrincipalImage': isPrincipalImage,
    };
  }

  @override
  String toString() {
    return 'RatingsTb{idProducto: $idProducto, isPrincipalImage: $isPrincipalImage}';
  }
}

class ProductImageToUpdate extends ImageListItem{
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
