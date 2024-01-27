import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Utils/pageViewImagesScroll.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/NewsFeed/contenidoPublicacion.dart';
import 'package:etfi_point/main.dart';
import 'package:flutter/material.dart';

class ContenidoImages extends StatelessWidget {
  const ContenidoImages({
    super.key,
    required this.descripcion,
    required this.images,
    required this.objectType,
    required this.index,
    required this.usuario,
    required this.likes,
    required this.idPublicacion,
    this.idProServicio,
    required this.idUsuarioActual,
  });

  final String descripcion;
  final List<dynamic> images;
  final Type objectType;
  final int index;
  final UsuarioTb usuario;
  final int likes;
  final int idPublicacion;
  final int? idProServicio;
  final int idUsuarioActual;

  @override
  Widget build(BuildContext context) {
    double paddingTopEachPublicacion = 40.0;
    double paddingMedia = 20.0;

    return Padding(
      padding: EdgeInsets.only(top: paddingTopEachPublicacion),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Contenido parte superior de cada publicacion
          ContenidoParteSuperior(
            idUsuario: usuario.idUsuario,
            nombreUsuario: usuario.nombres,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 8.0, 0.0, 0.0),
            child: Text(
              descripcion,
              style: TextStyle(fontSize: 16.8),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(paddingMedia, 10.0, 0.0, 0.0),
            child: Container(
              width: 355,
              height: 365,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: PageViewImagesScroll(images: images),
            ),
          ),
          FilaIconos(
              objectType: objectType,
              index: index,
              like: likes,
              idPublicacion: idPublicacion,
              idProServicio: idProServicio,
              idUsuarioActual: idUsuarioActual)
        ],
      ),
    );
  }
}

class ContenidoParteSuperior extends StatelessWidget {
  const ContenidoParteSuperior({
    super.key,
    required this.idUsuario,
    required this.nombreUsuario,
    this.urlFotoPerfil,
  });

  final int idUsuario;
  final String nombreUsuario;
  final String? urlFotoPerfil;

  @override
  Widget build(BuildContext context) {
    BorderRadius borderImageProfile = BorderRadius.circular(50.0);
    double sizeImageProfile = 53.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(
              currentIndex: 1,
              idUsuario: idUsuario,
            ),
          ),
        );
      },
      child: Row(
        children: [
          urlFotoPerfil != null && urlFotoPerfil != ''
              ? ShowImage(
                  networkImage: urlFotoPerfil,
                  widthNetWork: sizeImageProfile,
                  heightNetwork: sizeImageProfile,
                  borderRadius: borderImageProfile,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: sizeImageProfile,
                  width: sizeImageProfile,
                  decoration: BoxDecoration(
                      borderRadius: borderImageProfile,
                      color: Colors.grey.shade200),
                ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 7.0),
            child: Text(
              nombreUsuario,
              style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
