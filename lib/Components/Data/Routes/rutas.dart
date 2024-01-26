class MisRutas {
  static String rutaPrincipal = 'http://192.168.68.106:3000/api';

  // -- Demas rutas -- //
  static String rutaCategorias2 = '$rutaPrincipal/categorias';

  // -- Rutas para la tabla usuarios -- //

  static String rutaUsuarios = '$rutaPrincipal/usuarios';
  static String rutaUsuariosProfile = '$rutaPrincipal/usuarioProfile';

  // -- Rutas para la tabla negocios -- //
  static String rutaNegocios = '$rutaPrincipal/negocios';
  static String rutaCheckBusinessExists = '$rutaPrincipal/ifExistBusiness';

  // -- Rutas para la tabla ratings -- //
  static String rutaRatings = '$rutaPrincipal/rating';
  static String rutaRatingsByProductoAndUser =
      '$rutaPrincipal/ratingByProductoAndUsuario';
  static String rutaRatingsByProducto = '$rutaPrincipal/ratingByProducto';
  static String rutaRatingsCountByProducto =
      '$rutaPrincipal/ratingCountByProducto';
  static String rutaRatingsIfExistRating = '$rutaPrincipal/checkRatingExists';

  // -- Rutas para la tabla serviceRatings -- //
  static String rutaServiceRatings = '$rutaPrincipal/serviceRating';
  static String rutaRatingsByServiceAndUser =
      '$rutaPrincipal/ratingByServiceAndUser';
  static String rutaServiceRatingsIfExistRating =
      '$rutaPrincipal/checkServiceRatingExists';
  static String rutaRatingsByServicio = '$rutaPrincipal/ratingByServicio';
  static String rutaServerRatingsCountByServicio =
      '$rutaPrincipal/ratingCountByServicio';

  // -- Rutas para la tabla productos -- //
  static String rutaProductos = '$rutaPrincipal/producto';
  static String rutaProductosByNegocio = '$rutaPrincipal/productoByNegocio';
  static String rutaDescripcionDetallada =
      '$rutaPrincipal/producto/descripcionDetallada';
  static String rutaIsShoppingCartProduct =
      '$rutaPrincipal/producto/shoppingCart';

  // -- Rutas para la tabla productImages -- //
  static String rutaProductImages = '$rutaPrincipal/productImages';
  static String rutaProductImage = '$rutaPrincipal/productImage';

  // -- Rutas para la tabla serviciosImagenes -- //
  static String rutaServiceImages = '$rutaPrincipal/serviceImages';
  static String rutaServiceImage = '$rutaPrincipal/serviceImage';

  // -- Rutas para la tabla shoppingCart -- //
  static String rutaShoppingCart = '$rutaPrincipal/shoppingCart';

  // -- Rutas para la tabla subCategorias -- //
  static String rutaSubCategorias = '$rutaPrincipal/subCategorias';
  static String rutaSubCategoriasByCategoria =
      '$rutaPrincipal/subCategoriasByCategoria';

  // -- Rutas para la tabla productosSubCategorias -- //
  static String rutaProductosSubCategorias =
      '$rutaPrincipal/productosSubCategorias';

  // -- Rutas para la tabla servicios -- //
  static String rutaServicios = '$rutaPrincipal/servicio';
  static String rutaServiciosByNegocio = '$rutaPrincipal/servicioByNegocio';
  static String rutaServicio = '$rutaPrincipal/servicio';

  // -- Rutas para la tabla categoriasServicios -- //
  static String rutaCategoriasServicios = '$rutaPrincipal/categoriasServicios';

  // -- Rutas para la tabla serviciosSubCategorias -- //
  static String rutaServiciosSubCategorias =
      '$rutaPrincipal/serviciosSubCategorias';

  // -- Rutas para la tabla serviciosSubCategorias -- //
  // Esta tabla contiene los nombres de las sub-categorias de servicios
  static String rutaSubCategoriaServicios =
      '$rutaPrincipal/subCategoriasServicios';

  // -- Rutas para la tabla enlaceProductos -- //
  static String rutaEnlaceProductos = '$rutaPrincipal/enlaceProducto';

  static String rutaEnlaceProductosByEnlaceProducto =
      '$rutaPrincipal/enlaceProductoByIdEnlaceProducto';

  static String rutaEnlaceProductosSeguidos =
      '$rutaPrincipal/enlaceProductoBySeguidor';

  // -- Rutas para la tabla enlaceServicios -- //
  static String rutaEnlaceServicios = '$rutaPrincipal/enlaceServicio';

  static String rutaEnlaceServicioByEnlaceServicio =
      '$rutaPrincipal/enlaceServicioByIdEnlaceServicio';

  static String rutaEnlaceServiciosSeguidos =
      '$rutaPrincipal/enlaceServicioBySeguidor';

  // -- Rutas para la tabla enlaceProductoImages -- //
  static String rutaEnlaceProductosImage =
      '$rutaPrincipal/enlaceProductoImages';

  // -- Rutas para la tabla enlaceServiciosImages -- //
  static String rutaEnlaceServiciosImage =
      '$rutaPrincipal/enlaceServicioImages';

  // -- Rutas para la tabla publicaciones -- //
  static String rutaPublicaciones = '$rutaPrincipal/publicaciones';
  static String rutaPublicacionesByIdPublicacion =
      '$rutaPrincipal/publicacionesByIdPublicacion';
  static String rutaPublicacionesBySeguidor =
      '$rutaPrincipal/publicacionesBySeguidor';

  // -- Rutas para la tabla publicacionImages -- //
  static String rutaPublicacionImages = '$rutaPrincipal/publicacionImages';

  // -- Rutas para la tabla reelsPublicacion -- //
  static String rutaOnlyReels = '$rutaPrincipal/onlyReel';
  static String rutaReelByIdReelPublicacion =
      '$rutaPrincipal/onlyReelByIdOnlyReel';
  static String rutaIdsReelsBySeguidor = '$rutaPrincipal/reelsBySeguidor';

  // -- Rutas para la tabla serviceEnlaceReels -- //
  static String rutaServiceEnlaceReels = '$rutaPrincipal/serviceEnlaceReels';

  static String rutaServiceEnlaceReelById =
      '$rutaPrincipal/serviceEnlaceReelsByIdServiceEnlaceReel';

  static String rutaServiceEnlaceReelSeguidos =
      '$rutaPrincipal/serviceEnlaceReelBySeguidor';

  // -- Rutas para la tabla productEnlaceReels -- //
  static String rutaProductEnlaceReels = '$rutaPrincipal/productEnlaceReels';

  static String rutaProductEnlaceReelById =
      '$rutaPrincipal/productEnlaceReelsByIdProductEnlaceReel';

  static String rutaProductEnlaceReelSeguidos =
      '$rutaPrincipal/producEnlaceReelBySeguidor';

  // -- Rutas para la tabla ratingsEnlaceProducto -- //
  static String rutaRatingsEnlaceProducto =
      '$rutaPrincipal/ratingEnlaceProducto';

  static String rutaCheckRatingEnlaceProductoIfExist =
      '$rutaPrincipal/checkRatingEnlaceProductoIfExist';

  static String rutaUpdateLikeEnlaceProducto =
      '$rutaPrincipal/enlaceProductoLike';

  // -- Rutas para la tabla ratingsEnlaceServicio -- //
  static String rutaRatingsEnlaceServicio =
      '$rutaPrincipal/ratingEnlaceServicio';

  static String rutaCheckRatingEnlaceServicioIfExist =
      '$rutaPrincipal/checkRatingEnlaceServicioIfExist';

  static String rutaUpdateLikeEnlaceServicio =
      '$rutaPrincipal/enlaceServicioLike';

  // -- Rutas para la tabla ratingsProductEnlaceReel -- //
  static String rutaRatingsEnlaceVidProducto =
      '$rutaPrincipal/ratingEnlaceVidProducto';

  static String rutaCheckRatingEnlaceVidProductIfExist =
      '$rutaPrincipal/checkRatingEnlaceVidProductoIfExist';

  static String rutaUpdateLikeEnlaceProductReel =
      '$rutaPrincipal/enlaceProductReelLike';

  // -- Rutas para la tabla ratingsServiceEnlaceReel -- //
  static String rutaRatingsEnlaceVidServicio =
      '$rutaPrincipal/ratingEnlaceVidServicio';

  static String rutaCheckRatingEnlaceVidServiceIfExist =
      '$rutaPrincipal/checkRatingEnlaceVidServicioIfExist';

  static String rutaUpdateLikeEnlaceServiceReel =
      '$rutaPrincipal/enlaceServiceReelLike';

  // -- Rutas para la tabla ratingsFotosPublicacion -- //

  static String rutaRatingsFotoPublicacion =
      '$rutaPrincipal/ratingFotoPublicacion';

  static String rutaCheckRatingFotoPublicacionIfExist =
      '$rutaPrincipal/checkRatingFotoPublicacionIfExist';

  static String rutaUpdateLikeFotoPublicacion =
      '$rutaPrincipal/enlaceFotoPublicacionLike';

  // -- Rutas para la tabla ratingsReelsPublicacion -- //

  static String rutaRatingsReelPublicacion =
      '$rutaPrincipal/ratingReelPublicacion';

  static String rutaCheckRatingReelPublicacionIfExist =
      '$rutaPrincipal/checkRatingReelPublicacionIfExist';

  static String rutaUpdateLikeReelPublicacion =
      '$rutaPrincipal/enlaceReelPublicacionLike';

  // -- Rutas para la tabla seguidores -- //

  static String rutaSeguidores = '$rutaPrincipal/seguidores';
}
