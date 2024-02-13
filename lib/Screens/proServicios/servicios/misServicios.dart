import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
import 'package:etfi_point/Components/Utils/futureGridViewProfile.dart';
import 'package:etfi_point/Components/Utils/individualService.dart';
import 'package:etfi_point/Components/providers/proServiciosProvider.dart';
import 'package:etfi_point/Components/providers/userStateProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MisServicios extends ConsumerStatefulWidget {
  const MisServicios({super.key, required this.idUsuario});

  final int idUsuario;

  @override
  MisServiciosState createState() => MisServiciosState();
}

class MisServiciosState extends ConsumerState<MisServicios> {
  Future<List<Object>> getServicios(int idUsuario,
      {int? idUsuarioActual}) async {
    if (idUsuarioActual != null) {
      final List<Object> servicios;

      if (widget.idUsuario == idUsuarioActual) {
        final serviciosFuture =
            ref.read(serviciosByNegocioProvider(idUsuario).future);
        servicios = await serviciosFuture;

        //ref.read(isInitServiciosProvider.notifier).update((state) => true);
      } else {
        servicios = await ServicioDb.getServiciosByNegocio(widget.idUsuario);
      }

      return servicios;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    //int? idUsuarioActual = context.watch<UsuarioProvider>().idUsuarioActual;
    final int? idUsuarioActual = ref.watch(getCurrentUserProvider).value;

    return FutureGridViewProfile(
      idUsuario: widget.idUsuario,
      future: () =>
          getServicios(widget.idUsuario, idUsuarioActual: idUsuarioActual),
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
