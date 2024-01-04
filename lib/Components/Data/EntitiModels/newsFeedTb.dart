import 'package:etfi_point/Components/Data/EntitiModels/enlaces/enlaceProServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/publicacionImagesTb.dart';

class NewsFeedProductosTb extends NewsFeedItem {
  final int idEnlaceProducto;
  final int idProducto;
  final String? descripcion;
  final String fechaCreacion;
  final List<EnlaceProServicioImagesTb> enlaceProductoImages;
  //final List<RatingsEnlaceProductoTb> ratingsEnlaceProducto;

  NewsFeedProductosTb({
    required this.idEnlaceProducto,
    required this.idProducto,
    this.descripcion,
    required this.fechaCreacion,
    required this.enlaceProductoImages,
    //required this.ratingsEnlaceProducto,
  });

  factory NewsFeedProductosTb.fromJson(Map<String, dynamic> json) {
    List<EnlaceProServicioImagesTb> enlaceProductoImagesList = [];
    if (json['enlaceProductoImages'] != null) {
      var enlaceProductoImagesJson = json['enlaceProductoImages'] as List;
      enlaceProductoImagesList = enlaceProductoImagesJson
          .map((enlaceProductoImage) =>
              EnlaceProServicioImagesTb.fromJsonEnlaceProducto(
                  enlaceProductoImage))
          .toList();
    }

    return NewsFeedProductosTb(
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

class NewsFeedServiciosTb extends NewsFeedItem {
  final int idEnlaceServicio;
  final int idServicio;
  final String? descripcion;
  final String fechaCreacion;
  final List<EnlaceProServicioImagesTb> enlaceServicioImages;
  //final List<RatingsEnlaceServicioTb> ratingsEnlaceServicio;

  NewsFeedServiciosTb({
    required this.idEnlaceServicio,
    required this.idServicio,
    this.descripcion,
    required this.fechaCreacion,
    required this.enlaceServicioImages,
    //required this.ratingsEnlaceServicio,
  });

  factory NewsFeedServiciosTb.fromJson(Map<String, dynamic> json) {
    List<EnlaceProServicioImagesTb> enlaceServicioImagesList = [];
    if (json['enlaceServicioImages'] != null) {
      var enlaceServicioImagesJson = json['enlaceServicioImages'] as List;
      enlaceServicioImagesList = enlaceServicioImagesJson
          .map((enlaceServicioImage) =>
              EnlaceProServicioImagesTb.fromJsonEnlaceServicio(
                  enlaceServicioImage))
          .toList();
    }

    return NewsFeedServiciosTb(
      idEnlaceServicio: json['idEnlaceServicio'],
      idServicio: json['idServicio'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
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
  final String? descripcion;
  final String fechaCreacion;
  final List<PublicacionImagesTb> enlacePublicacionImages;
  //final List<RatingsEnlacePublicacionTb> ratingsEnlacePublicacion;

  NeswFeedPublicacionesTb({
    required this.idPublicacion,
    required this.idNegocio,
    this.descripcion,
    required this.fechaCreacion,
    required this.enlacePublicacionImages,
    //required this.ratingsEnlacePublicacion,
  });

  factory NeswFeedPublicacionesTb.fromJson(Map<String, dynamic> json) {
    List<PublicacionImagesTb> enlacePublicacionImagesList = [];
    if (json['publicacionImages'] != null) {
      var enlacepublicacionImagesJson = json['publicacionImages'] as List;
      enlacePublicacionImagesList = enlacepublicacionImagesJson
          .map((enlacePublicacionImage) =>
              PublicacionImagesTb.fromJson(enlacePublicacionImage))
          .toList();
    }

    return NeswFeedPublicacionesTb(
      idPublicacion: json['idPublicacion'],
      idNegocio: json['idNegocio'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
      enlacePublicacionImages: enlacePublicacionImagesList,
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

class NeswFeedReelProductTb extends NewsFeedItem {
  final int idProducto;
  final String urlReel;
  final String? descripcion;
  final String fechaCreacion;

  NeswFeedReelProductTb({
    required this.idProducto,
    required this.urlReel,
    this.descripcion,
    required this.fechaCreacion,
  });

  factory NeswFeedReelProductTb.fromJsonReelProducto(
      Map<String, dynamic> json) {
    return NeswFeedReelProductTb(
      idProducto: json['idProducto'],
      urlReel: json['urlReel'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
    );
  }
}

class NeswFeedReelServiceTb extends NewsFeedItem {
  final int idServicio;
  final String urlReel;
  final String? descripcion;
  final String fechaCreacion;

  NeswFeedReelServiceTb({
    required this.idServicio,
    required this.urlReel,
    this.descripcion,
    required this.fechaCreacion,
  });

  factory NeswFeedReelServiceTb.fromJsonReelServicio(
      Map<String, dynamic> json) {
    return NeswFeedReelServiceTb(
      idServicio: json['idServicio'],
      urlReel: json['urlReel'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
    );
  }
}

class NeswFeedOnlyReelTb extends NewsFeedItem {
  final int idNegocio;
  final String urlReel;
  final String? descripcion;
  final String fechaCreacion;

  NeswFeedOnlyReelTb({
    required this.idNegocio,
    required this.urlReel,
    this.descripcion,
    required this.fechaCreacion,
  });

  factory NeswFeedOnlyReelTb.fromJsonReel(Map<String, dynamic> json) {
    return NeswFeedOnlyReelTb(
      idNegocio: json['idNegocio'],
      urlReel: json['urlReel'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
    );
  }
}

class NewsFeedTb {
  final List<NewsFeedItem> newsFeed;

  NewsFeedTb(this.newsFeed);
}

abstract class NewsFeedItem {}
