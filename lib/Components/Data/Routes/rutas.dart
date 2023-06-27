class MisRutas {
  static String rutaPrincipal = 'http://192.168.68.101:3000/api';

  static String rutaCategorias = '$rutaPrincipal/categorias';
  static String rutaProductosCategorias = '$rutaPrincipal/productosCategorias';
  static String rutaUsuarios = '$rutaPrincipal/usuarios';
  static String rutaNegocios = '$rutaPrincipal/negocios';

  // -- rutaProductos y rutaProductosByNegocio de la clase productos.routes -- //
  static String rutaProductos = '$rutaPrincipal/producto';
  static String rutaProductosByNegocio = '$rutaPrincipal/productoByNegocio';
}
