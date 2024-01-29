import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';

class RecoverFieldsUtiliti {
  static int? getIdUsuario(dynamic newItem) {
    if (newItem is NewsFeedProductosTb) {
      return newItem.usuario.idUsuario;
    } else if (newItem is NewsFeedServiciosTb) {
      return newItem.usuario.idUsuario;
    } else if (newItem is NeswFeedPublicacionesTb) {
      return newItem.usuario.idUsuario;
    } else if (newItem is NeswFeedReelServiceTb) {
      return newItem.usuario.idUsuario;
    } else if (newItem is NeswFeedReelProductTb) {
      return newItem.usuario.idUsuario;
    } else if (newItem is NeswFeedReelPublicacionTb) {
      return newItem.usuario.idUsuario;
    }
    return null;
  }

  static String? getNombreUsuario(dynamic newItem) {
    if (newItem is NewsFeedProductosTb) {
      return newItem.usuario.nombres;
    } else if (newItem is NewsFeedServiciosTb) {
      return newItem.usuario.nombres;
    } else if (newItem is NeswFeedPublicacionesTb) {
      return newItem.usuario.nombres;
    } else if (newItem is NeswFeedReelServiceTb) {
      return newItem.usuario.nombres;
    } else if (newItem is NeswFeedReelProductTb) {
      return newItem.usuario.nombres;
    } else if (newItem is NeswFeedReelPublicacionTb) {
      return newItem.usuario.nombres;
    }
    return null;
  }

  static String? getDescripcionPublicacion(dynamic newItem) {
    if (newItem is NewsFeedProductosTb) {
      return newItem.descripcion;
    } else if (newItem is NewsFeedServiciosTb) {
      return newItem.descripcion;
    } else if (newItem is NeswFeedPublicacionesTb) {
      return newItem.descripcion;
    } else if (newItem is NeswFeedReelServiceTb) {
      return newItem.descripcion;
    } else if (newItem is NeswFeedReelProductTb) {
      return newItem.descripcion;
    } else if (newItem is NeswFeedReelPublicacionTb) {
      return newItem.descripcion;
    }
    return null;
  }

  static int getLikePublicacion(dynamic newItem) {
    if (newItem is NewsFeedProductosTb) {
      return newItem.likes;
    } else if (newItem is NewsFeedServiciosTb) {
      return newItem.likes;
    } else if (newItem is NeswFeedPublicacionesTb) {
      return newItem.likes;
    } else if (newItem is NeswFeedReelServiceTb) {
      return newItem.likes;
    } else if (newItem is NeswFeedReelProductTb) {
      return newItem.likes;
    } else if (newItem is NeswFeedReelPublicacionTb) {
      return newItem.likes;
    }
    return 0;
  }

  static int? getIdProServicio(dynamic newItem) {
    if (newItem is NewsFeedProductosTb) {
      return newItem.idProducto;
    } else if (newItem is NewsFeedServiciosTb) {
      return newItem.idServicio;
    } else if (newItem is NeswFeedReelServiceTb) {
      return newItem.idServicio;
    } else if (newItem is NeswFeedReelProductTb) {
      return newItem.idProducto;
    }
    return null;
  }

  static int? getIdPublicacion(dynamic newItem) {
    if (newItem is NewsFeedProductosTb) {
      return newItem.idEnlaceProducto;
    } else if (newItem is NewsFeedServiciosTb) {
      return newItem.idEnlaceServicio;
    } else if (newItem is NeswFeedPublicacionesTb) {
      return newItem.idFotoPublicacion;
    } else if (newItem is NeswFeedReelPublicacionTb) {
      return newItem.idReelPublicacion;
    } else if (newItem is NeswFeedReelServiceTb) {
      return newItem.idServiceEnlaceReel;
    } else if (newItem is NeswFeedReelProductTb) {
      return newItem.idProductEnlaceReel;
    }
    return null;
  }

  static List<dynamic> getImagesPublicacion(dynamic newItem) {
    if (newItem is NewsFeedProductosTb) {
      return newItem.enlaceProductoImages;
    } else if (newItem is NewsFeedServiciosTb) {
      return newItem.enlaceServicioImages;
    } else if (newItem is NeswFeedPublicacionesTb) {
      return newItem.enlacePublicacionImages;
    }
    return [];
  }

  static String? getReelPublicacion(dynamic newItem) {
    if (newItem is NeswFeedReelServiceTb) {
      return newItem.urlReel;
    } else if (newItem is NeswFeedReelProductTb) {
      return newItem.urlReel;
    } else if (newItem is NeswFeedReelPublicacionTb) {
      return newItem.urlReel;
    }
    return null;
  }
}
