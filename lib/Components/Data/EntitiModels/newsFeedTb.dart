import 'package:etfi_point/Components/Data/EntitiModels/enlaces/enlaceProServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/publicacionImagesTb.dart';

class NewsFeedProductosTb extends NewsFeedItem {
  final int idEnlaceProducto;
  final int idProducto;
  final String? descripcion;
  final String fechaCreacion;
  final List<EnlaceProServicioImagesTb> enlaceProductoImages;

  NewsFeedProductosTb({
    required this.idEnlaceProducto,
    required this.idProducto,
    this.descripcion,
    required this.fechaCreacion,
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
  final List<EnlaceProServicioImagesTb> enlaceServicioImages;

  NewsFeedServiciosTb({
    required this.idEnlaceServicio,
    required this.idServicio,
    this.descripcion,
    required this.fechaCreacion,
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
      enlaceServicioImages: enlaceServicioImagesList,
    );
  }

  @override
  DateTime getFechaCreacion() {
    return DateTime.parse(fechaCreacion);
  }
}

class NeswFeedPublicacionesTb extends NewsFeedItem {
  final int idPublicacion;
  final int idNegocio;
  final String? descripcion;
  final String fechaCreacion;
  final List<PublicacionImagesTb> enlacePublicacionImages;

  NeswFeedPublicacionesTb({
    required this.idPublicacion,
    required this.idNegocio,
    this.descripcion,
    required this.fechaCreacion,
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
      idPublicacion: json['idPublicacion'],
      idNegocio: json['idNegocio'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
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

  NeswFeedReelProductTb({
    required this.idProductEnlaceReel,
    required this.idProducto,
    required this.urlReel,
    this.descripcion,
    required this.fechaCreacion,
  });

  factory NeswFeedReelProductTb.fromJsonReelProducto(
      Map<String, dynamic> json) {
    return NeswFeedReelProductTb(
      idProductEnlaceReel: json['idProductEnlaceReel'],
      idProducto: json['idProducto'],
      urlReel: json['urlReel'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
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

  NeswFeedReelServiceTb({
    required this.idServiceEnlaceReel,
    required this.idServicio,
    required this.urlReel,
    this.descripcion,
    required this.fechaCreacion,
  });

  factory NeswFeedReelServiceTb.fromJsonReelServicio(
      Map<String, dynamic> json) {
    return NeswFeedReelServiceTb(
      idServiceEnlaceReel: json['idServiceEnlaceReel'],
      idServicio: json['idServicio'],
      urlReel: json['urlReel'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
    );
  }

  @override
  DateTime getFechaCreacion() {
    return DateTime.parse(fechaCreacion);
  }
}

class NeswFeedOnlyReelTb extends NewsFeedItem {
  final int idReel;
  final int idNegocio;
  final String urlReel;
  final String? descripcion;
  final String fechaCreacion;

  NeswFeedOnlyReelTb({
    required this.idReel,
    required this.idNegocio,
    required this.urlReel,
    this.descripcion,
    required this.fechaCreacion,
  });

  factory NeswFeedOnlyReelTb.fromJsonReel(Map<String, dynamic> json) {
    return NeswFeedOnlyReelTb(
      idReel: json['idReel'],
      idNegocio: json['idNegocio'],
      urlReel: json['urlReel'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
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
