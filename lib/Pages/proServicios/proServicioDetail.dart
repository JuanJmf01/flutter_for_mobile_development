import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/ratingsDb.dart';
import 'package:etfi_point/Components/Data/Entities/serviceImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
import 'package:etfi_point/Components/Data/Routes/rutasFirebase.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Pages/proServicios/proServicioGeneralDetail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProServicioDetail extends StatefulWidget {
  const ProServicioDetail({super.key, required this.proServicio});

  final dynamic proServicio;

  @override
  _ProServicioDetailState createState() => _ProServicioDetailState();
}

class _ProServicioDetailState extends State<ProServicioDetail> {
  int? idProServicio;
  String fileName = "";
  List<ProservicioImagesTb> productSecondaryImages = [];

  Future<dynamic> proServicioDynamic() async {
    dynamic proServicio;

    if (widget.proServicio is ProductoTb && idProServicio != null) {
      proServicio = await ProductoDb.getProducto(idProServicio!);
    } else if (widget.proServicio is ServicioTb && idProServicio != null) {
      proServicio = await ServicioDb.getServicio(idProServicio!);
    }

    return proServicio;
  }

//Modificar para retornar servicio relacionados
  Future<List<ServicioTb>> obtenerProServiciosRelacionados() async {
    List<ServicioTb> serviciosRelacionados = [];
    // if (widget.id != null) {
    //   serviciosRelacionados =
    //       await ProductoDb.getProductosByCategoria(widget.id);
    //   print('Relacionados_: $serviciosRelacionados');
    // } else {
    //   print('idProducto es nulo');
    // }

    return [];
  }

  Future<bool> existeOrNotUserRatingByProServicio(idUsuario) async {
    bool result = false;
    if (widget.proServicio == ProductoTb && idProServicio != null) {
      result = await RatingsDb.checkRatingExists(idProServicio!, idUsuario);
    } else if (widget.proServicio == ServicioTb && idProServicio != null) {
      result = false;
    }

    return result;
  }

  void getListSecondaryProServiciosImages() async {
    List<ProservicioImagesTb> productSecondaryImagesAux = [];

    if (fileName == MisRutasFirebase.forProducts && idProServicio != null) {
      productSecondaryImagesAux =
          await ProductImageDb.getProductSecondaryImages(idProServicio!);
    } else if (fileName == MisRutasFirebase.forServicios &&
        idProServicio != null) {
      print("LLEGA 2: ${idProServicio}");
      productSecondaryImagesAux =
          await ServiceImageDb.getServiceSecondaryImages(idProServicio!);
    }

    setState(() {
      productSecondaryImages = productSecondaryImagesAux;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.proServicio is ProductoTb) {
      fileName = MisRutasFirebase.forProducts;
      idProServicio = widget.proServicio.idProducto;
    } else if (widget.proServicio is ServicioTb) {
      fileName = MisRutasFirebase.forServicios;
      idProServicio = widget.proServicio.idServicio;
    }

    getListSecondaryProServiciosImages();
  }

  @override
  Widget build(BuildContext context) {
    int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuario;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del servicio'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.edit),
          //   onPressed: () async {
          //     await Navigator.push<int>(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) =>
          //             EditarProducto(servicio: widget.servicio),
          //       ),
          //     );
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Acción cuando se presiona el icono de eliminar
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: FutureBuilder<dynamic>(
        future: proServicioDynamic(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final proServicio = snapshot.data!;
            return FutureBuilder<List<ServicioTb>>(
                future: obtenerProServiciosRelacionados(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final productosRelacionados = snapshot.data!;
                    return FutureBuilder<bool>(
                        future: existeOrNotUserRatingByProServicio(idUsuario),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            bool result = snapshot.data!;
                            return idProServicio != null
                                ? Column(
                                    children: [
                                      Expanded(
                                        child: CustomScrollView(
                                          slivers: [
                                            SliverAppBarDetail(
                                              urlImage: proServicio.urlImage,
                                              idProducto: idProServicio!,
                                              productSecondaryImagesAux:
                                                  productSecondaryImages,
                                            ),
                                            FastDescription(
                                                proServicio: proServicio,
                                                ifExistOrNotUserRatingByProServicio:
                                                    result,
                                                idUsuario: idUsuario!),
                                            AdvancedDescription(
                                              descripcionDetallada: "detallada",
                                              idProServicio: idProServicio!,
                                              fileName: fileName,
                                              productSecondaryImagesAux:
                                                  productSecondaryImages,
                                            ),
                                            SummaryReviews(
                                                idProServicio: idProServicio!),
                                            ProductosRelacionados(
                                                proServicios: [])
                                          ],
                                        ),
                                      ),
                                      const StaticBottomNavigator()
                                    ],
                                  )
                                : Text("ERROR ID PROSERVICIO NO ENCONTRADO");
                          } else if (snapshot.hasError) {
                            return const Text('Error al obtener los datos');
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        });
                  } else if (snapshot.hasError) {
                    return const Text('Error al obtener los datos');
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          } else if (snapshot.hasError) {
            return const Text('Error al obtener los datos');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
