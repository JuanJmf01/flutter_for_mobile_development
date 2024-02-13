import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productosByNegocioProvider = FutureProvider.family<List<ProductoTb>, int>(
  (ref, idUsuario) async {
    return await ProductoDb.getProductosByNegocio(idUsuario);
  },
);

final serviciosByNegocioProvider = FutureProvider.family<List<ServicioTb>, int>(
  (ref, idUsuario) async {
    return ServicioDb.getServiciosByNegocio(idUsuario);
  },
);


// final isInitProductosProvider = StateProvider<bool>((ref) => false);
// final isInitServiciosProvider = StateProvider<bool>((ref) => false);