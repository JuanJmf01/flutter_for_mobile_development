import 'dart:typed_data';

class ImageStorageTb {
  final int idUsuario;
  final int idFile;
  final Uint8List newImageBytes;
  final String fileName;
  final String imageName;
  final double width;
  final double height;
  final int isPrincipalImage;

  ImageStorageTb(
      {required this.idUsuario,
      required this.idFile,
      required this.newImageBytes,
      required this.fileName,
      required this.imageName,
      required this.width,
      required this.height,
      required this.isPrincipalImage});
}

class ImageStorageCreacionTb {
  final int idUsuario;
  final int idProServicio;
  final Uint8List newImageBytes;
  final String fileName;
  final String finalNameImage;

  ImageStorageCreacionTb({
    required this.idUsuario,
    required this.idProServicio,
    required this.newImageBytes,
    required this.fileName,
    required this.finalNameImage,
  });
}

class ImageStorageDeleteTb {
  final String fileName;
  final int idUsuario;
  final String nombreImagen;
  final int idProServicio;

  ImageStorageDeleteTb({
    required this.fileName,
    required this.idUsuario,
    required this.nombreImagen,
    required this.idProServicio,
  });
}
