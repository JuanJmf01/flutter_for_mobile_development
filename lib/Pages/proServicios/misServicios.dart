import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/proServicios/proServicioDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MisServicios extends StatefulWidget {
  const MisServicios({super.key});

  @override
  State<MisServicios> createState() => _MisServiciosState();
}

class _MisServiciosState extends State<MisServicios> {
  List<ServicioTb> servicios = [];

  @override
  Widget build(BuildContext context) {
    int? idUsuario = context.watch<UsuarioProvider>().idUsuario;

    return idUsuario != null
        ? FutureBuilder(
            future: ServicioDb.getServiciosByNegocio(idUsuario),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error al cargar los servicios');
              } else if (snapshot.hasData) {
                servicios = snapshot.data!;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 0.0,
                            mainAxisSpacing: 15.0,
                            mainAxisExtent: 150,
                          ),
                          itemCount: servicios.length,
                          itemBuilder: (BuildContext context, index) {
                            return IndividulService(servicio: servicios[index]);
                          }),
                    ),
                  ],
                );
              } else {
                return Text('No se encontraron los servicios');
              }
            })
        : Center(child: CircularProgressIndicator());
  }
}

class IndividulService extends StatefulWidget {
  const IndividulService({super.key, required this.servicio});

  final ServicioTb servicio;

  @override
  State<IndividulService> createState() => _IndividulServiceState();
}

class _IndividulServiceState extends State<IndividulService> {
  Future<void> _navigateToServiceDetail(int idService) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProServicioDetail(proServicio: widget.servicio),
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
    final servicio = widget.servicio;
    return Container(
      padding: EdgeInsets.all(0.0),
      //height: 140,
      //width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.0),
        color: Colors.white,
      ),
      child: Row(
        children: [
          InkWell(
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
              borderRadius: BorderRadius.circular(20.0),
              networkImage: servicio.urlImage,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$ ${servicio.precio}",
                    style: Theme.of(context).textTheme.titleSmall!.merge(
                          TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.5,
                          ),
                        ),
                  ),
                  servicio.oferta == 1 && servicio.descuento != null
                      ? Text(
                          "\$ ${priceWithDesc(servicio.precio, servicio.descuento!)}",
                          style: Theme.of(context).textTheme.titleSmall!.merge(
                                TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade500,
                                    fontSize: 16),
                              ),
                        )
                      : SizedBox.shrink(),
                  Spacer(),
                  Text(
                    servicio.nombre,
                    style: Theme.of(context).textTheme.titleMedium!.merge(
                          const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16.5),
                        ),
                  ),
                  Icon(CupertinoIcons.heart_fill),
                ],
              ),
            ),
          ),
          servicio.oferta == 1
              ? Container(
                  width: 30.0,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                    color: Color(0xFFC59400),
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
