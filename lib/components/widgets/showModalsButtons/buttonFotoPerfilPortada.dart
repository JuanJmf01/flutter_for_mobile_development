import 'dart:io';
import 'dart:typed_data';

import 'package:etfi_point/Data/models/productImagesStorageTb.dart';
import 'package:etfi_point/Data/models/usuarioTb.dart';
import 'package:etfi_point/Data/services/api/usuarioDb.dart';
import 'package:etfi_point/Data/services/api/FirebaseStorage/firebaseImagesStorage.dart';
import 'package:etfi_point/components/utils/editarImagen.dart';
import 'package:etfi_point/components/widgets/ImagesUtils/fileTemporal.dart';
import 'package:etfi_point/components/utils/MediaPicker.dart';
import 'package:etfi_point/components/utils/randomServices.dart';
import 'package:etfi_point/components/widgets/showModalsButtons/globalButtonBase.dart';
import 'package:etfi_point/components/widgets/showModalsButtons/itemForModalButons.dart';
import 'package:etfi_point/components/widgets/showModalsButtons/smallButtonTopTab.dart';
import 'package:etfi_point/Data/services/providers/userStateProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ButtonFotoPerfilPortada extends ConsumerWidget {
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

  final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10.0);

  final Color colorIcons = Colors.black54;

  Future<UsuarioTb> updateUser(
      urlImage, idUsuarioActual, isProfilePicture) async {
    UsuarioTb updatedUser = await UsuarioDb.updatePhotoProfileOrPortada(
      urlImage,
      idUsuarioActual,
      isProfilePicture,
    );
    onProfileUpdated(updatedUser);

    return updatedUser;
  }

  void insertProfileOrPerfilImage(int idUsuarioActual) async {
    Asset? imageAsset = await getImageAsset();

    if (imageAsset != null) {
      File tempFile = await FileTemporal.convertToTempFile(image: imageAsset);

      Uint8List? finalImage = isProfilePicture
          ? await EditarImagen.editCircularImage(tempFile)
          : await EditarImagen.editImage(tempFile, 2.5, 2);

      String fileName = isProfilePicture ? "fotoPerfil" : "fotoPortada";
      if (fileName != '' && finalImage != null) {
        ImageStorageTb image = ImageStorageTb(
          idUsuario: idUsuarioActual,
          newImageBytes: finalImage,
          fileName: fileName,
          imageName: RandomServices.assingName(imageAsset.name!),
        );

        String urlImage = isUrlPhotoAvailable
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
    String fileName = isProfilePicture ? "fotoPerfil" : "fotoPortada";

    UsuarioTb newUser = await updateUser('', idUsuarioActual, isProfilePicture);
    String urlDirectory = 'imagenes/$idUsuarioActual/$fileName';
    if (isProfilePicture) {
      if (newUser.urlFotoPerfil == '' || newUser.urlFotoPerfil == null) {
        ImagesStorage.deleteDirectory(urlDirectory);
      }
    } else {
      if (newUser.urlFotoPortada == '' || newUser.urlFotoPortada == null) {
        ImagesStorage.deleteDirectory(urlDirectory);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //int? idUsuarioActual = Provider.of<UsuarioProvider>(context).idUsuarioActual;

    final int? idUsuarioActual = ref.watch(getCurrentUserProvider).value;

    return GlobalButtonBase(
      itemsColumn: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SmallButtonTopTab(),
          ItemForModalButtons(
            onPress: () {},
            padding: padding,
            textItem: verFoto,
          ),
          ItemForModalButtons(
            onPress: () {
              if (idUsuarioActual != null) {
                insertProfileOrPerfilImage(idUsuarioActual);
                Navigator.pop(context);
              }
            },
            padding: padding,
            textItem: cambiarFoto,
          ),
          eliminarFoto != null
              ? ItemForModalButtons(
                  onPress: () {
                    if (idUsuarioActual != null) {
                      deleteProfileOrPerfilImage(idUsuarioActual);
                      Navigator.pop(context);
                    }
                  },
                  padding: padding,
                  textItem: eliminarFoto!,
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
