import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/enlaces/ratingsEnlaceProServicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/noEnlaces/ratingsPublicacionesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/Entities/Publicaciones/enlaces/ratingsEnlaceProServicioDb.dart';
import 'package:etfi_point/Components/Data/Entities/Publicaciones/no%20enlaces/ratingsFotoAndReelPublicacionDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
import 'package:etfi_point/Components/Utils/Icons/icons.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/proServicios/proServicioDetail.dart';
import 'package:etfi_point/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilaIconos extends StatefulWidget {
  const FilaIconos({
    super.key,
    this.idProServicio,
    required this.idUsuarioActual,
    required this.objectType,
    required this.like,
    required this.idPublicacion,
  });

  final int? idProServicio;
  final int idUsuarioActual;
  final Type objectType;
  final int like;
  final int idPublicacion;

  @override
  State<FilaIconos> createState() => _FilaIconosState();
}

class _FilaIconosState extends State<FilaIconos> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();

    isLiked = widget.like == 1;
  }

  void saveRatingEnlaceProServicio() {
    print('Like: $isLiked');
    RatingsEnlaceProServicioTb ratingEnlaceProducto =
        RatingsEnlaceProServicioTb(
      idUsuario: widget.idUsuarioActual,
      idEnlaceProServicio: widget.idPublicacion,
      likes: isLiked ? 0 : 1,
    );

    RatingsEnlaceProServicioDb.saveRating(widget.idPublicacion,
        widget.idUsuarioActual, ratingEnlaceProducto, widget.objectType);
  }

  void saveRatingPublicacion() {
    RatingsPublicacionesTb ratingPublicacion = RatingsPublicacionesTb(
        idUsuario: widget.idUsuarioActual,
        idPublicacion: widget.idPublicacion,
        likes: isLiked ? 0 : 1);

    RatingsFotoAndReelPublicacionDb.saveRating(widget.idPublicacion,
        widget.idUsuarioActual, ratingPublicacion, widget.objectType);
  }

  void handleLike(bool like) {
    print("TIPO OBJETOI: ${widget.objectType}");
    if (widget.objectType == NeswFeedReelPublicacionTb ||
        widget.objectType == NeswFeedPublicacionesTb) {
      saveRatingPublicacion();
    } else {
      saveRatingEnlaceProServicio();
    }
    setState(() {
      isLiked = like;
    });
  }

  void navigateToServiceOrProductDetail(Type objectType, int idProServicio) {
    if (objectType == NewsFeedProductosTb ||
        objectType == NeswFeedReelProductTb) {
      navigateToProductDetail(idProServicio);
    } else if (objectType == NewsFeedServiciosTb ||
        objectType == NeswFeedReelServiceTb) {
      navigateToServiceDetail(idProServicio);
    }
  }

  void navigateToServiceDetail(int idServicio) {
    ServicioDb.getServicio(idServicio).then((servicio) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProServicioDetail(
            proServicio: servicio,
            nameContexto: "servicio",
          ),
        ),
      );
    });
  }

  void navigateToProductDetail(int idProducto) {
    ProductoDb.getProducto(idProducto).then((producto) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProServicioDetail(
            proServicio: producto,
            nameContexto: "producto",
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //bool isLiked = isLikedMap[index] ?? (like == 1); // Asumimos 'false' si es nulo
    double iconSize = 32.0;
    double iconPaddingRight = 20.0;
    double paddingMedia = 20.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(paddingMedia, 10.0, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isLiked == true
              ? ManageIcon(
                  size: iconSize,
                  icon: CupertinoIcons.heart_fill,
                  color: Colors.red,
                  paddingLeft: 10.0,
                  paddingRight: 15.0,
                  onTap: () => handleLike(false),
                )
              : ManageIcon(
                  icon: CupertinoIcons.heart,
                  size: iconSize,
                  paddingLeft: 10.0,
                  paddingRight: iconPaddingRight,
                  onTap: () => handleLike(true),
                ),
          ManageIcon(
            size: iconSize,
            paddingRight: iconPaddingRight,
            icon: CupertinoIcons.chat_bubble_text,
          ),
          ManageIcon(
            size: iconSize,
            paddingRight: iconPaddingRight,
            icon: CupertinoIcons.paperplane,
          ),
          ManageIcon(
            icon: CupertinoIcons.square,
            paddingRight: iconPaddingRight,
            size: iconSize,
          ),
          const Spacer(),
          widget.idProServicio != null
              ? ManageIcon(
                  icon: CupertinoIcons.arrow_turn_up_right,
                  size: iconSize,
                  paddingRight: 10.0,
                  onTap: () {
                    navigateToServiceOrProductDetail(
                        widget.objectType, widget.idProServicio!);
                  },
                )
              : const SizedBox.shrink()
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
    this.descripcion,
  });

  final int idUsuario;
  final String nombreUsuario;
  final String? urlFotoPerfil;
  final String? descripcion;

  @override
  Widget build(BuildContext context) {
    BorderRadius borderImageProfile = BorderRadius.circular(50.0);
    double sizeImageProfile = 53.0;
    //print("DESCRIPTION: $descripcion");

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(
              currentIndex: 1,
              idUsuario: idUsuario,
              ejecutarIdActual: false,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 7.0),
                child: Text(
                  nombreUsuario,
                  style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          descripcion != null && descripcion != ''
              ? Padding(
                  padding:
                      EdgeInsets.fromLTRB(sizeImageProfile / 2, 8.0, 0.0, 10.0),
                  child: Text(
                    descripcion ?? '',
                    style: const TextStyle(fontSize: 16.8),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: SizedBox.shrink(),
                )
        ],
      ),
    );
  }
}
