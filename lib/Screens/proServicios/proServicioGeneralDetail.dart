import 'dart:typed_data';

import 'package:etfi_point/components/widgets/ImagesUtils/crudImages.dart';
import 'package:etfi_point/components/widgets/elevatedGlobalButton.dart';
import 'package:etfi_point/Data/models/productImagesStorageTb.dart';
import 'package:etfi_point/Data/models/proServicioImagesTb.dart';
import 'package:etfi_point/Data/models/productoTb.dart';
import 'package:etfi_point/Data/models/ratingsTb.dart';
import 'package:etfi_point/Data/models/servicioTb.dart';
import 'package:etfi_point/Data/services/api/productImageDb.dart';
import 'package:etfi_point/Data/services/api/productosDb.dart';
import 'package:etfi_point/Data/services/api/ratingsDb.dart';
import 'package:etfi_point/Data/services/api/serviceImageDb.dart';
import 'package:etfi_point/Data/services/api/FirebaseStorage/firebaseImagesStorage.dart';
import 'package:etfi_point/config/Routes/rutasFirebase.dart';
import 'package:etfi_point/config/routes/routes.dart';
import 'package:etfi_point/constants/Icons/switch.dart';
import 'package:etfi_point/components/widgets/ImagesUtils/myImageList.dart';
import 'package:etfi_point/components/utils/MediaPicker.dart';
import 'package:etfi_point/components/utils/randomServices.dart';
import 'package:etfi_point/components/widgets/confirmationDialog.dart';
import 'package:etfi_point/components/widgets/generalInputs.dart';
import 'package:etfi_point/components/widgets/globalTextButton.dart';
import 'package:etfi_point/components/widgets/navigatorPush.dart';
import 'package:etfi_point/components/widgets/showImage.dart';
import 'package:etfi_point/Data/services/providers/userStateProvider.dart';
import 'package:etfi_point/Screens/reviewsAndOpinions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';

class SliverAppBarDetail extends StatelessWidget {
  const SliverAppBarDetail({
    super.key,
    required this.urlImage,
    required this.idProServicio,
    required this.productSecondaryImagesAux,
  });

  final String urlImage;
  final int idProServicio;
  final ImageList productSecondaryImagesAux;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: MyImageList(
        imageList: productSecondaryImagesAux,
        onImageSelected: (selectedImage) {
          print('mostrar la imagen grande');
        },
      ),
    );
  }
}

class FastDescription extends StatefulWidget {
  const FastDescription({
    super.key,
    required this.proServicio,
    required this.ifExistOrNotUserRatingByProServicio,
    required this.idUsuario,
    required this.objectType,
  });

  final dynamic proServicio;
  final bool ifExistOrNotUserRatingByProServicio;
  final int idUsuario;
  final Type objectType;

  @override
  State<FastDescription> createState() => _FastDescriptionState();
}

class _FastDescriptionState extends State<FastDescription> {
  RatingsCreacionTb? ratingsAndOthers;
  bool pressHearIndex = false;
  int? rating = 0;
  bool ifExistOrNotUserRatingByProServicio = false;
  int? idProServicio;
  Type? objectType;

  void _selectedHeard() {
    setState(() {
      pressHearIndex = !pressHearIndex;
    });

    _updateRatingAndOthers();
  }

  void rateStar(int starIndex) {
    if (starIndex == rating) {
      setState(() {
        rating = 0;
      });
    } else {
      setState(() {
        rating = starIndex;
      });
    }
    _updateRatingAndOthers();
  }

  void _updateRatingAndOthers() async {
    int idUsuario = widget.idUsuario;

    int like = pressHearIndex ? 1 : 0;
    String urlRating = '';
    if (objectType == ProductoTb) {
      urlRating = MisRutas.rutaRatings;
    } else if (objectType == ServicioTb) {
      urlRating = MisRutas.rutaServiceRatings;
    }
    if (idProServicio != null) {
      RatingsCreacionTb ratingsAndothers = RatingsCreacionTb(
          idUsuario: idUsuario,
          idProServicio: idProServicio!,
          likes: like,
          ratings: rating ?? 0);

      await RatingsDb.saveRating(
          ratingsAndothers, ifExistOrNotUserRatingByProServicio, urlRating);

      ifExistOrNotUserRatingByProServicio = true;
    }
  }

  void obtenerRatingsAndOther() async {
    String urlRating = '';

    if (objectType == ProductoTb) {
      urlRating = MisRutas.rutaRatingsByProductoAndUser;
    } else if (objectType == ServicioTb) {
      urlRating = MisRutas.rutaRatingsByServiceAndUser;
    }

    if (idProServicio != null) {
      ratingsAndOthers = await RatingsDb.getRatingByProServicioAndUsuario(
          widget.idUsuario, idProServicio!, urlRating);
    }

    print(ratingsAndOthers);

    if (ratingsAndOthers?.likes == 1) {
      setState(() {
        pressHearIndex = true;
      });
    } else if (ratingsAndOthers?.likes == 0) {
      setState(() {
        pressHearIndex = false;
      });
    }

    rating = ratingsAndOthers?.ratings ?? 0;
  }

  @override
  void initState() {
    super.initState();

    ifExistOrNotUserRatingByProServicio =
        widget.ifExistOrNotUserRatingByProServicio;

    if (widget.objectType == ProductoTb) {
      idProServicio = widget.proServicio.idProducto;
      objectType = ProductoTb;
    } else if (widget.objectType == ServicioTb) {
      idProServicio = widget.proServicio.idServicio;
      objectType = ServicioTb;
    }

    bool result = widget.ifExistOrNotUserRatingByProServicio;
    if (result) {
      obtenerRatingsAndOther();
    }

    print('existe rating:  ${widget.ifExistOrNotUserRatingByProServicio}');
  }

  @override
  Widget build(BuildContext context) {
    final proServicio = widget.proServicio;
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)),
          //color: Colors.grey.shade100,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3.0, 7.0, 20.0, 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _selectedHeard();
                        },
                        icon: Icon(
                          pressHearIndex
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: pressHearIndex ? Colors.red : Colors.black,
                          size: pressHearIndex ? 32 : 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send_outlined,
                          size: 27,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (int i = 1; i <= 5; i++)
                        SizedBox(
                          width: 25.0,
                          child: IconButton(
                            onPressed: () {
                              rateStar(i);
                            },
                            icon: Icon(
                              Icons.star_rounded,
                              color: i <= rating!
                                  ? Colors.yellow.shade700
                                  : Colors.grey,
                              size: 30,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          height: 20,
                          //color: Colors.grey,
                          margin: const EdgeInsets.only(left: 0.0),
                        ),
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(4.5, 8.0, 3.0, 0.0),
                          child: TextButton(
                            onPressed: () {
                              if (idProServicio != null) {
                                NavigatorPush.navigate(
                                  context,
                                  ReviewsAndOpinions(
                                    idProServicio: idProServicio!,
                                    objectType: widget.objectType,
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                '+ 20K',
                                style: TextStyle(
                                  color: Colors.blue[500],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
                    child: Text(
                      'COP ${proServicio.precio}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20.0, 20.0, 20.0),
                child: Text(
                  proServicio.descripcion.isNotEmpty
                      ? proServicio.descripcion
                      : "No hay descripcion que mostrar",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AdvancedDescription extends ConsumerStatefulWidget {
  const AdvancedDescription({
    super.key,
    this.descripcionDetallada,
    required this.idProServicio,
    required this.fileName,
    required this.productSecondaryImagesAux,
  });

  final String? descripcionDetallada;
  final int idProServicio;
  final String fileName;
  final List<ProservicioImagesTb> productSecondaryImagesAux;

  @override
  AdvancedDescriptionState createState() => AdvancedDescriptionState();
}

class AdvancedDescriptionState extends ConsumerState<AdvancedDescription> {
  List<ProservicioImagesTb> productSecondaryImages = [];
  ImageList allProductImages = ImageList([]);
  bool isChecked = true;

  List<ProServicioImageToUpload> imagesToUpload = [];
  List<ProServicioImageToUpdate> imagesToUpdate = [];

  final TextEditingController _descripcionDetalldaController =
      TextEditingController();
  String? descripcionDetalladaAux;
  String fileName = '';

  // void insertProServicioImage(int idUsuario) async {
  //   if (imagesToUpload.isNotEmpty) {
  //     List<ProservicioImagesTb> productImagesAux = [];
  //     for (var imageToUpload in imagesToUpload) {
  //       Uint8List imageBytes =
  //           await RandomServices.assetToUint8List(imageToUpload.newImage);
  //       String fileName =
  //           RandomServices.assingName(imageToUpload.newImage.name!);

  //       ImagesStorageTb image = ImagesStorageTb(
  //         idUsuario: idUsuario,
  //         idFile: widget.idProServicio,
  //         newImageBytes: imageBytes,
  //         fileName: fileName,
  //         imageName: fileName,
  //       );

  //       String url = await ImagesStorage.cargarImage(image);

  //       ProServicioImageCreacionTb proServicioCreacionImage =
  //           ProServicioImageCreacionTb(
  //         idProServicio: widget.idProServicio,
  //         nombreImage: fileName,
  //         urlImage: url,
  //         width: imageToUpload.width,
  //         height: imageToUpload.height,
  //         isPrincipalImage: 0,
  //       );

  //       if (fileName == MisRutasFirebase.forProducts) {
  //         ProservicioImagesTb proServicioImage =
  //             await ProductImageDb.insertProductImages(
  //                 proServicioCreacionImage);
  //         productImagesAux.add(proServicioImage);
  //       } else if (fileName == MisRutasFirebase.forServicios) {
  //         ProservicioImagesTb proservicioImage =
  //             await ServiceImageDb.insertServiceImage(proServicioCreacionImage);
  //         productImagesAux.add(proservicioImage);
  //       }
  //     }

  //     setState(() {
  //       if (allProductImages.items.isNotEmpty) {
  //         allProductImages.items.clear();
  //       }
  //       productSecondaryImages = [
  //         ...productSecondaryImages,
  //         ...productImagesAux
  //       ];
  //       if (allProductImages.items.isEmpty) {
  //         allProductImages = ImageList(productSecondaryImages);
  //       } else {
  //         allProductImages.items.addAll(productSecondaryImages);
  //       }

  //       imagesToUpload.clear();
  //     });
  //   }
  // }

  // void updateSecondaryImage(int idUsuario) async {
  //   if (imagesToUpdate.isNotEmpty) {
  //     await Future.forEach(imagesToUpdate, (newImage) async {
  //       String nombreImage = newImage.nombreImage;
  //       Asset imageToUpdate = newImage.newImage;

  //       print("LONG IMAGE_: ${imageToUpdate.originalHeight!.toDouble()}");

  //       ImagesStorageTb image = ImagesStorageTb(
  //           idUsuario: idUsuario,
  //           idFile: widget.idProServicio,
  //           newImageBytes: await RandomServices.assetToUint8List(imageToUpdate),
  //           fileName: fileName,
  //           imageName: nombreImage);

  //       String url = await ImagesStorage.updateImage(image);
  //       print('URL image_: $url');
  //       for (int i = 0; i < productSecondaryImages.length; i++) {
  //         //Solo entra al if en una ocacion por lo que no hay problema con el setState dentro del ciclo for
  //         if (productSecondaryImages[i].nombreImage == nombreImage) {
  //           setState(() {
  //             productSecondaryImages[i] =
  //                 productSecondaryImages[i].copyWith(urlImage: url);

  //             if (allProductImages.items.isNotEmpty) {
  //               allProductImages.items.clear();
  //             }
  //             allProductImages.items.addAll(productSecondaryImages);
  //           });
  //           break;
  //         } else {
  //           print('No encontrado en updateSecondaryImage');
  //         }
  //       }
  //     });

  //     setState(() {
  //       imagesToUpdate.clear();
  //     });
  //   } else {
  //     print('Imagen a actualizar es null');
  //   }
  // }

  //Actualizar descripcion detallada
  void updateDescripcionDetallada() async {
    final descripcionDetallada = _descripcionDetalldaController.text;

    if (descripcionDetalladaAux != descripcionDetallada) {
      bool result = await ProductoDb.updateProductDescripcionDetallada(
          descripcionDetallada, widget.idProServicio);
      if (result) {
        setState(() {
          descripcionDetalladaAux = descripcionDetallada;
        });
      }
    } else {
      print('es la misma descripcion detallada');
    }
  }

  // void agregarImagenes() async {
  //   List<ProServicioImageToUpload> allProductImagesAux =
  //       await CrudImages.agregarImagenes();

  //   setState(() {
  //     allProductImages.items.addAll(allProductImagesAux);

  //     imagesToUpload = [...imagesToUpload, ...allProductImagesAux];
  //   });
  // }

  /// The function `editarImagenes` is used to edit images by replacing them with new images in a list.
  ///
  /// Args:
  ///   image: The parameter `image` is of type `dynamic` and represents an image object.
  // void editarImagenes(final image) async {
  //   Asset? asset = await getImageAsset();
  //   if (asset != null) {
  //     int imageIndex = allProductImages.items.indexOf(image);

  //     int indice = imagesToUpdate
  //         .indexWhere((element) => element.nombreImage == image.nombreImage);

  //     /** Si 'indice' != de -1  es por que ya ha sido cambiada previamente
  //     * En este caso el objeto ya se encuentra dentro de 'imagesToUpdate' por lo tanto 
  //      * solo es necesario actualizar "imageToUpdate" respecto a su posicion 'indice' y dejar 
  //      * "nombreImage" igual ya que este nombre se utiliza para completar la ruta en firebase Storage y actualizar */
  //     if (indice != -1 || image is ProServicioImageToUpdate) {
  //       ProServicioImageToUpdate newImage = ProServicioImageToUpdate(
  //         nombreImage: imagesToUpdate[indice].nombreImage,
  //         newImage: asset,
  //       );
  //       setState(() {
  //         allProductImages.items[imageIndex] = newImage;
  //         imagesToUpdate[indice] = newImage;
  //       });
  //     } else {
  //       if (image is ProservicioImagesTb) {
  //         ProServicioImageToUpdate newImage = ProServicioImageToUpdate(
  //           nombreImage: image.nombreImage,
  //           newImage: asset,
  //         );
  //         setState(() {
  //           imagesToUpdate.add(newImage);
  //           allProductImages.items[imageIndex] = newImage;
  //         });
  //       } else if (image is ProServicioImageToUpload) {
  //         int indiceToUpload = imagesToUpload.indexWhere(
  //             (element) => element.nombreImage == image.nombreImage);
  //         ProServicioImageToUpload newImage = ProServicioImageToUpload(
  //           nombreImage: RandomServices.assingName(asset.name!),
  //           newImage: asset,
  //           width: asset.originalWidth!.toDouble(),
  //           height: asset.originalHeight!.toDouble(),
  //         );

  //         setState(() {
  //           allProductImages.items[imageIndex] = newImage;
  //           imagesToUpload[indiceToUpload] = newImage;
  //         });
  //       }
  //     }
  //   }
  // }

  void eliminarImagen(final image, int idUsuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (image is ProservicioImagesTb) {
          return DeletedDialog(
              onPress: () async {
                ImageStorageDeleteTb infoImageToDelete = ImageStorageDeleteTb(
                  fileName: fileName,
                  idUsuario: idUsuario,
                  imageName: image.nombreImage,
                  idFile: image.idProServicio,
                );

                bool deleteResult =
                    await ImagesStorage.deleteImage(infoImageToDelete);

                if (fileName == MisRutasFirebase.forProducts) {
                  await ProductImageDb.deleteProuctImage(
                      image.idProServicioImage);
                } else if (fileName == MisRutasFirebase.forServicios) {
                  print(
                      "ENTRA A PROSERVICIO IMAGE: ${image.idProServicioImage}");
                  await ServiceImageDb.deleteServiceImage(
                      image.idProServicioImage);
                }

                if (deleteResult) {
                  setState(() {
                    allProductImages.items.removeWhere((element) {
                      if (element is ProservicioImagesTb) {
                        return element.nombreImage == image.nombreImage;
                      }
                      return false;
                    });
                    productSecondaryImages.removeWhere(
                        (element) => element.nombreImage == image.nombreImage);
                  });
                } else {
                  print(
                      'No fue posible eliminar ProductImagesStorage: $deleteResult');
                }

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              objectToDelete: 'la imagen');
        } else if (image is ProServicioImageToUpdate ||
            image is ProServicioImageToUpload) {
          return RuleOut(
            onPress: () {
              int imageIndex = allProductImages.items.indexOf(image);
              /**De la lista de imagenes originales, sacamos la imagen base o imagen que inicialmente habia */

              if (image is ProServicioImageToUpdate) {
                ProservicioImagesTb oldImage =
                    productSecondaryImages[imageIndex];

                setState(() {
                  allProductImages.items[imageIndex] = oldImage;
                  imagesToUpdate.remove(image);
                });
              } else if (image is ProServicioImageToUpload) {
                setState(() {
                  allProductImages.items.removeAt(imageIndex);
                  imagesToUpload.remove(image);
                });
              }

              Navigator.of(context).pop();
            },
            objectToDelete: 'La imagen',
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _descripcionDetalldaController.text = widget.descripcionDetallada ?? '';
    descripcionDetalladaAux = widget.descripcionDetallada;
    fileName = widget.fileName;

    productSecondaryImages = widget.productSecondaryImagesAux;
    allProductImages.items.addAll(widget.productSecondaryImagesAux);
  }

  @override
  Widget build(BuildContext context) {
    //int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuarioActual;
    final int? idUsuarioActual = ref.watch(getCurrentUserProvider).value;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: SwitchIcon(
                    isChecked: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value;
                      });
                      print(isChecked);
                    },
                  ),
                ),
                const Text('Modificar'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                16.0, productSecondaryImages.isNotEmpty ? 0.0 : 20.0, 0.0, 0.0),
            child: const Text(
              'Descripcion detallada',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                isChecked ? 8.0 : 16, 23.0, isChecked ? 8.0 : 30, 30.0),
            child: isChecked
                ? GeneralInputs(
                    controller: _descripcionDetalldaController,
                    labelText: 'Agrega una descripcion detalla del producto',
                    color: Colors.grey.shade200,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 40,
                  )
                : Text(
                    descripcionDetalladaAux != null &&
                            descripcionDetalladaAux!.isNotEmpty
                        ? descripcionDetalladaAux!
                        : 'No hay descripcion que mostrar',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                    ),
                  ),
          ),
          allProductImages.items.isNotEmpty
              ? Column(
                  children: [
                    for (var image in allProductImages.items)
                      Column(
                        children: [
                          // Container(
                          //     child: image is ProservicioImagesTb
                          //         ? ShowImage(
                          //             networkImage: image.urlImage,
                          //             //height: 200,
                          //             width: double.infinity,
                          //             fit: BoxFit.cover,
                          //           )
                          //         : image is ProServicioImageToUpload ||
                          //                 image is ProServicioImageToUpdate
                          //             // Si image is ProServicioImageToUpload entt image.newImage, de lo contrario si image is ProServicioImageToUpdate entt image.newImage
                          //             ? ShowImage(
                          //                 imageAsset: image
                          //                         is ProServicioImageToUpload
                          //                     ? image.newImage
                          //                     : image is ProServicioImageToUpdate
                          //                         ? image.newImage
                          //                         : null,
                          //                 widthImage: double.infinity,
                          //               )
                          //             : const SizedBox.shrink()),
                          isChecked
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    createCustomButton(
                                      () {
                                        if (idUsuarioActual != null) {
                                          eliminarImagen(
                                              image, idUsuarioActual);
                                        }
                                      },
                                      image is ProservicioImagesTb
                                          ? 'Eliminar'
                                          : 'Descartar',
                                      color: image is ProservicioImagesTb
                                          ? Colors.red.shade700
                                          : Colors.lightGreen.shade500,
                                    ),
                                    createCustomButton(
                                      //onPress
                                      () {
                                        // editarImagenes(image);
                                      },
                                      'Editar',
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink()
                        ],
                      )
                  ],
                )
              : const Center(
                  child: Text('Aqui puedes agregar imagenes del producto'),
                ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () async {
                  // agregarImagenes();
                },
                icon: Icon(CupertinoIcons.add_circled,
                    size: 40, color: Colors.grey.shade600),
              ),
            ),
          ),
          ElevatedGlobalButton(
              paddingLeft: 8.0,
              paddingTop: 10,
              paddingRight: 8.0,
              paddingBottom: 25,
              fontSize: 20.0,
              borderRadius: BorderRadius.circular(3.5),
              nameSavebutton: 'Guardar cambios',
              heightSizeBox: 50,
              widthSizeBox: double.infinity,
              onPress: () {
                if (idUsuarioActual != null) {
                  // insertProServicioImage(idUsuarioActual);
                }
                if (idUsuarioActual != null) {
                  // updateSecondaryImage(idUsuarioActual);
                }
                updateDescripcionDetallada();
              }),
        ],
      ),
    );
  }

  Widget createCustomButton(VoidCallback onPressedCallback, String placeholder,
      {Color? color, doubler}) {
    return Expanded(
      child: ElevatedGlobalButton(
          paddingTop: 1.0,
          paddingBottom: 12.0,
          nameSavebutton: placeholder,
          heightSizeBox: 48.0,
          fontSize: 19,
          backgroundColor: color,
          fontWeight: FontWeight.w700,
          borderRadius: BorderRadius.circular(5.0),
          letterSpacing: 0.5,
          onPress: onPressedCallback),
    );
  }
}

class SummaryReviews extends StatelessWidget {
  const SummaryReviews({
    super.key,
    required this.idProServicio,
    required this.objectType,
  });

  final int idProServicio;
  final Type objectType;

  void navigateToReviewsAndOpinions(BuildContext context) {
    NavigatorPush.navigate(
      context,
      ReviewsAndOpinions(
        idProServicio: idProServicio,
        objectType: objectType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.blue.shade600;
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.grey.shade100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 17.0, 0.0),
              child: TextButton(
                onPressed: () => navigateToReviewsAndOpinions(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Calificaciones y opiniones',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 26,
                    ),
                  ],
                ),
              ),
            ),
            Comments(
              idProServicio: idProServicio,
              selectIndex: 0,
              paddingOutsideHorizontal: 5.0,
              paddingOutsideVertical: 0.0,
              containerPadding: 10.0,
              //color: Colors.grey[300],
              minLines: 3,
              fontSizeDescription: 16,
              fontSizeName: 17,
              fontSizeStarts: 21,
              objectType: objectType,
            ),
            Center(
              child: GlobalTextButton(
                onPressed: () => navigateToReviewsAndOpinions(context),
                textButton: 'Todas las calificaciones',
                fontSizeTextButton: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductosRelacionados extends StatelessWidget {
  const ProductosRelacionados({super.key, required this.proServicios});

  final List<dynamic> proServicios;

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        //child: RowProducts(productos: widget.productos),
        child: Text('Llamar a los productos'),
      ),
    );
  }
}
