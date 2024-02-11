import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/crudImages.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/fileTemporal.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/myImageList.dart';
import 'package:etfi_point/Components/Utils/Services/editarImagen.dart';
import 'package:etfi_point/Components/Utils/divider.dart';
import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Components/Utils/showSampletAnyImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProductoGeneralForm extends StatefulWidget {
  const ProductoGeneralForm({Key? key}) : super(key: key);

  @override
  State<ProductoGeneralForm> createState() => _ProductoGeneralFormState();
}

class _ProductoGeneralFormState extends State<ProductoGeneralForm> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  int pageController = 1;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  ImageList myImageList = ImageList([]);
  Asset? principalImage;
  String? urlPrincipalImage;
  Uint8List? principalImageBytes;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
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
                onPressed: () {
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
                  nameController: _nombreController,
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
                  )
                : Text("Ninguna coincide"),
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
            PageTitle(
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
              labelText: 'Nombre',
              borderInput: borderInput,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPaddgin),
              child: Row(
                children: [
                  enOferta
                      ? Expanded(
                          child: DiscountInput(
                            borderInput,
                            EdgeInsets.only(right: mediumPadding),
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: DiscountInput(
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

  Widget DiscountInput(BoxBorder borderInput, EdgeInsets padding) {
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

  @override
  State<SelectImages> createState() => _SelectImagesState();
}

class _SelectImagesState extends State<SelectImages> {
  @override
  Widget build(BuildContext context) {
    Uint8List? principalImageBytes = widget.principalImageBytes;
    double horizontalPadding = 18.0;
    double verticalPadding = 20.0;

    return SingleChildScrollView(
      child: Column(
        children: [
          PageTitle(
            padding: EdgeInsets.only(
              right: horizontalPadding,
              top: verticalPadding / 2,
            ),
            title: "Selección de imagenes",
          ),
          widget.myImageList.items.isNotEmpty
              ? MyImageList(
                  imageList: widget.myImageList,
                  padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                  maxHeight: 260,
                  principalImage: widget.principalImage,
                  urlPrincipalImage: widget.urlPrincipalImage,
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
              : SizedBox.shrink(),
          ArrowTextButton(
            textButton: "Agregar mas imagenes",
            horizontalPaggin: horizontalPadding,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GlobalTextButton(
              onPressed: () async {
                List<ProServicioImageToUpload> selectedImagesAux =
                    await CrudImages.agregarImagenes();
                widget.onSelectedImageList(selectedImagesAux);
                // if (producto?.idProducto == null &&
                //     selectedImagesAux.isNotEmpty) {
                //   if (widget.principalImage == null) {
                //     widget.onUpdatedImages(
                //       newPrincipalImage: selectedImagesAux[0].newImage,
                //     );
                //   }
                // }
              },
              padding: widget.myImageList.items.isNotEmpty
                  ? const EdgeInsets.only(left: .0, top: 10.0)
                  : const EdgeInsets.fromLTRB(0.0, 40.0, 20.0, 0.0),
              fontWeightTextButton: FontWeight.w700,
              letterSpacing: 0.7,
              fontSizeTextButton: 17.5,
              textButton: 'Agregar imagen(es)',
            ),
          ),
          if (widget.principalImage != null || widget.urlPrincipalImage != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalDivider(),
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
                ShowSampleAnyImage(
                  urlImage: widget.urlPrincipalImage,
                  imageBytes: principalImageBytes,
                  imageAsset: widget.principalImage,
                ),
                ArrowTextButton(
                  textButton: "Recortar",
                  horizontalPaggin: horizontalPadding,
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
    this.fontSizeTextButton,
    this.fontWeightTextButton,
    this.horizontalPaggin,
    this.color,
  });

  final String textButton;
  final double? fontSizeTextButton;
  final FontWeight? fontWeightTextButton;
  final double? horizontalPaggin;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPaggin ?? 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GlobalTextButton(
            textButton: textButton,
            fontSizeTextButton: fontSizeTextButton ?? 18,
            fontWeightTextButton: fontWeightTextButton ?? FontWeight.w500,
            color: color ?? Colors.grey.shade800,
          ),
          const Icon(CupertinoIcons.chevron_forward, size: 30,)
        ],
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  const PageTitle({super.key, required this.padding, required this.title});

  final EdgeInsets padding;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
