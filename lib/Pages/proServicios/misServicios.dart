import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/proServiciosProvider.dart';
import 'package:etfi_point/Components/Utils/futureGridViewProfile.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/proServicios/proServicioDetail.dart';
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

class IndividulService extends StatefulWidget {
  const IndividulService(
      {super.key, required this.servicio, required this.index});

  final ServicioTb servicio;
  final int index;

  @override
  State<IndividulService> createState() => _IndividulServiceState();
}

class _IndividulServiceState extends State<IndividulService> {
  Future<void> _navigateToServiceDetail(int idService) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProServicioDetail(proServicio: widget.servicio, nameContexto: "servicio",),
      ),
    );
  }

  String priceWithDesc(double price, int descuento) {
    double newPrice;

    newPrice = price - (price * (descuento / 100.0));

    return newPrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    ServicioTb servicio = widget.servicio;
    int index = widget.index;
    double borderCircular = 18.0;

    return Container(
        padding: EdgeInsets.all(0.0),
        //height: 140,
        //width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderCircular),
          color: Colors.white,
        ),
        child: index % 2 == 0
            ? Row(
                children: [
                  createImage(servicio, borderCircular),
                  createBodyServicio(servicio),
                  servicio.oferta == 1
                      ? createContainerOferta(index, borderCircular)
                      : SizedBox.shrink()
                ],
              )
            : Row(
                children: [
                  servicio.oferta == 1
                      ? createContainerOferta(index, borderCircular)
                      : SizedBox.shrink(),
                  createBodyServicio(servicio),
                  createImage(servicio, borderCircular)
                ],
              ));
  }

  Widget createImage(ServicioTb servicio, double borderCircular) {
    return InkWell(
      onTap: () {
        _navigateToServiceDetail(servicio.idServicio);
      },
      child: ShowImage(
        height: double.infinity,
        width: 180,
        fit: BoxFit.cover,
        // borderRadius: const BorderRadius.only(
        //     topRight: Radius.circular(20),
        //     bottomRight: Radius.circular(20.0)),
        borderRadius: BorderRadius.circular(borderCircular),
        networkImage: servicio.urlImage,
      ),
    );
  }

  Widget createBodyServicio(ServicioTb servicio) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 0.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "\$${servicio.precio}",
              style: Theme.of(context).textTheme.titleSmall!.merge(
                    const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.5,
                    ),
                  ),
            ),
            servicio.oferta == 1 && servicio.descuento != null
                ? Text(
                    "\$${priceWithDesc(servicio.precio, servicio.descuento!)}",
                    style: Theme.of(context).textTheme.titleSmall!.merge(
                          TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade500,
                              fontSize: 17),
                        ),
                  )
                : SizedBox.shrink(),
            Spacer(),
            Text(
              servicio.nombre,
              style: Theme.of(context).textTheme.titleMedium!.merge(
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createContainerOferta(int index, double borderCircular) {
    final bool isEven = index % 2 == 0;
    final BorderRadius borderRadius = isEven
        ? BorderRadius.only(
            topRight: Radius.circular(borderCircular),
            bottomRight: Radius.circular(borderCircular))
        : BorderRadius.only(
            topLeft: Radius.circular(borderCircular),
            bottomLeft: Radius.circular(borderCircular));

    return Container(
      width: 30.0,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: const Color(0xFFC59400),
      ),
    );
  }
}
