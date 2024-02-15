import 'dart:io';
import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/crudImages.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/fileTemporal.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/myImageList.dart';
import 'package:etfi_point/Components/Utils/Services/MediaPicker.dart';
import 'package:etfi_point/Components/Utils/Services/editarImagen.dart';
import 'package:etfi_point/Components/Utils/arrowTextButton.dart';
import 'package:etfi_point/Screens/proServicios/selectCategories.dart';
import 'package:etfi_point/Components/Utils/divider.dart';
import 'package:etfi_point/Components/Utils/individualProduct.dart';
import 'package:etfi_point/Components/providers/categoriasProvider.dart';
import 'package:etfi_point/Screens/proServicios/sectionTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SelectImages extends StatelessWidget {
  const SelectImages({
    super.key,
    required this.myImageList,
    this.principalImage,
    this.urlPrincipalImage,
    this.principalImageBytes,
    required this.onUpdatedImages,
    required this.onSelectedImageList,
    this.idProducto,
    required this.nombreProducto,
    required this.precioProducto,
    this.descuentoProducto,
  });

  final ImageList myImageList;
  final Asset? principalImage;
  final String? urlPrincipalImage;
  final Uint8List? principalImageBytes;
  final Function(
      {Asset? newPrincipalImage,
      String? newUrlPrincipalImage,
      Uint8List? newPrincipalImageBytes}) onUpdatedImages;
  final Function(List<ProServicioImageToUpload>) onSelectedImageList;
  final int? idProducto;
  final String nombreProducto;
  final double precioProducto;
  final String? descuentoProducto;

  // @override
  void selectImages() async {
    List<ProServicioImageToUpload> selectedImagesAux =
        await CrudImages.agregarImagenes();
    onSelectedImageList(selectedImagesAux);
    if (idProducto == null && selectedImagesAux.isNotEmpty) {
      if (principalImage == null) {
        onUpdatedImages(
          newPrincipalImage: selectedImagesAux[0].newImage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = 18.0;
    double verticalPadding = 20.0;

    return SingleChildScrollView(
      child: Column(
        children: [
          SectionTitle(
            padding: EdgeInsets.only(
              right: horizontalPadding,
              top: verticalPadding / 2,
            ),
            title: "Selección de imagenes",
          ),
          myImageList.items.isNotEmpty
              ? MyImageList(
                  imageList: myImageList,
                  padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                  maxHeight: 260,
                  principalImage: principalImage,
                  urlPrincipalImage: urlPrincipalImage,
                  onImageSelected: (selectedImage) {
                    if (principalImageBytes != null) {
                      onUpdatedImages(newPrincipalImageBytes: null);
                    }
                    if (selectedImage is Asset) {
                      onUpdatedImages(
                        newPrincipalImage: selectedImage,
                        newUrlPrincipalImage: null,
                      );
                    } else if (selectedImage is String) {
                      onUpdatedImages(
                        newUrlPrincipalImage: selectedImage,
                        newPrincipalImage: null,
                      );
                    }
                  },
                )
              : const SizedBox.shrink(),
          ArrowTextButton(
            textButton: myImageList.items.isEmpty
                ? 'Agregar imagenes'
                : 'Agregar mas imagenes',
            horizontalPaggin: horizontalPadding,
            paddingTop: verticalPadding * 1.5,
            paddingBottom: verticalPadding / 4,
            onTap: () => selectImages(),
          ),
          if (principalImage != null || principalImageBytes != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GlobalDivider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 25.0, 0.0, 10.0),
                  child: Text(
                    'La fotografia principal de tu producto lucira asi:',
                    style: TextStyle(
                      fontSize: 17.3,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: horizontalPadding * 2),
                  child: IndividualProduct(
                    urlImage: urlPrincipalImage,
                    imageAsset: principalImage,
                    imageBytes: principalImageBytes,
                    precio: precioProducto,
                    oferta: 0,
                    descuento: 0,
                    nombre: nombreProducto,
                  ),
                ),
                ArrowTextButton(
                  onTap: () async {
                    File tempFile = await FileTemporal.convertToTempFile(
                        urlImage: urlPrincipalImage, image: principalImage);
                    Uint8List? croppedBytes =
                        await EditarImagen.editImage(tempFile, 2.3, 2);
                    if (croppedBytes != null) {
                      print("Entro");
                      onUpdatedImages(
                        newPrincipalImageBytes:
                            Uint8List.fromList(croppedBytes),
                      );
                    }
                  },
                  textButton: "Recortar",
                  horizontalPaggin: horizontalPadding,
                ),
                ArrowTextButton(
                  onTap: () async {
                    Asset? imagesAsset = await getImageAsset();

                    if (imagesAsset != null) {
                      onUpdatedImages(
                        newPrincipalImage: imagesAsset,
                        newUrlPrincipalImage: null,
                      );
                    }
                  },
                  textButton: "Seleccionar otra imagen",
                  horizontalPaggin: horizontalPadding,
                ),
                const SizedBox(
                  height: 80.0,
                )
              ],
            ),
        ],
      ),
    );
  }
}

class CategorySelectionInterface extends ConsumerWidget {
  const CategorySelectionInterface({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCategories = ref.watch(getAllCategoriasProvider(url));

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: allCategories.when(
          data: (categoriasDisponibles) => SelectCategories(
            categoriasDisponibles: categoriasDisponibles,
          ),
          error: (_, __) => const Text('No se pudieron cargar las categorias'),
          loading: () => const CircularProgressIndicator(),
        ));
  }
}
