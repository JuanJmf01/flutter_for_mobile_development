import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Utils/showVideo.dart';
import 'package:etfi_point/Pages/NewsFeed/contenidoImages.dart';
import 'package:etfi_point/Pages/NewsFeed/contenidoPublicacion.dart';
import 'package:flutter/cupertino.dart';

class ContenidoReels extends StatelessWidget {
  const ContenidoReels({
    super.key,
    required this.descripcion,
    required this.urlReel,
    required this.index,
    required this.usuario,
    required this.objectType,
    required this.likes,
    required this.idPublicacion,
    this.idProServicio,
    required this.idUsuarioActual,
  });

  final String descripcion;
  final String urlReel;
  final int index;
  final UsuarioTb usuario;
  final Type objectType;
  final int likes;
  final int idPublicacion;
  final int? idProServicio;
  final int idUsuarioActual;

  @override
  Widget build(BuildContext context) {
    double paddingTopEachPublicacion = 40.0;

    return Padding(
      padding: EdgeInsets.only(top: paddingTopEachPublicacion),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContenidoParteSuperior(
              idUsuario: usuario.idUsuario, nombreUsuario: usuario.nombres),
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 8.0, 0.0, 10.0),
            child: Text(
              descripcion,
              style: TextStyle(fontSize: 16.8),
            ),
          ),
          ShowVideo(
            urlReel:
                "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
          ),
          // Fila de iconos
          FilaIconos(
            objectType: objectType,
            index: index,
            like: likes,
            idPublicacion: idPublicacion,
            idProServicio: idProServicio,
            idUsuarioActual: idUsuarioActual,
          )
        ],
      ),
    );
  }
}
