import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/crudImages.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/fileTemporal.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/myImageList.dart';
import 'package:etfi_point/Components/Utils/Services/MediaPicker.dart';
import 'package:etfi_point/Components/Utils/Services/editarImagen.dart';
import 'package:etfi_point/Components/Utils/arrowTextButton.dart';
import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Screens/proServicios/selectCategories.dart';
import 'package:etfi_point/Components/Utils/divider.dart';
import 'package:etfi_point/Components/Utils/individualProduct.dart';
import 'package:etfi_point/Components/providers/categoriasProvider.dart';
import 'package:etfi_point/Screens/proServicios/sectionTitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProServicioGeneralStructure extends ConsumerStatefulWidget {
  const ProServicioGeneralStructure({
    super.key,
    required this.nameController,
    required this.priceController,
    required this.discountController,
    required this.descriptionController,
    required this.isOffert,
    required this.nameProServicio,
    //
    required this.myImageList,
    this.principalImage,
    this.urlPrincipalImage,
    this.principalImageBytes,
    //
    required this.onUpDateOffert,
    required this.onUpdatedImages,
    required this.onSelectedImageList,
    //
    required this.callbackGuardar,
  });

  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final TextEditingController descriptionController;
  final bool isOffert;
  final String nameProServicio;
  //
  final ImageList myImageList;
  final Asset? principalImage;
  final String? urlPrincipalImage;
  final Uint8List? principalImageBytes;

  //

  final Function(bool) onUpDateOffert;
  final Function(
      {Asset? newPrincipalImage,
      String? newUrlPrincipalImage,
      Uint8List? newPrincipalImageBytes}) onUpdatedImages;
  final Function(List<ProServicioImageToUpload>) onSelectedImageList;
  final VoidCallback callbackGuardar;

  @override
  ProServicioGeneralStructureState createState() =>
      ProServicioGeneralStructureState();
}

class ProServicioGeneralStructureState
    extends ConsumerState<ProServicioGeneralStructure> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  int pageController = 1;

  @override
  void initState() {
    super.initState();

   
  }

  double textToDouble() {
    try {
      String text = widget.priceController.text;
      double price = double.parse(text);
      return price;
    } catch (e) {
      print('Error: $e');
      return 0.0;
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (pageController == 1) {
                Navigator.of(context).pop();
              } else if (pageController > 1 && pageController <= 3) {
                setState(() {
                  pageController -= 1;
                });
              }
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nuevo ${widget.nameProServicio}"),
              GlobalTextButton(
                textButton: pageController != 3 ? "Siguiente" : "Guardar",
                fontSizeTextButton: 17,
                letterSpacing: 0.3,
                onPressed: () async {
                  if (pageController == 1 && widget.myImageList.items.isEmpty) {
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return const Center(
                    //       child: CircularProgressIndicator(),
                    //     );
                    //   },
                    //   barrierDismissible: false,
                    // );

                    // Timer(const Duration(milliseconds: 100), () async {
                    //   await selectImages();
                    //   if (mounted) {
                    //     Navigator.of(context).pop();
                    //   }
                    // });
                  } else if (pageController == 3) {
                    // guardar(idUsuarioActual);
                    widget.callbackGuardar();
                  }

                  setState(() {
                    if (pageController >= 1 && pageController < 3) {
                      pageController += 1;
                    }
                  });
                },
              )
            ],
          ),
        ),
        body: pageController == 1
            ? SingleChildScrollView(
                child: ProductDetail(
                    nameController: widget.nameController,
                    precioController: widget.priceController,
                    discountController: widget.discountController,
                    descripcionController: widget.descriptionController,
                    focusScopeNode: _focusScopeNode,
                    isOffert: widget.isOffert,
                    nameProServicio: widget.nameProServicio,
                    onUpdatedOffert: (bool newIsOffert) {
                      widget.onUpDateOffert(newIsOffert);
                    }),
              )
            : pageController == 2
                ? SelectImages(
                    myImageList: widget.myImageList,
                    principalImage: widget.principalImage,
                    urlPrincipalImage: widget.urlPrincipalImage,
                    principalImageBytes: widget.principalImageBytes,
                    onUpdatedImages: ({
                      Asset? newPrincipalImage,
                      String? newUrlPrincipalImage,
                      Uint8List? newPrincipalImageBytes,
                    }) {
                      widget.onUpdatedImages(
                        newPrincipalImage: newPrincipalImage,
                        newUrlPrincipalImage: newUrlPrincipalImage,
                        newPrincipalImageBytes: newPrincipalImageBytes,
                      );
                    },
                    onSelectedImageList:
                        (List<ProServicioImageToUpload> newImageList) {
                      widget.onSelectedImageList(newImageList);
                    },
                    nombreProducto: widget.nameController.text,
                    precioProducto: textToDouble(),
                    descuentoProducto: widget.discountController.text,
                    nameProServicio: widget.nameProServicio,
                  )
                : pageController == 3
                    ? CategorySelectionInterface(
                        url: MisRutas.rutaCategorias2,
                      )
                    : const SizedBox.shrink(),
      ),
    );
  }
}

class ProductDetail extends StatefulWidget {
  const ProductDetail({
    super.key,
    required this.nameController,
    required this.precioController,
    required this.discountController,
    required this.descripcionController,
    required this.focusScopeNode,
    required this.isOffert,
    required this.nameProServicio,
    required this.onUpdatedOffert,
  });

  final TextEditingController nameController;
  final TextEditingController precioController;
  final TextEditingController discountController;
  final TextEditingController descripcionController;
  final FocusScopeNode focusScopeNode;
  final bool isOffert;
  final String nameProServicio;

  final Function(bool) onUpdatedOffert;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    double horizontalPaddgin = 18.0;
    double verticalPaddgin = 20.0;
    double mediumPadding = 6.0;
    bool isOffert = widget.isOffert;

    Border borderInput = Border.all(width: 1, color: Colors.grey.shade300);
    return FocusScope(
      node: widget.focusScopeNode,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPaddgin),
        child: Column(
          children: [
            SectionTitle(
                padding: EdgeInsets.fromLTRB(
                    0.0, verticalPaddgin / 2, 0.0, verticalPaddgin * 1.5),
                title: "Detalle de ${widget.nameProServicio}"),
            Padding(
              padding: EdgeInsets.only(bottom: verticalPaddgin * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: horizontalPaddgin),
                    child: Text(
                      "¿${widget.nameProServicio} en oferta?",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: Colors.blue,
                    trackColor: Colors.grey.shade300,
                    value: isOffert,
                    onChanged: (value) {
                      widget.onUpdatedOffert(value);
                    },
                  ),
                ],
              ),
            ),
            GeneralInputs(
              controller: widget.nameController,
              textLabelOutside: 'Nombre',
              //labelText: 'Nombre',
              borderInput: borderInput,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPaddgin),
              child: Row(
                children: [
                  isOffert
                      ? Expanded(
                          child: discountInput(
                            borderInput,
                            EdgeInsets.only(right: mediumPadding),
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: discountInput(
                            borderInput,
                            EdgeInsets.only(right: mediumPadding * 4),
                          ),
                        ),
                  isOffert
                      ? Expanded(
                          child: GeneralInputs(
                            controller: widget.discountController,
                            textLabelOutside: 'Descuento',
                            borderInput: borderInput,
                            labelText: '0% - 100%',
                            keyboardType: TextInputType.number,
                            padding: EdgeInsets.only(left: mediumPadding),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            isOffert
                ? Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: GeneralInputs(
                          textLabelOutside: 'Precio ahora',
                          borderInput: borderInput,
                          color: Colors.grey.shade200,
                          enable: false,
                          padding: EdgeInsets.only(
                              right: mediumPadding * 4,
                              bottom: verticalPaddgin),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            GeneralInputs(
              controller: widget.descripcionController,
              textLabelOutside: 'Descripcion',
              borderInput: borderInput,
              labelText: 'Agrega una descripción',
              //color: colorTextField,
              keyboardType: TextInputType.multiline,
              minLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget discountInput(BoxBorder borderInput, EdgeInsets padding) {
    return GeneralInputs(
      controller: widget.precioController,
      textLabelOutside: 'Precio',
      labelText: '\$  ',
      keyboardType: TextInputType.number,
      borderInput: borderInput,
      padding: padding,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
    );
  }
}

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
    required this.nameProServicio,
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
  final String nameProServicio;

  // @override
  void selectImages() async {
    List<ProServicioImageToUpload> selectedImagesAux =
        await CrudImages.agregarImagenes();
    onSelectedImageList(selectedImagesAux);
    if (idProducto == null && selectedImagesAux.isNotEmpty) {
      if (principalImage == null) {
        print("pricipal null");
        onUpdatedImages(
          newPrincipalImage: selectedImagesAux[0].newImage,
        );
      } else {
        print("pricipal no null");
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
                    'La fotografia principal de tu $nameProServicio lucira asi:',
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
      ),
    );
  }
}
