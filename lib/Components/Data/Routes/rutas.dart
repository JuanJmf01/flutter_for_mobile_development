class MisRutas {
  static String rutaPrincipal = 'http://192.168.68.100:3000/api';

  // -- Demas rutas -- //
  static String rutaCategorias = '$rutaPrincipal/categorias';
  static String rutaProductosCategorias = '$rutaPrincipal/productosCategorias';
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

  // -- Rutas para la tabla productos -- //
  static String rutaProductos = '$rutaPrincipal/producto';
  static String rutaProductosByNegocio = '$rutaPrincipal/productoByNegocio';
  static String rutaDescripcionDetallada =
      '$rutaPrincipal/producto/descripcionDetallada';
  static String rutaIsShoppingCartProduct =
      '$rutaPrincipal/producto/shoppingCart';

  // -- Rutas para la tabla productos -- //
  static String rutaProductImages = '$rutaPrincipal/productImages';
  static String rutaProductImage = '$rutaPrincipal/productImage';

  // -- Rutas para la tabla shoppingCart -- //
  static String rutaShoppingCart = '$rutaPrincipal/shoppingCart';

  // -- Rutas para la tabla subCategorias -- //
  static String rutaSubCategorias = '$rutaPrincipal/subCategorias';

  // -- Rutas para la tabla productosSubCategorias -- //
  static String rutaProductosSubCategorias =
      '$rutaPrincipal/productosSubCategorias';
}
