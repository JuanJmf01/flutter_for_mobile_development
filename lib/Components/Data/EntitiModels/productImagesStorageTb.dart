import 'package:multi_image_picker/multi_image_picker.dart';

class ProductCreacionImagesStorageTb {
  final Asset newImage;
  final String fileName;
  final int idUsuario;
  final int idProducto;
  final int isPrincipalImage;

  ProductCreacionImagesStorageTb(
      {required this.newImage,
      required this.fileName,
      required this.idUsuario,
      required this.idProducto,
      required this.isPrincipalImage});
}

class ProductImageStorageTb {
  final Asset newImage;
  final String fileName;
  final int idUsuario;
  final String nombreImagen;
  final int idProducto;
  final int isPrincipalImage;

  ProductImageStorageTb(
      {required this.newImage,
      required this.fileName,
      required this.idUsuario,
      required this.nombreImagen,
      required this.idProducto,
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
