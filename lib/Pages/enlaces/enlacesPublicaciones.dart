import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/Entities/Publicaciones/enlacePublicacionesDb.dart';
import 'package:etfi_point/Components/Utils/futureGridViewProfile.dart';
import 'package:etfi_point/Components/Utils/pageViewNewsFeed.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/NewsFeed/recoverfieldsUtility.dart';
import 'package:flutter/material.dart';

class EnlacesPublicaciones extends StatelessWidget {
  const EnlacesPublicaciones({super.key, required this.idUsuario});

  final int idUsuario;

  @override
  Widget build(BuildContext context) {
    List<NewsFeedItem> enlacesPublicacion = ([]);

    Future<List<NewsFeedItem>> enlacesPublicaciones(int idUsuario) async {
      NewsFeedTb enlacePublicaciones =
          await EnlacePublicacionesDb.getAllNewsFeed(idUsuario);

      List<NewsFeedItem> items = enlacePublicaciones.newsFeed;
      enlacesPublicacion = items;

      return items;
    }

    //int idUsuarioActual = context.watch<UsuarioProvider>().idUsuarioActual;
    double screenWidth = MediaQuery.of(context).size.width * 0.31;

    return FutureGridViewProfile(
      idUsuario: idUsuario,
      future: () => enlacesPublicaciones(idUsuario),
      bodyItemBuilder: (int index, Object item) => IndividulEnlace(
          enlacePublicacion: item, enlacesPublicacion: enlacesPublicacion),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 15.0,
        mainAxisExtent: screenWidth,
      ),
      globalPaddingAll: 3.0,
    );
  }
}

// tener en cuenta ambos required this.enlacePublicacion, required this.enlacesPublicacion. Ver posivilidad de implementar GestureDetector en EnlacesPublicaciones y evitar el uso de enlacesPublicacion
class IndividulEnlace extends StatelessWidget {
  const IndividulEnlace({
    super.key,
    required this.enlacePublicacion,
    required this.enlacesPublicacion,
  });

  final dynamic enlacePublicacion;
  final List<NewsFeedItem> enlacesPublicacion;

  @override
  Widget build(BuildContext context) {
    BorderRadius borderImage = BorderRadius.circular(6.0);
    RecoverFieldsUtiliti.getUrlImage(enlacePublicacion);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PageViewNewsFeed(newsFeedItems: enlacesPublicacion),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderImage,
          color: Colors.grey.shade300,
        ),
        child: ShowImage(
          borderRadius: borderImage,
          //networkImage: enlacePublicacion.enlaceProServicioImages[0].urlImage,
          networkImage: RecoverFieldsUtiliti.getUrlImage(enlacePublicacion),
          fit: BoxFit.cover,
          height: 150.0,
          width: 150.0,
        ),
      ),
    );
  }
}
