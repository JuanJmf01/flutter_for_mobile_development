import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/Entities/Publicaciones/enlacePublicacionesDb.dart';
import 'package:etfi_point/Components/Utils/futureGridViewProfile.dart';
import 'package:etfi_point/Components/Utils/pageViewNewsFeed.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Screens/NewsFeed/recoverfieldsUtility.dart';
import 'package:flutter/material.dart';

class EnlacesImagePublicaciones extends StatelessWidget {
  EnlacesImagePublicaciones({super.key, required this.idUsuario});

  final int idUsuario;

  final List<NewsFeedItem> enlacesPublicacion = [];

  Future<List<NewsFeedItem>> enlacesPublicaciones(int idUsuario) async {
    NewsFeedTb enlacePublicaciones =
        await EnlacePublicacionesDb.getAllEnlacePublicacionesImages(idUsuario);
    List<NewsFeedItem> items = enlacePublicaciones.newsFeed;
    enlacesPublicacion.addAll(items);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.33;
    return FutureGridViewProfile(
      idUsuario: idUsuario,
      future: () => enlacesPublicaciones(idUsuario),
      bodyItemBuilder: (int index, Object item) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PageViewNewsFeed(newsFeedItems: enlacesPublicacion),
            ),
          );
        },
        child: IndividualEnlace(enlacePublicacion: item),
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3.0,
        mainAxisSpacing: 3.0,
        mainAxisExtent: screenWidth,
      ),
      globalPaddingAll: 2.0,
    );
  }
}

class IndividualEnlace extends StatelessWidget {
  const IndividualEnlace({
    super.key,
    required this.enlacePublicacion,
  });

  final dynamic enlacePublicacion;

  @override
  Widget build(BuildContext context) {
    BorderRadius borderImage = BorderRadius.circular(6.0);
    RecoverFieldsUtiliti.getUrlImage(enlacePublicacion);
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderImage,
        color: Colors.grey.shade300,
      ),
      child: ShowImage(
        borderRadius: borderImage,
        //networkImage: enlacePublicacion.enlaceProServicioImages[0].urlImage,
        networkImage: RecoverFieldsUtiliti.getUrlImage(enlacePublicacion),
        fit: BoxFit.cover,
      ),
    );
  }
}
