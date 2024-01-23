import 'dart:io';
import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:etfi_point/Components/Data/Firebase/Storage/FirebaseImagesStorage.dart';
import 'package:etfi_point/Components/Utils/AssetToUint8List.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/editarImagen.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/fileTemporal.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Services/MediaPicker.dart';
import 'package:etfi_point/Components/Utils/Services/assingName.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/globalButtonBase.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/itemForModalButons.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/smallButtonTopTab.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class ButtonFotoPerfilPortada extends StatefulWidget {
  const ButtonFotoPerfilPortada({
    super.key,
    required this.verFoto,
    required this.cambiarFoto,
    this.eliminarFoto,
    required this.isProfilePicture,
    required this.isUrlPhotoAvailable,
    required this.onProfileUpdated,
  });

  final String verFoto;
  final String cambiarFoto;
  final String? eliminarFoto;
  final bool isProfilePicture;
  final bool isUrlPhotoAvailable;
  final void Function(UsuarioTb) onProfileUpdated;

  @override
  State<ButtonFotoPerfilPortada> createState() =>
      _ButtonFotoPerfilPortadaState();
}

class _ButtonFotoPerfilPortadaState extends State<ButtonFotoPerfilPortada> {
  final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10.0);

  final Color colorIcons = Colors.black54;

  @override
  void initState() {
    super.initState();
  }

  Future<UsuarioTb> updateUser(
      urlImage, idUsuarioActual, isProfilePicture) async {
    UsuarioTb updatedUser = await UsuarioDb.updatePhotoProfileOrPortada(
      urlImage,
      idUsuarioActual,
      isProfilePicture,
    );
    widget.onProfileUpdated(updatedUser);

    return updatedUser;
  }

  void insertProfileOrPerfilImage(int idUsuarioActual) async {
    Asset? imageAsset = await getImageAsset();

    if (imageAsset != null) {
      File tempFile = await FileTemporal.convertToTempFile(image: imageAsset);

      bool isProfilePicture = widget.isProfilePicture;

      Uint8List? finalImage = isProfilePicture
          ? await EditarImagen.editCircularImage(tempFile)
          : await EditarImagen.editImage(tempFile, 2.5, 2);

      String fileName = isProfilePicture ? "fotoPerfil" : "fotoPortada";
      if (fileName != '' && finalImage != null) {
        ImageStorageTb image = ImageStorageTb(
          idUsuario: idUsuarioActual,
          newImageBytes: finalImage,
          fileName: fileName,
          imageName: assingName(imageAsset.name!),
          width: imageAsset.originalWidth!.toDouble(),
          height: imageAsset.originalHeight!.toDouble(),
        );

        String urlImage = widget.isUrlPhotoAvailable
            ? await ImagesStorage.updateImageByPosition(image, 0)
            : await ImagesStorage.cargarImage(image);

        print("URL IMAGE: $urlImage");

        if (urlImage != '' || urlImage != null) {
          updateUser(urlImage, idUsuarioActual, isProfilePicture);
        }
      }
    }
  }

  void deleteProfileOrPerfilImage(int idUsuarioActual) async {
    bool isProfilePicture = widget.isProfilePicture;

    String fileName = isProfilePicture ? "fotoPerfil" : "fotoPortada";

    UsuarioTb newUser = await updateUser('', idUsuarioActual, isProfilePicture);
    if (isProfilePicture) {
      if (newUser.urlFotoPerfil == '' || newUser.urlFotoPerfil == null) {
        ImagesStorage.deleteDirectory(idUsuarioActual, fileName);
      }
    } else {
      if (newUser.urlFotoPortada == '' || newUser.urlFotoPortada == null) {
        ImagesStorage.deleteDirectory(idUsuarioActual, fileName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int? idUsuarioActual =
        Provider.of<UsuarioProvider>(context).idUsuarioActual;

    return GlobalButtonBase(
      itemsColumn: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmallButtonTopTab(),
          ItemForModalButtons(
            onPress: () {},
            padding: padding,
            textItem: widget.verFoto,
          ),
          ItemForModalButtons(
            onPress: () {
              insertProfileOrPerfilImage(idUsuarioActual);
              Navigator.pop(context);
            },
            padding: padding,
            textItem: widget.cambiarFoto,
          ),
          widget.eliminarFoto != null
              ? ItemForModalButtons(
                  onPress: () {
                    deleteProfileOrPerfilImage(idUsuarioActual);
                    Navigator.pop(context);
                  },
                  padding: padding,
                  textItem: widget.eliminarFoto!,
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
