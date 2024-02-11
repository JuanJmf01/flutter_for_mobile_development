import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/ratingsDb.dart';
import 'package:etfi_point/Components/Data/Entities/serviceImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
import 'package:etfi_point/Components/Data/Entities/FirebaseStorage/firebaseImagesStorage.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:etfi_point/Components/Data/Routes/rutasFirebase.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/Pages/proServicios/proServicioGeneralDetail.dart';
import 'package:etfi_point/Pages/proServicios/servicios/serviciosGeneralForm.dart';
import 'package:etfi_point/Pages/proServicios/productos/productosGeneralForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProServicioDetail extends StatefulWidget {
  const ProServicioDetail(
      {super.key, required this.proServicio, required this.nameContexto});

  final dynamic proServicio;
  final String nameContexto;

  @override
  _ProServicioDetailState createState() => _ProServicioDetailState();
}

class _ProServicioDetailState extends State<ProServicioDetail> {
  int? idProServicio;
  String fileName = "";
  List<ProservicioImagesTb> productSecondaryImages = [];
  Type? objectType;

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
    if (widget.proServicio is ProductoTb && idProServicio != null) {
      String url = MisRutas.rutaRatingsIfExistRating;
      result =
          await RatingsDb.checkRatingExists(idProServicio!, idUsuario, url);
    } else if (widget.proServicio is ServicioTb && idProServicio != null) {
      String url = MisRutas.rutaServiceRatingsIfExistRating;
      result =
          await RatingsDb.checkRatingExists(idProServicio!, idUsuario, url);
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
      print("LLEGA 2: $idProServicio");
      productSecondaryImagesAux =
          await ServiceImageDb.getServiceSecondaryImages(idProServicio!);
    }

    print("IMAGENES: $productSecondaryImagesAux");

    setState(() {
      productSecondaryImages = productSecondaryImagesAux;
    });
  }

  void eliminarProServicio(int idUsuario) {
    print("ENTRA EN ELIMINAR DIR");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          titulo: 'Advertencia',
          message: '¿Seguro que deseas eliminar este producto o servicio?',
          onAcceptMessage: 'Aceptar',
          onCancelMessage: 'Cancelar',
          onAccept: () async {
            String urlDirectory =
                'imagenes/$idUsuario/$fileName/$idProServicio';

            bool resultStorageImages =
                await ImagesStorage.deleteDirectory(urlDirectory);
            if (resultStorageImages) {
              try {
                print('Id producto: $idProServicio');
                if (objectType == ProductoTb) {
                  await ProductoDb.deleteProducto(idProServicio!);
                } else if (objectType == ServicioTb) {
                  await ServicioDb.deleteServicio(idProServicio!);
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
                //deleteProduct(producto.idProducto);
              } catch (error) {
                print('Error al eliminar el producto: $error');
              }
            }
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.proServicio is ProductoTb) {
      fileName = MisRutasFirebase.forProducts;
      idProServicio = (widget.proServicio as ProductoTb).idProducto;
      objectType = ProductoTb;
    } else if (widget.proServicio is ServicioTb) {
      fileName = MisRutasFirebase.forServicios;
      idProServicio = (widget.proServicio as ServicioTb).idServicio;
      objectType = ServicioTb;
    }

    getListSecondaryProServiciosImages();
  }

  @override
  Widget build(BuildContext context) {
    int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuarioActual;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del ${widget.nameContexto}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) => objectType == ServicioTb
                      ? ServiciosGeneralForm(
                          titulo: "Editar Servicio",
                          nameSaveButton: "Actualizar",
                          servicio: widget.proServicio,
                        )
                      : objectType == ProductoTb
                          ? ProductosGeneralForm(
                              producto: widget.proServicio,
                              titulo: "EditarProducto",
                              nameSavebutton: "Actualizar ",
                              exitoMessage: "Actualizado correctamente")
                          : const SizedBox.shrink(),
                ),
              );
            },
          ),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                if (idUsuario != null && idProServicio != null) {
                  eliminarProServicio(idUsuario);
                }
              }),
        ],
      ),
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
                                              idProServicio: idProServicio!,
                                              productSecondaryImagesAux:
                                                  productSecondaryImages,
                                            ),
                                            FastDescription(
                                              proServicio: proServicio,
                                              ifExistOrNotUserRatingByProServicio:
                                                  result,
                                              idUsuario: idUsuario!,
                                              objectType: objectType!,
                                            ),
                                            AdvancedDescription(
                                              descripcionDetallada: "detallada",
                                              idProServicio: idProServicio!,
                                              fileName: fileName,
                                              productSecondaryImagesAux:
                                                  productSecondaryImages,
                                            ),
                                            objectType != null
                                                ? SummaryReviews(
                                                    idProServicio:
                                                        idProServicio!,
                                                    objectType: objectType!,
                                                  )
                                                : const SizedBox.shrink(),
                                            const ProductosRelacionados(
                                                proServicios: [])
                                          ],
                                        ),
                                      ),
                                      //const StaticBottomNavigator()
                                    ],
                                  )
                                : const Text("ERROR ID PROSERVICIO NO ENCONTRADO");
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
