import 'package:etfi_point/Components/Data/EntitiModels/enlaces/enlaceProServicioImagesTb.dart';

class NeswFeedProductosTb extends NewsFeedItem {
  final int idEnlaceProducto;
  final int idProducto;
  final String descripcion;
  final String fechaCreacion;
  final List<EnlaceProServicioImagesTb> enlaceProductoImages;
  //final List<RatingsEnlaceProductoTb> ratingsEnlaceProducto;

  NeswFeedProductosTb({
    required this.idEnlaceProducto,
    required this.idProducto,
    required this.descripcion,
    required this.fechaCreacion,
    required this.enlaceProductoImages,
    //required this.ratingsEnlaceProducto,
  });

  factory NeswFeedProductosTb.fromJson(Map<String, dynamic> json) {
    List<EnlaceProServicioImagesTb> enlaceProductoImagesList = [];
    if (json['enlaceProductoImages'] != null) {
      var enlaceProductoImagesJson = json['enlaceProductoImages'] as List;
      enlaceProductoImagesList = enlaceProductoImagesJson
          .map((enlaceProductoImage) =>
              EnlaceProServicioImagesTb.fromJsonEnlaceProducto(enlaceProductoImage))
          .toList();
    }

    return NeswFeedProductosTb(
      idEnlaceProducto: json['idEnlaceProducto'],
      idProducto: json['idProducto'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
      enlaceProductoImages: enlaceProductoImagesList,
    );
  }
}


// class RatingsEnlaceProductoTb {
//   final int idUsuario;
//   final String idEnlaceProducto;
//   final String comentario;
//   final int likes;

//   RatingsEnlaceProductoTb({
//     required this.idUsuario,
//     required this.idEnlaceProducto,
//     required this.comentario,
//     required this.likes,
//   });
// }

class NeswFeedServiciosTb extends NewsFeedItem {
  final int idEnlaceServicio;
  final int idServicio;
  final String descripcion;
  final List<EnlaceProServicioImagesTb> enlaceServicioImages;
  //final List<RatingsEnlaceServicioTb> ratingsEnlaceServicio;

  NeswFeedServiciosTb({
    required this.idEnlaceServicio,
    required this.idServicio,
    required this.descripcion,
    required this.enlaceServicioImages,
    //required this.ratingsEnlaceServicio,
  });

  factory NeswFeedServiciosTb.fromJson(Map<String, dynamic> json) {
    List<EnlaceProServicioImagesTb> enlaceServicioImagesList = [];
    if (json['enlaceServicioImages'] != null) {
      var enlaceServicioImagesJson = json['enlaceServicioImages'] as List;
      enlaceServicioImagesList = enlaceServicioImagesJson
          .map((enlaceServicioImage) =>
              EnlaceProServicioImagesTb.fromJsonEnlaceServicio(enlaceServicioImage))
          .toList();
    }

    return NeswFeedServiciosTb(
      idEnlaceServicio: json['idEnlaceServicio'],
      idServicio: json['idServicio'],
      descripcion: json['descripcion'],
      enlaceServicioImages: enlaceServicioImagesList,
    );
  }
}


// class RatingsEnlaceServicioTb {
//   final int idUsuario;
//   final String idEnlaceServicio;
//   final String comentario;
//   final int likes;

//   RatingsEnlaceServicioTb({
//     required this.idUsuario,
//     required this.idEnlaceServicio,
//     required this.comentario,
//     required this.likes,
//   });
// }

class NeswFeedPublicacionesTb extends NewsFeedItem {
  final int idPublicacion;
  final int idNegocio;
  final String descripcion;
  final List<EnlacePublicacionImagesTb> enlacePublicacionImages;
  //final List<RatingsEnlacePublicacionTb> ratingsEnlacePublicacion;

  NeswFeedPublicacionesTb({
    required this.idPublicacion,
    required this.idNegocio,
    required this.descripcion,
    required this.enlacePublicacionImages,
    //required this.ratingsEnlacePublicacion,
  });

  factory NeswFeedPublicacionesTb.fromJson(Map<String, dynamic> json) {
    List<EnlacePublicacionImagesTb> enlacePublicacionImagesList = [];
    if (json['enlacePublicacionImages'] != null) {
      var enlacepublicacionImagesJson = json['enlacePublicacionImages'] as List;
      enlacePublicacionImagesList = enlacepublicacionImagesJson
          .map((enlacePublicacionImage) =>
              EnlacePublicacionImagesTb.fromJson(enlacePublicacionImage))
          .toList();
    }

    return NeswFeedPublicacionesTb(
      idPublicacion: json['idEnlaceServicio'],
      idNegocio: json['idServicio'],
      descripcion: json['descripcion'],
      enlacePublicacionImages: enlacePublicacionImagesList,
    );
  }
}

class EnlacePublicacionImagesTb {
  final int idPublicacion;
  final String nombreImage;
  final String urlImage;

  EnlacePublicacionImagesTb({
    required this.idPublicacion,
    required this.nombreImage,
    required this.urlImage,
  });

  factory EnlacePublicacionImagesTb.fromJson(Map<String, dynamic> json) {
    return EnlacePublicacionImagesTb(
      idPublicacion: json['idEnlaceServicio'],
      nombreImage: json['nombreImage'],
      urlImage: json['urlImage'],
    );
  }
}

// class RatingsEnlacePublicacionTb {
//   final int idUsuario;
//   final String idPublicacion;
//   final String comentario;
//   final int likes;

//   RatingsEnlacePublicacionTb({
//     required this.idUsuario,
//     required this.idPublicacion,
//     required this.comentario,
//     required this.likes,
//   });
// }

class NewsFeedTb {
  final List<NewsFeedItem> newsFeed;

  NewsFeedTb(this.newsFeed);
}

abstract class NewsFeedItem {}
