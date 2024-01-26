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

  ImageStorageTb({
    required this.idUsuario,
    required this.newImageBytes,
    required this.fileName,
    required this.imageName,
  });
}

class ImageStorageDeleteTb {
  final int idUsuario;
  final int idFile;
  final String fileName;
  final String imageName;

  ImageStorageDeleteTb({
    required this.idUsuario,
    required this.idFile,
    required this.fileName,
    required this.imageName,
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
