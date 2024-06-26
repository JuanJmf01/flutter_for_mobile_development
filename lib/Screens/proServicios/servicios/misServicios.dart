import 'package:etfi_point/Data/services/api/servicioDb.dart';
import 'package:etfi_point/Data/models/servicioTb.dart';
import 'package:etfi_point/components/widgets/futureGridViewProfile.dart';
import 'package:etfi_point/components/widgets/individualService.dart';
import 'package:etfi_point/Data/services/providers/proServiciosProvider.dart';
import 'package:etfi_point/Data/services/providers/userStateProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MisServicios extends ConsumerWidget {
  const MisServicios({super.key, required this.idUsuario});

  final int idUsuario;

  Future<List<Object>> getServicios(int idUsuario, WidgetRef ref,
      {int? idUsuarioActual}) async {
    if (idUsuarioActual != null) {
      final List<Object> servicios;

      if (idUsuario == idUsuarioActual) {
        final serviciosFuture =
            ref.read(serviciosByNegocioProvider(idUsuario).future);
        servicios = await serviciosFuture;
      } else {
        servicios = await ServicioDb.getServiciosByNegocio(idUsuario);
      }

      return servicios;
    }
    return [];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //int? idUsuarioActual = context.watch<UsuarioProvider>().idUsuarioActual;
    final int? idUsuarioActual = ref.watch(getCurrentUserProvider).value;
    print("Si es");

    return FutureGridViewProfile(
      idUsuario: idUsuario,
      future: () =>
          getServicios(idUsuario, ref, idUsuarioActual: idUsuarioActual),
      bodyItemBuilder: (int index, Object item) => IndividulService(
        servicio: item as ServicioTb,
        index: index,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 15.0,
        mainAxisExtent: 150,
      ),
    );
  }
}
