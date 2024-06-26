import 'package:etfi_point/Data/models/newsFeedTb.dart';
import 'package:etfi_point/components/widgets/pageViewImagesScroll.dart';
import 'package:etfi_point/Screens/NewsFeed/contenidoPublicacion.dart';
import 'package:etfi_point/Screens/NewsFeed/recoverfieldsUtility.dart';
import 'package:flutter/material.dart';

class ImagePostContent extends StatelessWidget {
  const ImagePostContent({
    super.key,
    required this.item,
    required this.idUsuarioActual,
  });

  final NewsFeedItem item;
  final int idUsuarioActual;

  @override
  Widget build(BuildContext context) {
    double paddingBottomEachPublicacion = 40.0;
    double paddingMedia = 20.0;

    dynamic newItem;

    if (item is NeswFeedPublicacionesTb ||
        item is NewsFeedProductosTb ||
        item is NewsFeedServiciosTb) {
      newItem = item;
    }

    if (newItem is NewsFeedProductosTb ||
        newItem is NewsFeedServiciosTb ||
        newItem is NeswFeedPublicacionesTb) {
      return Padding(
        padding: EdgeInsets.only(bottom: paddingBottomEachPublicacion),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Contenido parte superior de cada publicacion
            ContenidoParteSuperior(
              idUsuario: RecoverFieldsUtiliti.getIdUsuario(newItem)!,
              nombreUsuario: RecoverFieldsUtiliti.getNombreUsuario(newItem)!,
              descripcion:
                  RecoverFieldsUtiliti.getDescripcionPublicacion(newItem),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(paddingMedia, 0.0, 0.0, 0.0),
              child: SizedBox(
                width: 355,
                height: 365,
                child: PageViewImagesScroll(
                    images: RecoverFieldsUtiliti.getImagesPublicacion(newItem)),
              ),
            ),
            FilaIconos(
              idUsuarioActual: idUsuarioActual,
              objectType: newItem.runtimeType,
              like: RecoverFieldsUtiliti.getLikePublicacion(newItem),
              idProServicio: RecoverFieldsUtiliti.getIdProServicio(newItem),
              idPublicacion: RecoverFieldsUtiliti.getIdPublicacion(newItem)!,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
