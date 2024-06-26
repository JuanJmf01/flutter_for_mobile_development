import 'package:etfi_point/Data/models/proServicioImagesTb.dart';
import 'package:etfi_point/Data/models/productoTb.dart';
import 'package:etfi_point/Data/models/servicioTb.dart';
import 'package:etfi_point/Data/services/api/productImageDb.dart';
import 'package:etfi_point/Data/services/api/productosDb.dart';
import 'package:etfi_point/Data/services/api/ratingsDb.dart';
import 'package:etfi_point/Data/services/api/serviceImageDb.dart';
import 'package:etfi_point/Data/services/api/servicioDb.dart';
import 'package:etfi_point/Data/services/api/FirebaseStorage/firebaseImagesStorage.dart';
import 'package:etfi_point/components/widgets/confirmationDialog.dart';
import 'package:etfi_point/components/widgets/navigatorPush.dart';
import 'package:etfi_point/Data/services/providers/categoriasProvider.dart';
import 'package:etfi_point/Data/services/providers/userStateProvider.dart';
import 'package:etfi_point/Screens/proServicios/proServicioGeneralDetail.dart';
import 'package:etfi_point/Screens/proServicios/productos/productoGeneralForm.dart';
import 'package:etfi_point/Screens/proServicios/servicios/serviceGeneralForm.dart';
import 'package:etfi_point/config/Routes/rutasFirebase.dart';
import 'package:etfi_point/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProServicioDetail extends ConsumerStatefulWidget {
  const ProServicioDetail(
      {super.key, required this.proServicio, required this.nameContexto});

  final dynamic proServicio;
  final String nameContexto;

  @override
  ProServicioDetailState createState() => ProServicioDetailState();
}

class ProServicioDetailState extends ConsumerState<ProServicioDetail> {
  int? idProServicio;
  String fileName = '';
  String urlImage = '';
  ImageList proServiceSecondaryImagesList = ImageList([]);
  List<ProservicioImagesTb> proServiceSecondaryImages = [];
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
      proServiceSecondaryImagesList = ImageList(productSecondaryImagesAux);
      proServiceSecondaryImages.addAll(productSecondaryImagesAux);
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
      urlImage = (widget.proServicio as ProductoTb).urlImage;
    } else if (widget.proServicio is ServicioTb) {
      fileName = MisRutasFirebase.forServicios;
      idProServicio = (widget.proServicio as ServicioTb).idServicio;
      objectType = ServicioTb;
      urlImage = (widget.proServicio as ServicioTb).urlImage;
    }

    getListSecondaryProServiciosImages();
  }

  @override
  Widget build(BuildContext context) {
    //int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuarioActual;
    final int? idUsuarioActual = ref.watch(getCurrentUserProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del ${widget.nameContexto}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ref
                  .read(subCategoriasSelectedProvider.notifier)
                  .update((state) => []);

              NavigatorPush.navigate(
                context,
                objectType == ServicioTb
                    ? ServiceGeneralForm(
                        service: widget.proServicio,
                      )
                    : objectType == ProductoTb
                        ? ProductoGeneralForm(
                            product: widget.proServicio,
                          )
                        : const SizedBox.shrink(),
              );
            },
          ),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                if (idUsuarioActual != null && idProServicio != null) {
                  eliminarProServicio(idUsuarioActual);
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
                        future:
                            existeOrNotUserRatingByProServicio(idUsuarioActual),
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
                                              urlImage: urlImage,
                                              idProServicio: idProServicio!,
                                              productSecondaryImagesAux:
                                                  proServiceSecondaryImagesList,
                                            ),
                                            FastDescription(
                                              proServicio: proServicio,
                                              ifExistOrNotUserRatingByProServicio:
                                                  result,
                                              idUsuario: idUsuarioActual!,
                                              objectType: objectType!,
                                            ),
                                            AdvancedDescription(
                                              descripcionDetallada: "detallada",
                                              idProServicio: idProServicio!,
                                              fileName: fileName,
                                              productSecondaryImagesAux:
                                                  proServiceSecondaryImages,
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
                                : const Text(
                                    "ERROR ID PROSERVICIO NO ENCONTRADO");
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
