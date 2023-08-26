import 'package:multi_image_picker/multi_image_picker.dart';

class ProductoTb {
  final int idProducto; // PK
  final int idNegocio; // FK
  final String nombreProducto;
  final double precio;
  final String? descripcion;
  final String? descripcionDetallada;
  final int cantidadDisponible;
  final int? oferta; // bool (0 or 1)
  final String urlImage;
  final String nombreImage;
  //String? fechaDeCreacion;
  //int? estado;

  ProductoTb(
      {required this.idProducto,
      required this.idNegocio,
      required this.nombreProducto,
      required this.precio,
      this.descripcion,
      this.descripcionDetallada,
      required this.cantidadDisponible,
      this.oferta,
      required this.urlImage,
      required this.nombreImage
      //this.fechaDeCreacion,
      //this.estado,
      });

  factory ProductoTb.fromJson(Map<String, dynamic> json) {
    return ProductoTb(
      idProducto: json['idProducto'],
      idNegocio: json['idNegocio'],
      nombreProducto: json['nombreProducto'],
      precio: json['precio'].toDouble(),
      descripcion: json['descripcion'],
      descripcionDetallada: json['descripcionDetallada'],
      cantidadDisponible: json['cantidadDisponible'],
      oferta: json['oferta'],
      urlImage: json['urlImage'],
      nombreImage: json['nombreImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'idNegocio': idNegocio,
      'nombreProducto': nombreProducto,
      'precio': precio,
      'descripcion': descripcion,
      'descripcionDetallada': descripcionDetallada,
      'cantidadDisponible': cantidadDisponible,
      'oferta': oferta,
      'urlImage': urlImage,
      'nombreImage': nombreImage,
      //'fechaDeCreacion': fechaDeCreacion,
      //'estado': estado,
    };
  }

  @override
  String toString() {
    return 'ProductoTb{idProducto: $idProducto, nombreProducto: $nombreProducto, nombreImage: $nombreImage}';
  }
}

class ProductoCreacionTb {
  final int idNegocio; // FK
  final String nombreProducto;
  final double precio;
  final String? descripcion;
  final String? descripcionDetallada;
  final int cantidadDisponible;
  final int? oferta; // bool (0 or 1)

  ProductoCreacionTb({
    required this.idNegocio,
    required this.nombreProducto,
    required this.precio,
    this.descripcion,
    this.descripcionDetallada,
    required this.cantidadDisponible,
    this.oferta,
  });

  //FromJson

  Map<String, dynamic> toMap() {
    return {
      'idNegocio': idNegocio,
      'nombreProducto': nombreProducto,
      'precio': precio,
      'descripcion': descripcion,
      'descripcionDetallada': descripcionDetallada,
      'cantidadDisponible': cantidadDisponible,
      'oferta': oferta,
    };
  }

  @override
  String toString() {
    return 'ProductoCreacionTb{nombreProducto: $nombreProducto}';
  }
}

class ProductSample {
  final String nombreSample;
  final String precioSample;
  final Asset? imageSample;

  ProductSample({
    required this.nombreSample,
    required this.precioSample,
    this.imageSample,
  });
}
