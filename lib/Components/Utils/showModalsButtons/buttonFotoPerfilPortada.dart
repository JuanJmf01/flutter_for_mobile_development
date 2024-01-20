import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/Firebase/Storage/productImagesStorage.dart';
import 'package:etfi_point/Components/Utils/AssetToUint8List.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Services/MediaPicker.dart';
import 'package:etfi_point/Components/Utils/Services/assingName.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/globalButtonBase.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/itemForModalButons.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/smallButtonTopTab.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class ButtonFotoPerfilPortada extends StatelessWidget {
  const ButtonFotoPerfilPortada({
    super.key,
    required this.verFoto,
    required this.cambiarFoto,
    required this.eliminarFoto,
  });

  final String verFoto;
  final String cambiarFoto;
  final String eliminarFoto;

  final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10.0);
  final Color colorIcons = Colors.black54;

  void insertProfileImage(int idUsuarioActual) async {
    Asset? imageAsset = await getImageAsset();
    if (imageAsset != null) {
      ImageStorageTb image = ImageStorageTb(
        idUsuario: idUsuarioActual,
        newImageBytes: await assetToUint8List(imageAsset),
        fileName: 'fotoPerfil',
        imageName: assingName(imageAsset.name!),
        width: imageAsset.originalWidth!.toDouble(),
        height: imageAsset.originalHeight!.toDouble(),
      );

      String urlImage = await ImagesStorage.cargarImage(image);
      print("URL IMAGE: $urlImage");
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
            textItem: verFoto,
          ),
          ItemForModalButtons(
            onPress: () {
              insertProfileImage(idUsuarioActual);
            },
            padding: padding,
            textItem: cambiarFoto,
          ),
          ItemForModalButtons(
            onPress: () {},
            padding: padding,
            textItem: eliminarFoto,
          )
        ],
      ),
    );
  }
}
