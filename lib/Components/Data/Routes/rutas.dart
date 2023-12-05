class MisRutas {
  static String rutaPrincipal = 'http://192.168.68.106:3000/api';

  // -- Demas rutas -- //
  static String rutaCategorias2 = '$rutaPrincipal/categorias';

  static String rutaUsuarios = '$rutaPrincipal/usuarios';

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

  // -- Rutas para la tabla enlaceServicios -- //
  static String rutaEnlaceServicios = '$rutaPrincipal/enlaceServicio';

  // -- Rutas para la tabla enlaceProductoImages -- //
  static String rutaEnlaceProductosImage =
      '$rutaPrincipal/enlaceProductoImages';

  // -- Rutas para la tabla enlaceServiciosImages -- //
  static String rutaEnlaceServiciosImage =
      '$rutaPrincipal/enlaceServicioImages';
}
