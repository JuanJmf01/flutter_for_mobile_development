import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ImagesStorageTb {
  final int idUsuario;
  final int idFile;
  final Uint8List newImageBytes;
  final String fileName;
  final String imageName;

  ImagesStorageTb(
      {required this.idUsuario,
      required this.idFile,
      required this.newImageBytes,
      required this.fileName,
      required this.imageName});
}


class ImageStorageTb {
  final int idUsuario;
  final Uint8List newImageBytes;
  final String fileName;
  final String imageName;
  final double width;
  final double height;

  ImageStorageTb({
    required this.idUsuario,
    required this.newImageBytes,
    required this.fileName,
    required this.imageName,
    required this.width,
    required this.height,
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

class VideoStorageCreacionTb {
  final int idUsuario;
  final XFile video;
  final String fileName;
  final String finalNameVideo;

  VideoStorageCreacionTb({
    required this.idUsuario,
    required this.video,
    required this.fileName,
    required this.finalNameVideo,
  });
}
