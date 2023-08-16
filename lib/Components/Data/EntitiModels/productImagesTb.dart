import 'package:multi_image_picker/multi_image_picker.dart';

class ProductImagesTb {
  final int idProductImage;
  final int idProducto;
  final String nombreImage;
  final String urlImage;
  final int isPrincipalImage;

  ProductImagesTb(
      {required this.idProductImage,
      required this.idProducto,
      required this.nombreImage,
      required this.urlImage,
      required this.isPrincipalImage});

  factory ProductImagesTb.fromJson(Map<String, dynamic> json) {
    return ProductImagesTb(
      idProductImage: json['idProductImage'],
      idProducto: json['idProducto'],
      nombreImage: json['nombreImage'],
      urlImage: json['urlImage'],
      isPrincipalImage: json['isPrincipalImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idProductImage': idProductImage,
      'idProducto': idProducto,
      'nombreImage': nombreImage,
      'urlImage': urlImage,
      'isPrincipalImage': isPrincipalImage,
    };
  }

  ProductImagesTb copyWith({
    int? idProductImage,
    int? idProducto,
    String? nombreImage,
    String? urlImage,
    int? isPrincipalImage,
  }) {
    return ProductImagesTb(
      idProductImage: idProductImage ?? this.idProductImage,
      idProducto: idProducto ?? this.idProducto,
      nombreImage: nombreImage ?? this.nombreImage,
      urlImage: urlImage ?? this.urlImage,
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
  final int isPrincipalImage;

  ProductImageCreacionTb(
      {required this.idProducto,
      required this.nombreImage,
      required this.urlImage,
      required this.isPrincipalImage});

  factory ProductImageCreacionTb.fromJson(Map<String, dynamic> json) {
    return ProductImageCreacionTb(
      idProducto: json['idProducto'],
      nombreImage: json['nombreImage'],
      urlImage: json['urlImage'],
      isPrincipalImage: json['isPrincipalImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'nombreImage': nombreImage,
      'urlImage': urlImage,
      'isPrincipalImage': isPrincipalImage,
    };
  }

  @override
  String toString() {
    return 'RatingsTb{idProducto: $idProducto, isPrincipalImage: $isPrincipalImage}';
  }
}

class ProductImageToUpdate {
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

class ProductImageToUpload {
  final String nombreImage;
  final Asset newImage;

  ProductImageToUpload({
    required this.nombreImage,
    required this.newImage,
  });

  @override
  String toString() {
    return 'ProductImageToUpload{nombreImage: $nombreImage, newImage: $newImage}';
  }
}
