import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Firebase/Storage/productImagesStorage.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:etfi_point/Components/Utils/AssetToUint8List.dart';
import 'package:etfi_point/Components/Utils/ElevatedGlobalButton.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/crudImages.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/editarImagen.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/fileTemporal.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/myImageList.dart';
import 'package:etfi_point/Components/Utils/Providers/subCategoriaSeleccionadaProvider.dart';
import 'package:etfi_point/Components/Utils/Services/selectImage.dart';
import 'package:etfi_point/Components/Utils/categoriesList.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/Components/Utils/divider.dart';
import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Components/Utils/showSampletAnyImage.dart';
import 'package:etfi_point/Pages/proServicios/buttonSeleccionarCategorias.dart';
import 'package:etfi_point/Pages/proServicios/sectionTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class ProductosGeneralForm extends StatefulWidget {
  const ProductosGeneralForm({
    super.key,
    this.data,
    this.exitoTitle,
    required this.titulo,
    required this.nameSavebutton,
    required this.exitoMessage,
  });

  final ProductoTb? data;
  final String titulo;
  final String nameSavebutton;
  final String? exitoTitle;
  final String exitoMessage;

  @override
  State<ProductosGeneralForm> createState() => _ProductosGeneralFormState();
}

class _ProductosGeneralFormState extends State<ProductosGeneralForm> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _cantidadDisponibleController =
      TextEditingController();

  CategoriaTb? categoriaSeleccionada;
  List<CategoriaTb> categoriasDisponibles = [];
  List<SubCategoriaTb> categoriasSeleccionadas = [];

  String? urlPrincipalImage;

  int? enOferta = 0;
  bool isChecked = false;

  ProductoTb? _producto;

  ImageList myImageList = ImageList([]);
  Asset? principalImage;
  Uint8List? principalImageBytes;

  @override
  void initState() {
    super.initState();

    ProductoTb? producto = widget.data;
    if (producto?.idProducto != null) {
      print('dataUpdat_: ${widget.data}');

      _nombreController.text = producto!.nombreProducto;
      _precioController.text = (producto.precio).toStringAsFixed(0);
      _descripcionController.text = producto.descripcion ?? '';
      _cantidadDisponibleController.text =
          producto.cantidadDisponible.toString();

      urlPrincipalImage = producto.urlImage;

      enOferta = producto.oferta;

      getListSecondaryProductImages();
      estaEnOferta();
    }
    String url = MisRutas.rutaCategorias2;

    CategoriaDb.obtenerCategorias(
        idProducto: producto?.idProducto, context: context, url: url);

    if (widget.data != null) {
      _producto = widget.data;
    }
  }

  void getListSecondaryProductImages() async {
    int? idProducto = widget.data?.idProducto;
    if (idProducto != null) {
      List<ProservicioImagesTb> productSecondaryImagesAux =
          await ProductImageDb.getProductSecondaryImages(idProducto);

      setState(() {
        //productSecondaryImages = productSecondaryImagesAux;
        myImageList.items.addAll(productSecondaryImagesAux);

        print('Mi lista de imagenes: $myImageList');
      });
    }
  }

  void estaEnOferta() {
    enOferta == 1
        ? isChecked = true
        : enOferta == 0
            ? isChecked = false
            : isChecked = false;
  }

  Future<int> crearProducto(ProductoCreacionTb producto, int idUsuario) async {
    int idProducto = 0;
    try {
      idProducto =
          await ProductoDb.insertProducto(producto, categoriasSeleccionadas);

      if (principalImageBytes != null || principalImage != null) {
        ImageStorageTb image = ImageStorageTb(
          idUsuario: idUsuario,
          idFile: idProducto,
          newImageBytes:
              principalImageBytes ?? await assetToUint8List(principalImage!),
          imageName: principalImage!.name!,
          fileName: 'productos',
          width: principalImage!.originalWidth!.toDouble(),
          height: principalImage!.originalHeight!.toDouble(),
          isPrincipalImage: 1,
        );

        await ProductImagesStorage.cargarImage(image);
      }

      if (myImageList.items.isNotEmpty) {
        for (var imagen in myImageList.items) {
          if (imagen is ProductImageToUpload) {
            Uint8List imageBytes = await assetToUint8List(imagen.newImage);

            ImageStorageTb image = ImageStorageTb(
                idUsuario: idUsuario,
                idFile: idProducto,
                newImageBytes: imageBytes,
                imageName: imagen.nombreImage,
                fileName: 'productos',
                width: imagen.width,
                height: imagen.height,
                isPrincipalImage: 0);

            await ProductImagesStorage.cargarImage(image);
          }
        }
      }

      mostrarCuadroExito(idProducto);
    } catch (error) {
      print('Problemas al insertar el producto $error');
    }

    return idProducto;
  }

  void actualizarProducto(ProductoTb producto, int idUsuario) async {
    int idProducto = producto.idProducto;

    if (urlPrincipalImage != null) {
      File urlImageInFile = await FileTemporal.convertToTempFile(
          urlImage: urlPrincipalImage, image: principalImage);
      Uint8List principalImageBytesAux = await urlImageInFile.readAsBytes();
      setState(() {
        principalImageBytes = principalImageBytesAux;
      });
    }

    if (principalImageBytes != null || principalImage != null) {
      ImageStorageTb image = ImageStorageTb(
          idUsuario: idUsuario,
          idFile: idProducto,
          newImageBytes:
              principalImageBytes ?? await assetToUint8List(principalImage!),
          fileName: 'productos',
          imageName: producto.nombreImage,
          width: 195.0,
          height: 170.0,
          isPrincipalImage: 1);

      await ProductImagesStorage.updateImage(image);
    } else {
      print('Imagen a actualizar es null');
    }
    try {
      await ProductoDb.updateProducto(producto, categoriasSeleccionadas);
      mostrarCuadroExito(idProducto);
    } catch (error) {
      print('Problemas al actualizar el producto $error');
    }
  }

  //Recibimos idProducto para enviarlo a la pagina anterior y poder renderizar un solo producto y no toda la pestaña
  void mostrarCuadroExito(int idProducto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          titulo: widget.exitoTitle,
          message: widget.exitoMessage,
          onAccept: () {
            print('agregado');
            Navigator.of(context).pop();
          },
          // onAccept: () {
          //   Navigator.of(context).pop();
          //   if (_producto?.idProducto != null) {
          //     Navigator.pop(context, idProducto);
          //   } else {
          //     Navigator.pop(context, idProducto);
          //   }
          // },
          onAcceptMessage: 'Cerrar y volver',
        );
      },
    );
  }

  void agregarDesdeGaleria() async {
    Asset? imagesAsset = await getImageAsset();

    if (imagesAsset != null) {
      setState(() {
        principalImage = imagesAsset;
        urlPrincipalImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isUserSignedIn = context.watch<LoginProvider>().isUserSignedIn;
    int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuario;

    categoriasSeleccionadas =
        Provider.of<SubCategoriaSeleccionadaProvider>(context)
            .subCategoriasSeleccionadas;
    categoriasDisponibles =
        Provider.of<SubCategoriaSeleccionadaProvider>(context).allSubCategorias;

    Color colorTextField = Colors.white;
    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(240, 245, 251, 1.0),
            iconTheme: IconThemeData(color: Colors.black, size: 30),
            toolbarHeight: 60,
            title: Text(
              widget.titulo,
              style: TextStyle(color: Colors.black),
            )),
        backgroundColor: Color.fromRGBO(240, 245, 251, 1.0),
        body: Column(
          children: [
            Expanded(
              child: FocusScope(
                node: _focusScopeNode,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Checked button
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 0.0),
                          child: ElevatedGlobalButton(
                            nameSavebutton: '¿Producto en oferta?',
                            borderSideColor:
                                !isChecked ? Colors.grey : Colors.transparent,
                            onPress: () {
                              setState(() {
                                isChecked = !isChecked;
                                enOferta = isChecked ? 1 : 0;
                              });
                            },
                            backgroundColor:
                                isChecked ? Colors.blue : Colors.white,
                            colorNameSaveButton:
                                isChecked ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(17.0),
                            //borderSideColor: Colors.grey
                            fontSize: 16,
                          ),
                        ),
                      ),
                      myImageList.items.isNotEmpty
                          ? MyImageList(
                              imageList: myImageList,
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 30.0, 0.0, 0.0),
                              maxHeight: 260,
                              principalImage: principalImage,
                              urlPrincipalImage: urlPrincipalImage,
                              onImageSelected: (selectedImage) {
                                setState(() {
                                  if (principalImageBytes != null) {
                                    principalImageBytes = null;
                                  }
                                  if (selectedImage is Asset) {
                                    principalImage = selectedImage;
                                    urlPrincipalImage = null;
                                  } else if (selectedImage is String) {
                                    urlPrincipalImage = selectedImage;
                                    principalImage = null;
                                  }
                                });
                              },
                            )
                          : SizedBox.shrink(),

                      widget.data?.idProducto == null
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: GlobalTextButton(
                                onPressed: () async {
                                  List<ProductImageToUpload> selectedImagesAux =
                                      await CrudImages.agregarImagenes();
                                  setState(() {
                                    myImageList.items.addAll(selectedImagesAux);
                                    if (widget.data?.idProducto == null &&
                                        selectedImagesAux.isNotEmpty) {
                                      principalImage ??= selectedImagesAux[0]
                                          .newImage; //Si 'principalImage' es null, asignar selectedImagesAux[0].newImage
                                    }
                                  });
                                },
                                padding: myImageList.items.isNotEmpty
                                    ? const EdgeInsets.only(
                                        left: 5.0, top: 10.0)
                                    : const EdgeInsets.fromLTRB(
                                        0.0, 40.0, 20.0, 0.0),
                                fontWeightTextButton: FontWeight.w700,
                                letterSpacing: 0.7,
                                fontSizeTextButton: 17.5,
                                textButton: 'Agregar imagen(es)',
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.only(bottom: 20.0)),

                      if (principalImage != null || urlPrincipalImage != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalDivider(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 25.0, 0.0, 10.0),
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
                              urlImage: urlPrincipalImage,
                              imageBytes: principalImageBytes,
                              imageAsset: principalImage,
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      File tempFile =
                                          await FileTemporal.convertToTempFile(
                                              urlImage: urlPrincipalImage,
                                              image: principalImage);
                                      Uint8List? croppedBytes =
                                          await EditarImagen.editImage(tempFile,
                                              urlImage: urlPrincipalImage,
                                              imageAset: principalImage);

                                      setState(() {
                                        if (croppedBytes != null) {
                                          principalImageBytes =
                                              Uint8List.fromList(croppedBytes);
                                        }
                                      });
                                    },
                                    child: Text('Editar')),
                                ElevatedButton(
                                    onPressed: () {
                                      agregarDesdeGaleria();
                                    },
                                    child: Text('Agregar dede galeria')),
                              ],
                            )
                          ],
                        ),

                      const GlobalDivider(),

                      GeneralInputs(
                          controller: _nombreController,
                          horizontalPadding: 16.0,
                          verticalPadding: 15.0,
                          textLabelOutside: 'Nombre',
                          labelText: 'Agrega un nombre',
                          color: colorTextField),
                      GeneralInputs(
                        controller: _precioController,
                        horizontalPadding: 16.0,
                        textLabelOutside: 'Precio',
                        labelText: 'Agrega un precio',
                        color: colorTextField,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                      GeneralInputs(
                        controller: _descripcionController,
                        verticalPadding: 15.0,
                        horizontalPadding: 16.0,
                        textLabelOutside: 'Descripcion',
                        labelText: 'Agrega una descripción',
                        color: colorTextField,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                      ),

                      GeneralInputs(
                        controller: _cantidadDisponibleController,
                        horizontalPadding: 16.0,
                        textLabelOutside: 'Cantidad',
                        labelText: 'Agrega una cantidad disponible',
                        color: colorTextField,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),

                      const GlobalDivider(
                        padding: EdgeInsets.only(top: 20.0),
                      ),

                      const SectionTitle(
                        title: "Categorias",
                        padding: EdgeInsets.fromLTRB(0.0, 12.0, 25.0, 0.0),
                      ),

                      //Categorias seleccionadas
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(35.0, 20.0, 20.0, 25.0),
                          child: CategoriesList(
                            onlyShow: false,
                            elementos: categoriasSeleccionadas,
                            marginContainer: const EdgeInsets.all(5.0),
                            paddingContainer: const EdgeInsets.all(12.0),
                          )),

                      ButtonSeleccionarCategoriasProServicios(
                        categoriasDisponibles: categoriasDisponibles,
                      ),
                      const SizedBox(height: 100.0)
                    ],
                  ),
                ),
              ),
            ),
            if (isUserSignedIn)
              ElevatedGlobalButton(
                  nameSavebutton: widget.nameSavebutton,
                  widthSizeBox: double.infinity,
                  heightSizeBox: 50.0,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  onPress: () async {
                    //--- Se asigna cada String de los campso de texto a una variable ---//
                    final nombreProducto = _nombreController.text;
                    double precio =
                        double.tryParse(_precioController.text) ?? 0.0;
                    final descripcion = _descripcionController.text;
                    int cantidadDisponible =
                        int.tryParse(_cantidadDisponibleController.text) ?? 0;

                    ProductoCreacionTb productoCreacion;
                    int idNegocio =
                        await NegocioDb.crearNegocioSiNoExiste(idUsuario);

                    print('producto_:: ${widget.data?.idProducto}');
                    if (widget.data?.idProducto == null) {
                      //-- Creamos el producto --//
                      productoCreacion = ProductoCreacionTb(
                          idNegocio: idNegocio,
                          nombreProducto: nombreProducto,
                          precio: precio,
                          descripcion: descripcion,
                          cantidadDisponible: cantidadDisponible,
                          oferta: enOferta);

                      myImageList.items.isNotEmpty && idUsuario != null
                          ? crearProducto(productoCreacion, idUsuario)
                          : print('imagenToUpload es null o idUsuario es null');
                    } else {
                      //Actualizar ya que idProducto != null
                      _producto = ProductoTb(
                        idProducto: widget.data!.idProducto,
                        idNegocio: widget.data!.idNegocio,
                        nombreProducto: nombreProducto,
                        precio: precio,
                        descripcion: descripcion,
                        cantidadDisponible: cantidadDisponible,
                        oferta: enOferta,
                        urlImage: widget.data!.urlImage,
                        nombreImage: widget.data!.nombreImage,
                      );

                      idUsuario != null
                          ? actualizarProducto(_producto!, idUsuario)
                          : print('urlImage es null');
                    }
                  })
          ],
        ),
      ),
    );
  }
}
