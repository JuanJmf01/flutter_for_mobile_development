import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/proServiciosProvider.dart';
import 'package:etfi_point/Components/Utils/futureGridViewProfile.dart';
import 'package:etfi_point/Components/Utils/individualService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MisServicios extends StatefulWidget {
  const MisServicios({super.key, required this.idUsuario});

  final int idUsuario;

  @override
  State<MisServicios> createState() => _MisServiciosState();
}

class _MisServiciosState extends State<MisServicios> {
  Future<List<Object>> getServicios(int idUsuario,
      {int? idUsuarioActual}) async {
    if (idUsuarioActual != null) {
      List<ServicioTb> servicios = [];

      widget.idUsuario == idUsuarioActual
          ? servicios = await context
              .read<ProServiciosProvider>()
              .obtenerServiciosByNegocio(idUsuarioActual)
          : servicios =
              await ServicioDb.getServiciosByNegocio(widget.idUsuario);

      return servicios;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    int? idUsuarioActual = context.watch<UsuarioProvider>().idUsuarioActual;

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

