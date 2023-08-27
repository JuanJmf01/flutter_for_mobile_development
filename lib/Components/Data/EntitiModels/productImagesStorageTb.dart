import 'dart:typed_data';

import 'package:multi_image_picker/multi_image_picker.dart';

class ProductCreacionImagesStorageTb {
  final int idUsuario;
  final int idProducto;
  final Uint8List newImageBytes;
  final String fileName;
  final String imageName;
  final double width;
  final double height;
  final int isPrincipalImage;

  ProductCreacionImagesStorageTb(
      {required this.idUsuario,
      required this.idProducto,
      required this.newImageBytes,
      required this.fileName,
      required this.imageName,
      required this.width,
      required this.height,
      required this.isPrincipalImage});
}

class ProductImageStorageTb {
  final int idUsuario;
  final int idProducto;
  final Asset newImage;
  final String fileName;
  final String nombreImagen;
  final double width;
  final double height;
  final int isPrincipalImage;

  ProductImageStorageTb(
      {required this.newImage,
      required this.fileName,
      required this.idUsuario,
      required this.nombreImagen,
      required this.idProducto,
      required this.width,
      required this.height,
      required this.isPrincipalImage});
}

class ProductImageStorageDeleteTb {
  final String fileName;
  final int idUsuario;
  final String nombreImagen;
  final int idProducto;
  final int idProductImage;

  ProductImageStorageDeleteTb(
      {required this.fileName,
      required this.idUsuario,
      required this.nombreImagen,
      required this.idProducto,
      required this.idProductImage});
}
