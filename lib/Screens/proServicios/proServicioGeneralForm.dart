import 'dart:io';

import 'package:etfi_point/Data/models/proServicioImagesTb.dart';
import 'package:etfi_point/Data/models/productoTb.dart';
import 'package:etfi_point/Data/models/servicioTb.dart';
import 'package:etfi_point/Data/models/subCategoriaTb.dart';
import 'package:etfi_point/Data/services/api/subCategoriasDb.dart';
import 'package:etfi_point/components/widgets/ImagesUtils/crudImages.dart';
import 'package:etfi_point/components/widgets/ImagesUtils/fileTemporal.dart';
import 'package:etfi_point/components/widgets/ImagesUtils/myImageList.dart';
import 'package:etfi_point/components/utils/MediaPicker.dart';
import 'package:etfi_point/components/utils/editarImagen.dart';
import 'package:etfi_point/components/utils/randomServices.dart';
import 'package:etfi_point/components/widgets/arrowTextButton.dart';
import 'package:etfi_point/components/widgets/generalInputs.dart';
import 'package:etfi_point/components/widgets/globalTextButton.dart';
import 'package:etfi_point/Screens/proServicios/selectCategories.dart';
import 'package:etfi_point/components/widgets/divider.dart';
import 'package:etfi_point/components/widgets/individualProduct.dart';
import 'package:etfi_point/Data/services/providers/categoriasProvider.dart';
import 'package:etfi_point/Screens/proServicios/sectionTitle.dart';
import 'package:etfi_point/config/routes/routes.dart';
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
    required this.proServiceObjectType,
    this.urlSubCategories,
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
  final Type proServiceObjectType;
  final String? urlSubCategories;
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
  bool handleSubCategoryUpdates = false;

  @override
  void initState() {
    super.initState();
  }

  String definePrincipalName(bool isCamelCase) {
    Type objectType = widget.proServiceObjectType;
    return (isCamelCase ? objectType == ProductoTb : objectType == ServicioTb)
        ? (isCamelCase ? 'Producto' : 'producto')
        : (isCamelCase ? 'Servicio' : 'servicio');
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
              Text("Nuevo ${definePrincipalName(true)}"),
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
                  } else if (pageController == 2 &&
                      widget.urlSubCategories != null &&
                      !handleSubCategoryUpdates) {
                    List<SubCategoriaTb> selectedSubCategorias =
                        await SubCategoriasDb.getSubCategoriasByProducto(
                            widget.urlSubCategories!);

                    ref
                        .read(subCategoriasSelectedProvider.notifier)
                        .update((state) => selectedSubCategorias);

                    setState(() {
                      handleSubCategoryUpdates = true;
                    });
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
                  onUpdatedOffert: (bool newIsOffert) {
                    widget.onUpDateOffert(newIsOffert);
                  },
                  proServiceObjectType: widget.proServiceObjectType,
                ),
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
                    precioProducto: RandomServices.textToDouble(
                        widget.priceController.text),
                    isOffert: widget.isOffert,
                    discount: widget.discountController.text,
                    nameProServicio: definePrincipalName(false),
                  )
                : pageController == 3
                    ? CategorySelectionInterface(
                        urlCategorias: MisRutas.rutaCategorias2,
                        //urlSubCategories: widget.urlSubCategories,
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
    required this.onUpdatedOffert,
    required this.proServiceObjectType,
  });

  final TextEditingController nameController;
  final TextEditingController precioController;
  final TextEditingController discountController;
  final TextEditingController descripcionController;
  final FocusScopeNode focusScopeNode;
  final bool isOffert;
  final Type proServiceObjectType;

  final Function(bool) onUpdatedOffert;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final TextEditingController _precioAhoraController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _precioAhoraController.text = widget.precioController.text;
  }

  void priceWithDiscount(double precioValue, int discountValue) {
    final precioAhora = precioValue * (1 - (discountValue / 100));
    _precioAhoraController.text = precioAhora.toString();
  }

  String definePrincipalName(bool isCamelCase) {
    Type objectType = widget.proServiceObjectType;

    return (objectType == ProductoTb)
        ? (isCamelCase ? 'Producto' : 'producto')
        : objectType == ServicioTb
            ? (isCamelCase ? 'Servicio' : 'servicio')
            : 'Pro-Servicio';
  }

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
                title: "Detalle de ${definePrincipalName(false)}"),
            Padding(
              padding: EdgeInsets.only(bottom: verticalPaddgin * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: horizontalPaddgin),
                    child: Text(
                      "¿${definePrincipalName(true)} en oferta?",
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
                          child: priceInput(
                            borderInput,
                            EdgeInsets.only(right: mediumPadding),
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: priceInput(
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
                            onChanged: (descuento) {
                              final priceValue = RandomServices.textToDouble(
                                  widget.precioController.text);
                              final discountValue =
                                  int.tryParse(descuento ?? '0') ?? 0;

                              priceWithDiscount(priceValue, discountValue);
                            },
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
                          controller: _precioAhoraController,
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

  Widget priceInput(BoxBorder borderInput, EdgeInsets padding) {
    return GeneralInputs(
      controller: widget.precioController,
      textLabelOutside: 'Precio',
      labelText: '\$  ',
      keyboardType: TextInputType.number,
      borderInput: borderInput,
      padding: padding,
      onChanged: (precio) {
        final precioValue = RandomServices.textToDouble(precio ?? '0.0');
        final discountValue = int.tryParse(widget.discountController.text) ?? 0;
        priceWithDiscount(precioValue, discountValue);
      },
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
    required this.isOffert,
    this.discount,
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
  final bool isOffert;
  final String? discount;
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
                    oferta: isOffert ? 1 : 0,
                    descuento: RandomServices.textToInt(discount ?? '0'),
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
    required this.urlCategorias,
    //this.urlSubCategories,
    this.idProduct,
  });

  final String urlCategorias;
  //final String? urlSubCategories;
  final int? idProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCategories = ref.watch(getAllCategoriasProvider(urlCategorias));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: allCategories.when(
        data: (categoriasDisponibles) => SelectCategories(
          categoriasDisponibles: categoriasDisponibles,
          //urlSubCategories: urlSubCategories,
        ),
        error: (_, __) => const Text('No se pudieron cargar las categorias'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
