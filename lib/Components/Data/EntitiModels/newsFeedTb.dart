import 'package:etfi_point/Components/Data/EntitiModels/enlaces/enlaceProServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/publicacionImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';

class NewsFeedProductosTb extends NewsFeedItem {
  final int idEnlaceProducto;
  final int idProducto;
  final String? descripcion;
  final String fechaCreacion;
  final int likes;
  final UsuarioTb usuario;
  final List<EnlaceProServicioImagesTb> enlaceProductoImages;

  NewsFeedProductosTb({
    required this.idEnlaceProducto,
    required this.idProducto,
    this.descripcion,
    required this.fechaCreacion,
    required this.likes,
    required this.usuario,
    required this.enlaceProductoImages,
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
      likes: json['likes'],
      usuario: UsuarioTb.fromJson(json),
      enlaceProductoImages: enlaceProductoImagesList,
    );
  }

  @override
  DateTime getFechaCreacion() {
    return DateTime.parse(fechaCreacion);
  }
}

class NewsFeedServiciosTb extends NewsFeedItem {
  final int idEnlaceServicio;
  final int idServicio;
  final String? descripcion;
  final String fechaCreacion;
  final int likes;
  final UsuarioTb usuario;
  final List<EnlaceProServicioImagesTb> enlaceServicioImages;

  NewsFeedServiciosTb({
    required this.idEnlaceServicio,
    required this.idServicio,
    this.descripcion,
    required this.fechaCreacion,
    required this.likes,
    required this.usuario,
    required this.enlaceServicioImages,
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
      likes: json['likes'],
      usuario: UsuarioTb.fromJson(json),
      enlaceServicioImages: enlaceServicioImagesList,
    );
  }

  @override
  DateTime getFechaCreacion() {
    return DateTime.parse(fechaCreacion);
  }
}

class NeswFeedPublicacionesTb extends NewsFeedItem {
  final int idFotoPublicacion;
  final int idNegocio;
  final String? descripcion;
  final String fechaCreacion;
  final int likes;
  final List<PublicacionImagesTb> enlacePublicacionImages;

  NeswFeedPublicacionesTb({
    required this.idFotoPublicacion,
    required this.idNegocio,
    this.descripcion,
    required this.fechaCreacion,
    required this.likes,
    required this.enlacePublicacionImages,
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
      idFotoPublicacion: json['idFotoPublicacion'],
      idNegocio: json['idNegocio'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
      likes: json['likes'],
      enlacePublicacionImages: enlacePublicacionImagesList,
    );
  }

  @override
  DateTime getFechaCreacion() {
    return DateTime.parse(fechaCreacion);
  }
}

class NeswFeedReelProductTb extends NewsFeedItem {
  final int idProductEnlaceReel;
  final int idProducto;
  final String urlReel;
  final String? descripcion;
  final String fechaCreacion;
  final int likes;
  final UsuarioTb usuario;

  NeswFeedReelProductTb({
    required this.idProductEnlaceReel,
    required this.idProducto,
    required this.urlReel,
    this.descripcion,
    required this.fechaCreacion,
    required this.likes,
    required this.usuario,
  });

  factory NeswFeedReelProductTb.fromJsonReelProducto(
      Map<String, dynamic> json) {
    return NeswFeedReelProductTb(
      idProductEnlaceReel: json['idProductEnlaceReel'],
      idProducto: json['idProducto'],
      urlReel: json['urlReel'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
      likes: json['likes'],
      usuario: json['usuario'],
    );
  }

  @override
  DateTime getFechaCreacion() {
    return DateTime.parse(fechaCreacion);
  }
}

class NeswFeedReelServiceTb extends NewsFeedItem {
  final int idServiceEnlaceReel;
  final int idServicio;
  final String urlReel;
  final String? descripcion;
  final String fechaCreacion;
  final int likes;

  NeswFeedReelServiceTb({
    required this.idServiceEnlaceReel,
    required this.idServicio,
    required this.urlReel,
    this.descripcion,
    required this.fechaCreacion,
    required this.likes,
  });

  factory NeswFeedReelServiceTb.fromJsonReelServicio(
      Map<String, dynamic> json) {
    return NeswFeedReelServiceTb(
      idServiceEnlaceReel: json['idServiceEnlaceReel'],
      idServicio: json['idServicio'],
      urlReel: json['urlReel'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
      likes: json['likes'],
    );
  }

  @override
  DateTime getFechaCreacion() {
    return DateTime.parse(fechaCreacion);
  }
}

class NeswFeedOnlyReelTb extends NewsFeedItem {
  final int idReelPublicacion;
  final int idNegocio;
  final String urlReel;
  final String? descripcion;
  final String fechaCreacion;
  final int likes;

  NeswFeedOnlyReelTb({
    required this.idReelPublicacion,
    required this.idNegocio,
    required this.urlReel,
    this.descripcion,
    required this.fechaCreacion,
    required this.likes,
  });

  factory NeswFeedOnlyReelTb.fromJsonReel(Map<String, dynamic> json) {
    return NeswFeedOnlyReelTb(
      idReelPublicacion: json['idReelPublicacion'],
      idNegocio: json['idNegocio'],
      urlReel: json['urlReel'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
      likes: json['likes'],
    );
  }

  @override
  DateTime getFechaCreacion() {
    return DateTime.parse(fechaCreacion);
  }
}

class NewsFeedTb {
  final List<NewsFeedItem> newsFeed;

  NewsFeedTb(this.newsFeed);
}

abstract class NewsFeedItem {
  DateTime getFechaCreacion();
}
