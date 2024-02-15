import 'dart:async';
import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/crudImages.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/fileTemporal.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/myImageList.dart';
import 'package:etfi_point/Components/Utils/Services/MediaPicker.dart';
import 'package:etfi_point/Components/Utils/Services/editarImagen.dart';
import 'package:etfi_point/Components/Utils/buttonSeleccionarCategorias.dart';
import 'package:etfi_point/Components/Utils/categoriesList.dart';
import 'package:etfi_point/Components/Utils/divider.dart';
import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Components/Utils/individualProduct.dart';
import 'package:etfi_point/Components/providers/categoriasProvider.dart';
import 'package:etfi_point/Screens/proServicios/sectionTitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProductoGeneralForm extends StatefulWidget {
  const ProductoGeneralForm({super.key, this.producto});

  final ProductoTb? producto;

  @override
  State<ProductoGeneralForm> createState() => _ProductoGeneralFormState();
}

class _ProductoGeneralFormState extends State<ProductoGeneralForm> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  int pageController = 1;

  // variables for first page
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  // variables for second page

  ImageList myImageList = ImageList([]);
  Asset? principalImage;
  String? urlPrincipalImage;
  Uint8List? principalImageBytes;

  // variables for third page
  List<CategoriaTb> categoriasDisponibles = [];
  List<SubCategoriaTb> categoriasSeleccionadas = [];

  double textToDouble() {
    try {
      String text = _priceController.text;
      double price = double.parse(text);
      return price;
    } catch (e) {
      print('Error: $e');
      return 0.0;
    }
  }

  Future<void> selectImages() async {
    List<ProServicioImageToUpload> selectedImagesAux =
        await CrudImages.agregarImagenes();

    setState(() {
      myImageList.items.addAll(selectedImagesAux);
    });
    if (widget.producto?.idProducto == null && selectedImagesAux.isNotEmpty) {
      if (principalImage == null) {
        setState(() {
          principalImage = selectedImagesAux[0].newImage;
        });
      }
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
              const Text("Nuevo producto"),
              GlobalTextButton(
                textButton: "Siguiente",
                fontSizeTextButton: 17,
                letterSpacing: 0.3,
                onPressed: () async {
                  if (pageController == 1 && myImageList.items.isEmpty) {
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return const Center(
                    //       child: CircularProgressIndicator(),
                    //     );
                    //   },
                    //   barrierDismissible: false,
                    // );

                    // Timer(const Duration(milliseconds: 200), () async {
                    //   await selectImages();
                    //   if (mounted) {
                    //     Navigator.of(context).pop();
                    //   }
                    // });
                  }

                  setState(() {
                    if (pageController >= 1 && pageController <= 3) {
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
                  nameController: _nameController,
                  precioController: _priceController,
                  discountController: _discountController,
                  descripcionController: _descripcionController,
                  focusScopeNode: _focusScopeNode,
                ),
              )
            : pageController == 2
                ? SelectImages(
                    myImageList: myImageList,
                    principalImage: principalImage,
                    urlPrincipalImage: urlPrincipalImage,
                    principalImageBytes: principalImageBytes,
                    onUpdatedImages: ({
                      Asset? newPrincipalImage,
                      String? newUrlPrincipalImage,
                      Uint8List? newPrincipalImageBytes,
                    }) {
                      setState(() {
                        principalImage = newPrincipalImage;
                        urlPrincipalImage = newUrlPrincipalImage;
                        principalImageBytes = newPrincipalImageBytes;
                      });
                    },
                    onSelectedImageList:
                        (List<ProServicioImageToUpload> newImageList) {
                      setState(() {
                        myImageList.items.addAll(newImageList);
                      });
                    },
                    nombreProducto: _nameController.text,
                    precioProducto: textToDouble(),
                    descuentoProducto: _discountController.text,
                  )
                : pageController == 3
                    ? SelectCategories(
                        url: MisRutas.rutaCategorias2,
                      )
                    : SizedBox.shrink(),
      ),
    );
  }
}

class SelectCategories extends ConsumerStatefulWidget {
  const SelectCategories({
    super.key,
    required this.url,
  });

  final String url;

  @override
  SelectCategoriesState createState() => SelectCategoriesState();
}

class SelectCategoriesState extends ConsumerState<SelectCategories> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allCategories = ref.watch(getAllCategoriasProvider(widget.url));

    return Column(
      children: [
        const SectionTitle(title: "Categorias seleccionadas"),
        allCategories.when(
          data: (categoriasDisponibles) => ButtonSeleccionarCategorias(
            categoriasDisponibles: categoriasDisponibles,
          ),
          error: (_, __) => const Text('No se pudieron cargar las categorias'),
          loading: () => const CircularProgressIndicator(),
        )
      ],
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
  });

  final TextEditingController nameController;
  final TextEditingController precioController;
  final TextEditingController discountController;
  final TextEditingController descripcionController;
  final FocusScopeNode focusScopeNode;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool enOferta = false;

  @override
  Widget build(BuildContext context) {
    double horizontalPaddgin = 18.0;
    double verticalPaddgin = 20.0;
    double mediumPadding = 6.0;

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
                title: "Detalle de producto"),
            Padding(
              padding: EdgeInsets.only(bottom: verticalPaddgin * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: horizontalPaddgin),
                    child: const Text(
                      "¿Producto en oferta?",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: Colors.blue,
                    trackColor: Colors.grey.shade300,
                    value: enOferta,
                    onChanged: (value) {
                      setState(() {
                        enOferta = value;
                      });
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
                  enOferta
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
                  enOferta
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
            enOferta
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

class SelectImages extends StatefulWidget {
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

  @override
  State<SelectImages> createState() => _SelectImagesState();
}

class _SelectImagesState extends State<SelectImages> {
  // @override
  // void initState() {
  //   super.initState();

  //   checkIfImagesExist();
  // }

  // void checkIfImagesExist() async {
  //   if (widget.myImageList.items.isEmpty) {
  //     selectImages();
  //   }
  // }

  void selectImages() async {
    List<ProServicioImageToUpload> selectedImagesAux =
        await CrudImages.agregarImagenes();
    widget.onSelectedImageList(selectedImagesAux);
    if (widget.idProducto == null && selectedImagesAux.isNotEmpty) {
      if (widget.principalImage == null) {
        widget.onUpdatedImages(
          newPrincipalImage: selectedImagesAux[0].newImage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Asset? principalImage = widget.principalImage;
    String? urlPrincipalImage = widget.urlPrincipalImage;
    Uint8List? principalImageBytes = widget.principalImageBytes;
    double horizontalPadding = 18.0;
    double verticalPadding = 20.0;
    ImageList myImageList = widget.myImageList;

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
                      widget.onUpdatedImages(newPrincipalImageBytes: null);
                    }
                    if (selectedImage is Asset) {
                      widget.onUpdatedImages(
                        newPrincipalImage: selectedImage,
                        newUrlPrincipalImage: null,
                      );
                    } else if (selectedImage is String) {
                      widget.onUpdatedImages(
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
                // ShowSampleAnyImage(
                //   urlImage: urlPrincipalImage,
                //   imageBytes: principalImageBytes,
                //   imageAsset: principalImage,
                // ),
                Padding(
                  padding: EdgeInsets.only(left: horizontalPadding * 2),
                  child: IndividualProduct(
                    urlImage: urlPrincipalImage,
                    imageAsset: principalImage,
                    imageBytes: principalImageBytes,
                    precio: widget.precioProducto,
                    oferta: 0,
                    descuento: 0,
                    nombre: widget.nombreProducto,
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
                      widget.onUpdatedImages(
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
                      widget.onUpdatedImages(
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

class ArrowTextButton extends StatelessWidget {
  const ArrowTextButton({
    super.key,
    required this.textButton,
    required this.onTap,
    this.fontSizeTextButton,
    this.fontWeightTextButton,
    this.horizontalPaggin,
    this.paddingTop,
    this.paddingBottom,
    this.color,
  });

  final String textButton;
  final VoidCallback onTap;
  final double? fontSizeTextButton;
  final FontWeight? fontWeightTextButton;
  final double? horizontalPaggin;
  final double? paddingTop;
  final double? paddingBottom;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPaggin ?? 0.0,
        paddingTop ?? 0.0,
        horizontalPaggin ?? 0.0,
        paddingBottom ?? 0.0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GlobalTextButton(
              textButton: textButton,
              fontSizeTextButton: fontSizeTextButton ?? 18,
              fontWeightTextButton: fontWeightTextButton ?? FontWeight.w500,
              color: color ?? Colors.grey.shade800,
            ),
            const Icon(
              CupertinoIcons.chevron_forward,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
