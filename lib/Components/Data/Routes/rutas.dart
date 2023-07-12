class MisRutas {
  static String rutaPrincipal = 'http://192.168.68.102:3000/api';

  // -- Demas rutas -- //
  static String rutaCategorias = '$rutaPrincipal/categorias';
  static String rutaProductosCategorias = '$rutaPrincipal/productosCategorias';
  static String rutaUsuarios = '$rutaPrincipal/usuarios';
  static String rutaNegocios = '$rutaPrincipal/negocios';

  // -- Rutas para la tabla ratings -- //
  static String rutaRatings = '$rutaPrincipal/rating';
  static String rutaRatingsByProductoAndUser =
      '$rutaPrincipal/ratingByProductoAndUsuario';
  static String rutaRatingsByProducto = '$rutaPrincipal/ratingByProducto';
  static String rutaRatingsCountByProducto =
      '$rutaPrincipal/ratingCountByProducto';

  // -- Rutas para la tabla productos -- //
  static String rutaProductos = '$rutaPrincipal/producto';
  static String rutaProductosByNegocio = '$rutaPrincipal/productoByNegocio';

  // -- Rutas para la tabla productos -- //
  static String rutaProductImages = '$rutaPrincipal/productImages';
  static String rutaProductImage = '$rutaPrincipal/productImage';


}
