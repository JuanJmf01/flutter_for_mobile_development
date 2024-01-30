import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Utils/showVideo.dart';
import 'package:etfi_point/Pages/NewsFeed/contenidoPublicacion.dart';
import 'package:etfi_point/Pages/NewsFeed/recoverfieldsUtility.dart';
import 'package:flutter/cupertino.dart';

class ContenidoReels extends StatelessWidget {
  const ContenidoReels({
    Key? key,
    required this.item,
    required this.idUsuarioActual,
  }) : super(key: key);

  final NewsFeedItem item;
  final int idUsuarioActual;

  @override
  Widget build(BuildContext context) {
    double paddingTopEachPublicacion = 40.0;
    dynamic newItem;

    if (item is NeswFeedReelPublicacionTb ||
        item is NeswFeedReelServiceTb ||
        item is NeswFeedReelProductTb) {
      newItem = item;
    }

    if (newItem is NeswFeedReelPublicacionTb ||
        newItem is NeswFeedReelServiceTb ||
        newItem is NeswFeedReelProductTb) {
      List<NewsFeedItem> items = [];
      items.add(newItem);
      return Padding(
        padding: EdgeInsets.only(top: paddingTopEachPublicacion),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (newItem != null)
              ContenidoParteSuperior(
                idUsuario: RecoverFieldsUtiliti.getIdUsuario(newItem)!,
                nombreUsuario: RecoverFieldsUtiliti.getNombreUsuario(newItem)!,
                descripcion:
                    RecoverFieldsUtiliti.getDescripcionPublicacion(newItem),
              ),
            if (newItem != null)
              ShowVideo(
                urlReel:
                    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                items: items,
              ),
            if (newItem != null)
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
