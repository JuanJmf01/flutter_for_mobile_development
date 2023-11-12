import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/ratingsTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/ratingsDb.dart';
import 'package:etfi_point/Components/Data/Entities/serviceImageDb.dart';
import 'package:etfi_point/Components/Data/Firebase/Storage/productImagesStorage.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:etfi_point/Components/Data/Routes/rutasFirebase.dart';
import 'package:etfi_point/Components/Utils/AssetToUint8List.dart';
import 'package:etfi_point/Components/Utils/ElevatedGlobalButton.dart';
import 'package:etfi_point/Components/Utils/Icons/switch.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/myImageList.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Services/assingName.dart';
import 'package:etfi_point/Components/Utils/Services/selectImage.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/reviewsAndOpinions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class SliverAppBarDetail extends StatefulWidget {
  const SliverAppBarDetail({
    super.key,
    required this.urlImage,
    required this.idProServicio,
    required this.productSecondaryImagesAux,
  });

  final String urlImage;
  final int idProServicio;
  final List<ProservicioImagesTb> productSecondaryImagesAux;

  @override
  State<SliverAppBarDetail> createState() => _SliverAppBarDetailState();
}

class _SliverAppBarDetailState extends State<SliverAppBarDetail> {
  //List<dynamic> allProductImages = [];
  ImageList? myImageList;

  @override
  void initState() {
    super.initState();

    if (myImageList == null) {
      myImageList = ImageList(widget.productSecondaryImagesAux);
    } else {
      myImageList!.items.addAll(widget.productSecondaryImagesAux);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: myImageList != null
            ? MyImageList(
                imageList: myImageList!,
                onImageSelected: (selectedImage) {
                  print('mostrar la imagen grande');
                })
            : SizedBox.shrink()
        // child: Padding(
        //   padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        //   child: Container(
        //     constraints: const BoxConstraints(
        //       maxHeight: 260, // Altura máxima para la lista de imágenes
        //     ),
        //     child: ListView.builder(
        //       scrollDirection: Axis.horizontal,
        //       itemCount: allProductImages.length,
        //       itemBuilder: (BuildContext context, int index) {
        //         final image = allProductImages[index]!;
        //         double originalWidth = image.width;
        //         double originalHeight = image.height;
        //         double desiredWidth = 600.0;
        //         double desiredHeight =
        //             desiredWidth * (originalHeight / originalWidth);

        //         return Column(
        //           children: [
        //             Expanded(
        //               child: Padding(
        //                 padding: index == 0
        //                     ? const EdgeInsets.fromLTRB(40.0, 7.0, 10.0, 0.0)
        //                     : const EdgeInsets.fromLTRB(0.0, 7.0, 7.0, 0.0),
        //                 child: Container(
        //                   decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(20.0),
        //                   ),
        //                   child: ClipRRect(
        //                     borderRadius: BorderRadius.circular(16.0),
        //                     child: Image.network(
        //                       image.urlImage,
        //                       fit: BoxFit.contain,
        //                       //height: desiredHeight,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         );
        //       },
        //     ),
        //   ),
        // ),
        );
  }
}

// class SliverAppBarDetail extends StatefulWidget {
//   const SliverAppBarDetail({super.key, required this.urlImage});

//   final String urlImage;

//   @override
//   State<SliverAppBarDetail> createState() => _SliverAppBarDetailState();
// }

// class _SliverAppBarDetailState extends State<SliverAppBarDetail> {
//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       elevation: 0,
//       pinned: true,
//       centerTitle: false,
//       stretch: true,
//       expandedHeight: 350.0,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back),
//         color: Colors.black,
//         onPressed: () {
//           Navigator.pop(context);
//         },
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//           stretchModes: const [StretchMode.zoomBackground],
//           background: ShowImage(
//             networkImage: widget.urlImage,
//             fit: BoxFit.cover,
//           )),
//     );
//   }
// }

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

    print('existe :  ${widget.ifExistOrNotUserRatingByProServicio}');
  }

  @override
  Widget build(BuildContext context) {
    final proServicio = widget.proServicio;
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0)),
            color: Colors.grey.shade100),
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
                          color: Colors.grey,
                          margin: const EdgeInsets.only(left: 0.0),
                        ),
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(4.5, 8.0, 3.0, 0.0),
                          child: TextButton(
                            onPressed: () {
                              if (idProServicio != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReviewsAndOpinions(
                                      idProServicio: idProServicio!,
                                      objectType: widget.objectType,
                                    ),
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

class AdvancedDescription extends StatefulWidget {
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
  State<AdvancedDescription> createState() => _AdvancedDescriptionState();
}

class _AdvancedDescriptionState extends State<AdvancedDescription> {
  List<ProservicioImagesTb> productSecondaryImages = [];
  ImageList allProductImages = ImageList([]);
  bool isChecked = true;

  List<ProductImageToUpload> imagesToUpload = [];
  List<ProductImageToUpdate> imagesToUpdate = [];

  final TextEditingController _descripcionDetalldaController =
      TextEditingController();
  String? descripcionDetalladaAux;
  String fileName = '';

  void insertProServicioImage(int idUsuario) async {
    if (imagesToUpload.isNotEmpty) {
      List<ProservicioImagesTb> productImagesAux = [];
      for (var imageToUpload in imagesToUpload) {
        Uint8List imageBytes = await assetToUint8List(imageToUpload.newImage);
        String fileName = assingName(imageToUpload.newImage.name!);

        ImageStorageCreacionTb image = ImageStorageCreacionTb(
          idUsuario: idUsuario,
          idProServicio: widget.idProServicio,
          newImageBytes: imageBytes,
          fileName: fileName,
          finalNameImage: fileName,
        );

        String url = await ProductImagesStorage.cargarImage(image);

        ProServicioImageCreacionTb proServicioCreacionImage =
            ProServicioImageCreacionTb(
          idProServicio: widget.idProServicio,
          nombreImage: fileName,
          urlImage: url,
          width: imageToUpload.width,
          height: imageToUpload.height,
          isPrincipalImage: 0,
        );

        if (fileName == MisRutasFirebase.forProducts) {
          ProservicioImagesTb proServicioImage =
              await ProductImageDb.insertProductImages(
                  proServicioCreacionImage);
          productImagesAux.add(proServicioImage);
        } else if (fileName == MisRutasFirebase.forServicios) {
          ProservicioImagesTb proservicioImage =
              await ServiceImageDb.insertServiceImage(proServicioCreacionImage);
          productImagesAux.add(proservicioImage);
        }
      }

      setState(() {
        if (allProductImages.items.isNotEmpty) {
          allProductImages.items.clear();
        }
        productSecondaryImages = [
          ...productSecondaryImages,
          ...productImagesAux
        ];
        if (allProductImages.items.isEmpty) {
          allProductImages = ImageList(productSecondaryImages);
        } else {
          allProductImages.items.addAll(productSecondaryImages);
        }

        imagesToUpload.clear();
      });
    }
  }

  void updateSecondaryImage(int idUsuario) async {
    if (imagesToUpdate.isNotEmpty) {
      await Future.forEach(imagesToUpdate, (newImage) async {
        String nombreImage = newImage.nombreImage;
        Asset imageToUpdate = newImage.newImage;

        print("LONG IMAGE_: ${imageToUpdate.originalHeight!.toDouble()}");

        ImageStorageTb image = ImageStorageTb(
            idUsuario: idUsuario,
            idFile: widget.idProServicio,
            newImageBytes: await assetToUint8List(imageToUpdate),
            fileName: fileName,
            imageName: nombreImage,
            width: imageToUpdate.originalWidth!.toDouble(),
            height: imageToUpdate.originalHeight!.toDouble(),
            isPrincipalImage: 0);

        String url = await ProductImagesStorage.updateImage(image);
        print('URL image_: $url');
        for (int i = 0; i < productSecondaryImages.length; i++) {
          //Solo entra al if en una ocacion por lo que no hay problema con el setState dentro del ciclo for
          if (productSecondaryImages[i].nombreImage == nombreImage) {
            setState(() {
              productSecondaryImages[i] =
                  productSecondaryImages[i].copyWith(urlImage: url);

              if (allProductImages.items.isNotEmpty) {
                allProductImages.items.clear();
              }
              allProductImages.items.addAll(productSecondaryImages);
            });
            break;
          } else {
            print('No encontrado en updateSecondaryImage');
          }
        }
      });

      setState(() {
        imagesToUpdate.clear();
      });
    } else {
      print('Imagen a actualizar es null');
    }
  }

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

  void agregarImagenes() async {
    List<Asset?> imagesAsset = await getImagesAsset();
    List<ProductImageToUpload> allProductImagesAux = [];

    if (imagesAsset.isNotEmpty) {
      for (var image in imagesAsset) {
        ProductImageToUpload newImage = ProductImageToUpload(
          nombreImage: assingName(image!.name!),
          newImage: image,
          width: image.originalWidth!.toDouble(),
          height: image.originalHeight!.toDouble(),
        );
        allProductImagesAux.add(newImage);
      }
    }

    setState(() {
      allProductImages.items.addAll(allProductImagesAux);

      imagesToUpload = [...imagesToUpload, ...allProductImagesAux];
    });
  }

  /// The function `editarImagenes` is used to edit images by replacing them with new images in a list.
  ///
  /// Args:
  ///   image: The parameter `image` is of type `dynamic` and represents an image object.
  void editarImagenes(final image) async {
    Asset? asset = await getImageAsset();
    if (asset != null) {
      int imageIndex = allProductImages.items.indexOf(image);

      int indice = imagesToUpdate
          .indexWhere((element) => element.nombreImage == image.nombreImage);

      /** Si 'indice' != de -1  es por que ya ha sido cambiada previamente
      * En este caso el objeto ya se encuentra dentro de 'imagesToUpdate' por lo tanto 
       * solo es necesario actualizar "imageToUpdate" respecto a su posicion 'indice' y dejar 
       * "nombreImage" igual ya que este nombre se utiliza para completar la ruta en firebase Storage y actualizar */
      if (indice != -1 || image is ProductImageToUpdate) {
        ProductImageToUpdate newImage = ProductImageToUpdate(
          nombreImage: imagesToUpdate[indice].nombreImage,
          newImage: asset,
        );
        setState(() {
          allProductImages.items[imageIndex] = newImage;
          imagesToUpdate[indice] = newImage;
        });
      } else {
        if (image is ProservicioImagesTb) {
          ProductImageToUpdate newImage = ProductImageToUpdate(
            nombreImage: image.nombreImage,
            newImage: asset,
          );
          setState(() {
            imagesToUpdate.add(newImage);
            allProductImages.items[imageIndex] = newImage;
          });
        } else if (image is ProductImageToUpload) {
          int indiceToUpload = imagesToUpload.indexWhere(
              (element) => element.nombreImage == image.nombreImage);
          ProductImageToUpload newImage = ProductImageToUpload(
            nombreImage: assingName(asset.name!),
            newImage: asset,
            width: asset.originalWidth!.toDouble(),
            height: asset.originalHeight!.toDouble(),
          );

          setState(() {
            allProductImages.items[imageIndex] = newImage;
            imagesToUpload[indiceToUpload] = newImage;
          });
        }
      }
    }
  }

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
                  nombreImagen: image.nombreImage,
                  idProServicio: image.idProServicio,
                );

                bool deleteResult =
                    await ProductImagesStorage.deleteImage(infoImageToDelete);

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
        } else if (image is ProductImageToUpdate ||
            image is ProductImageToUpload) {
          return RuleOut(
            onPress: () {
              int imageIndex = allProductImages.items.indexOf(image);
              /**De la lista de imagenes originales, sacamos la imagen base o imagen que inicialmente habia */

              if (image is ProductImageToUpdate) {
                ProservicioImagesTb oldImage =
                    productSecondaryImages[imageIndex];

                setState(() {
                  allProductImages.items[imageIndex] = oldImage;
                  imagesToUpdate.remove(image);
                });
              } else if (image is ProductImageToUpload) {
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
          return SizedBox.shrink();
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
    int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuario;

    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.grey.shade100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
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
                  Text('Modificar'),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.fromLTRB(16.0,
            //       productSecondaryImages.isNotEmpty ? 0.0 : 20.0, 0.0, 0.0),
            //   child: const Text(
            //     'Descripcion detallada',
            //     style: TextStyle(
            //       fontWeight: FontWeight.w600,
            //       fontSize: 22,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.fromLTRB(
            //       isChecked ? 8.0 : 16, 23.0, isChecked ? 8.0 : 30, 30.0),
            //   child: isChecked
            //       ? GeneralInputs(
            //           verticalPadding: 15.0,
            //           controller: _descripcionDetalldaController,
            //           labelText: 'Agrega una descripcion detalla del producto',
            //           color: Colors.grey.shade200,
            //           keyboardType: TextInputType.multiline,
            //           minLines: 3,
            //           maxLines: 40,
            //         )
            //       : Text(
            //           descripcionDetalladaAux != null &&
            //                   descripcionDetalladaAux!.isNotEmpty
            //               ? descripcionDetalladaAux!
            //               : 'No hay descripcion que mostrar',
            //           style: TextStyle(
            //             color: Colors.grey[800],
            //             fontSize: 16,
            //           ),
            //         ),
            // ),
            allProductImages.items.isNotEmpty
                ? Column(
                    children: [
                      for (var image in allProductImages.items)
                        Column(
                          children: [
                            Container(
                                child: image is ProservicioImagesTb
                                    ? ShowImage(
                                        networkImage: image.urlImage,
                                        //height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : image is ProductImageToUpload ||
                                            image is ProductImageToUpdate
                                        ? FutureBuilder<ByteData>(
                                            future: (() {
                                              if (image
                                                  is ProductImageToUpload) {
                                                return image.newImage
                                                    .getByteData();
                                              } else if (image
                                                  is ProductImageToUpdate) {
                                                return image.newImage
                                                    .getByteData();
                                              }
                                            })(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<ByteData>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                final byteData = snapshot.data!;
                                                final bytes = byteData.buffer
                                                    .asUint8List();
                                                return SizedBox(
                                                  width: double.infinity,
                                                  child: Image.memory(
                                                    bytes,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return const Text(
                                                    'Error al cargar la imagen');
                                              } else {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                            },
                                          )
                                        : SizedBox.shrink()),
                            isChecked
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      createCustomButton(
                                        () {
                                          if (idUsuario != null) {
                                            eliminarImagen(image, idUsuario);
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
                                          editarImagenes(image);
                                        },
                                        'Editar',
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink()
                          ],
                        )
                    ],
                  )
                : Center(
                    child: Text('Aqui puedes agregar imagenes del producto'),
                  ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () async {
                    agregarImagenes();
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
                  if (idUsuario != null) insertProServicioImage(idUsuario);
                  if (idUsuario != null) {
                    updateSecondaryImage(idUsuario);
                  }
                  updateDescripcionDetallada();
                }),
          ],
        ),
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

class SummaryReviews extends StatefulWidget {
  const SummaryReviews({
    super.key,
    required this.idProServicio,
    required this.objectType,
  });

  final int idProServicio;
  final Type objectType;

  @override
  State<SummaryReviews> createState() => _SummaryReviewsState();
}

class _SummaryReviewsState extends State<SummaryReviews> {
  void navigateToReviewsAndOpinions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewsAndOpinions(
          idProServicio: widget.idProServicio,
          objectType: widget.objectType,
        ),
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
            color: Colors.grey.shade200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 17.0, 0.0),
              child: TextButton(
                onPressed: navigateToReviewsAndOpinions,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Calificaciones y opiniones',
                      style: TextStyle(color: color, fontSize: 18),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      size: 26,
                    ),
                  ],
                ),
              ),
            ),
            Comments(
              idProServicio: widget.idProServicio,
              selectIndex: 0,
              maxCommentsToShow: 3,
              paddingOutsideHorizontal: 5.0,
              paddingOutsideVertical: 0.0,
              containerPadding: 10.0,
              //color: Colors.grey[300],
              minLines: 3,
              fontSizeDescription: 16,
              fontSizeName: 17,
              fontSizeStarts: 21,
              objectType: widget.objectType,
            ),
            Center(
              child: GlobalTextButton(
                onPressed: navigateToReviewsAndOpinions,
                textButton: 'Todas las calificaciones',
                color: color,
                fontSizeTextButton: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductosRelacionados extends StatefulWidget {
  const ProductosRelacionados({super.key, required this.proServicios});

  final List<dynamic> proServicios;

  @override
  State<ProductosRelacionados> createState() => _ProductosRelacionadosState();
}

class _ProductosRelacionadosState extends State<ProductosRelacionados> {
  @override
  void initState() {
    super.initState();

    //print(widget.productos);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        //child: RowProducts(productos: widget.productos),
        child: Text('Llamar a los productos'),
      ),
    );
  }
}

class StaticBottomNavigator extends StatefulWidget {
  const StaticBottomNavigator({super.key});

  @override
  State<StaticBottomNavigator> createState() => _StaticBottomNavigatorState();
}

class _StaticBottomNavigatorState extends State<StaticBottomNavigator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57.0,
      color: Colors.white60,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 0, 7.0, 0.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.store_outlined,
                      color: Colors.black,
                      size: 31,
                    ),
                  ),
                ),
                SizedBox(
                  width: 35.0,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.bubble_right,
                      size: 29,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 13.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: const Text(
                    'Comprar',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 17.5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: Container(
                    width: 55,
                    height: 47,
                    decoration: BoxDecoration(
                      color: Colors.pink[100],
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.cart,
                        color: Colors.pink,
                        size: 27,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
