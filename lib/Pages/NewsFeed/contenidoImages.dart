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
      return const SizedBox.shrink();
    }
  }
}

class ContenidoImages2 extends StatefulWidget {
  const ContenidoImages2({super.key});

  @override
  State<ContenidoImages2> createState() => _ContenidoImages2State();
}

class _ContenidoImages2State extends State<ContenidoImages2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey,
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("My Username"),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.comment_bank_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.bookmark)),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("1.12 likes"),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 8),
                    child: const Text("Esta son los coentarioself,eof"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
