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

  @override
  String toString() {
    return 'RatingsTb{idProducto: $idProducto, nombreImage: $nombreImage, urlImage: $urlImage, isPrincipalImage: $isPrincipalImage}';
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
    return 'RatingsTb{idProducto: $idProducto, urlImage: $urlImage, isPrincipalImage: $isPrincipalImage}';
  }
}
