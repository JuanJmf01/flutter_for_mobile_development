import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/enlaces/enlaceProServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/enlaces/enlaceProServicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Entities/enlaces/enlaceProServicioDb.dart';
import 'package:etfi_point/Components/Data/Entities/enlaces/enlaceProServicioImagesDb.dart';
import 'package:etfi_point/Components/Data/Firebase/Storage/FirebaseImagesStorage.dart';
import 'package:etfi_point/Components/Utils/AssetToUint8List.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CargarMediaDeEnlaces {
  static void subirImagenes(
      int idEnlaceProServicio,
      bool isProduct,
      Type objectTypeEnlaceProducto,
      int idUsuario,
      List<ProServicioImageToUpload> imagesToUpload) async {
    String fileName = isProduct ? 'enlaceProductos' : 'enlaceServicios';

    for (var imageToUpload in imagesToUpload) {
      ImagesStorageTb image = ImagesStorageTb(
        idUsuario: idUsuario,
        idFile: idEnlaceProServicio,
        newImageBytes: await assetToUint8List(imageToUpload.newImage),
        fileName: fileName,
        imageName: imageToUpload.nombreImage,
      );

      String urlImage = await ImagesStorage.cargarImage(image);

      EnlaceProServicioImagesCreacionTb enlaceProServicioImage =
          EnlaceProServicioImagesCreacionTb(
        idEnlaceProServicio: idEnlaceProServicio,
        nombreImage: imageToUpload.nombreImage,
        urlImage: urlImage,
        width: imageToUpload.width,
        height: imageToUpload.height,
      );

      EnlaceProServicioImagesDb.insertEnlaceProServicioImage(
          enlaceProServicioImage, objectTypeEnlaceProducto);
    }
  }

  static void guardarEnlace(
    TextEditingController descripcionController,
    dynamic selectedProServicio,
    int idUsuario,
    List<ProServicioImageToUpload> imagesToUpload,
  ) async {
    final descripcion = descripcionController.text;
    int idProservicio = -1;
    bool isProduct = selectedProServicio is ProductoTb;
    Type objectTypeEnlaceProducto;

    if (isProduct) {
      idProservicio = selectedProServicio.idProducto;
      objectTypeEnlaceProducto = ProductoTb;
    } else {
      idProservicio = selectedProServicio.idServicio;
      objectTypeEnlaceProducto = ServicioTb;
    }

    if (idProservicio != -1) {
      EnlaceProServicioCreacionTb enlaceProducto = EnlaceProServicioCreacionTb(
        idProServicio: idProservicio,
        descripcion: descripcion,
      );

      int idEnlaceProServicio =
          await EnlaceProServicioDb.insertEnlaceProServicio(
              enlaceProducto, objectTypeEnlaceProducto);

      subirImagenes(
        idEnlaceProServicio,
        isProduct,
        objectTypeEnlaceProducto,
        idUsuario,
        imagesToUpload,
      );
    } else {
      print("Error al asignar el idProServicio en enlaceProducto");
    }
  }

  static Future<String> uploadVideoAndGetURL(
      VideoStorageCreacionTb video) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    String fileName = video.fileName;
    int idUsuario = video.idUsuario;

    // Convertir XFile a File
    File videoFile = File(video.video.path);

    Reference ref = storage
        .ref()
        .child('videos/$idUsuario/$fileName')
        .child(video.finalNameVideo);

    UploadTask uploadTask = ref.putFile(videoFile);

    TaskSnapshot snapshot =
        await uploadTask.whenComplete(() => print('Video subido exitosamente'));

    // Obtener la URL del video cargado
    String downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }
}
