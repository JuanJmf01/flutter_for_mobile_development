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
        builder: (context) =>
            ProServicioDetail(proServicio: widget.servicio),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      //height: 140,
      //width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.0),
        color: Colors.grey.shade300,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _navigateToServiceDetail(widget.servicio.idServicio);
            },
            child: ShowImage(
              height: double.infinity,
              width: 180,
              fit: BoxFit.cover,
              // borderRadius: const BorderRadius.only(
              //     topRight: Radius.circular(20),
              //     bottomRight: Radius.circular(20.0)),
              borderRadius: BorderRadius.circular(20.0),
              networkImage: widget.servicio.urlImage,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alinea el texto a la izquierda
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.servicio.nombre,
                  style: Theme.of(context).textTheme.titleMedium!.merge(
                        const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          widget.servicio.precio.toString(),
                          style: Theme.of(context).textTheme.titleSmall!.merge(
                                TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                        ),
                        Text("Precio Anterior"),
                      ],
                    ),
                    Icon(CupertinoIcons.heart_fill),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
