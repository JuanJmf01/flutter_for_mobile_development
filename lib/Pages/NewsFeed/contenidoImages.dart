import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Utils/pageViewImagesScroll.dart';
import 'package:etfi_point/Pages/NewsFeed/contenidoPublicacion.dart';
import 'package:etfi_point/Pages/NewsFeed/recoverfieldsUtility.dart';
import 'package:flutter/material.dart';

class ContenidoImages extends StatelessWidget {
  const ContenidoImages({
    super.key,
    required this.item,
    required this.idUsuarioActual,
  });

  final NewsFeedItem item;
  final int idUsuarioActual;

  @override
  Widget build(BuildContext context) {
    double paddingTopEachPublicacion = 40.0;
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
        padding: EdgeInsets.only(top: paddingTopEachPublicacion),
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
              child: Container(
                width: 355,
                height: 365,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                ),
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
      return SizedBox.shrink();
    }
  }
}
