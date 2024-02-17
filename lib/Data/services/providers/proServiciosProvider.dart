import 'package:etfi_point/Data/models/productoTb.dart';
import 'package:etfi_point/Data/models/servicioTb.dart';
import 'package:etfi_point/Data/services/api/productosDb.dart';
import 'package:etfi_point/Data/services/api/servicioDb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productosByNegocioProvider = FutureProvider.family<List<ProductoTb>, int>(
  (ref, idUsuario) async {
    final productos = await ProductoDb.getProductosByNegocio(idUsuario);
    return productos;
  },
);

final serviciosByNegocioProvider = FutureProvider.family<List<ServicioTb>, int>(
  (ref, idUsuario) async {
    return ServicioDb.getServiciosByNegocio(idUsuario);
  },
);
