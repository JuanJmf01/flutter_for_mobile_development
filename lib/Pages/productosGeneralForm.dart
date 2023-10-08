import 'dart:io';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/negocioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Firebase/Storage/productImagesStorage.dart';
import 'package:etfi_point/Components/Utils/AssetToUint8List.dart';
import 'package:etfi_point/Components/Utils/ElevatedGlobalButton.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/myImageList.dart';
import 'package:etfi_point/Components/Utils/IndividualProduct.dart';
import 'package:etfi_point/Components/Utils/Providers/subCategoriaSeleccionadaProvider.dart';
import 'package:etfi_point/Components/Utils/Services/assingName.dart';
import 'package:etfi_point/Components/Utils/Services/selectImage.dart';
import 'package:etfi_point/Components/Utils/buttonSeleccionarCategorias.dart';
import 'package:etfi_point/Components/Utils/categoriesList.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/Components/Utils/divider.dart';
import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
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

  ProductSample? productSample;

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
    obtenerCategorias();

    if (widget.data != null) {
      _producto = widget.data;
    }
  }


  void getListSecondaryProductImages() async {
    int? idProducto = widget.data?.idProducto;
    if (idProducto != null) {
      List<ProductImagesTb> productSecondaryImagesAux =
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

  void obtenerCategorias() async {
    print("ENTRA PRIMERO AQUI");
    int? idProducto = widget.data?.idProducto;

    await context
        .read<SubCategoriaSeleccionadaProvider>()
        .obtenerAllSubCategorias();

    if (idProducto != null) {
      await context
          .read<SubCategoriaSeleccionadaProvider>()
          .obtenerSubCategoriasSeleccionadas(idProducto);
    }
  }

  Future<int> crearNegocioSiNoExiste(idUsuario) async {
    int idNegocio = 0;
    //-- Se crea un negocio en caso de que no exista. Si existe, se asigna el valor idNegocio en _producto a ser creado
    // En caso de que no exista 'idNegocioIfExists' sera igual a null por lo tanto se creara un nuevo negocio con 'idUsuario';
    NegocioTb? negocio = await NegocioDb.getNegocio(idUsuario);
    if (negocio?.idNegocio == null) {
      NegocioCreacionTb negocio = NegocioCreacionTb(
        idUsuario: idUsuario,
      );
      idNegocio = await NegocioDb.insertNegocio(negocio);
    } else {
      idNegocio = negocio!.idNegocio;
    }

    return idNegocio;
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
      File urlImageInFile = await convertToTempFile();
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

  void agregarImagenes() async {
    List<Asset?> imagesAsset = await getImagesAsset();

    List<ProductImageToUpload> selectedImagesAux = [];

    if (imagesAsset.isNotEmpty) {
      for (var image in imagesAsset) {
        ProductImageToUpload selectedImage = ProductImageToUpload(
          nombreImage: assingName(image!.name!),
          newImage: image,
          width: image.originalWidth!.toDouble(),
          height: image.originalHeight!.toDouble(),
        );

        selectedImagesAux.add(selectedImage);
      }

      setState(() {
        myImageList.items.addAll(selectedImagesAux);
        if (principalImage == null && widget.data?.idProducto == null) {
          principalImage ??= imagesAsset[0];
        }
      });
    }

    print('Imagenes seleccionadas3: $imagesAsset');
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

  //  Convertir Asset o URLimage (image.network) a Archivo temporal
  Future<File> convertToTempFile() async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp_image.jpg');

    if (urlPrincipalImage != null) {
      // Descargar la imagen de la URL y guardarla en el archivo temporal
      final response = await Dio().get(urlPrincipalImage!,
          options: Options(responseType: ResponseType.bytes));
      await tempFile.writeAsBytes(response.data);
    } else if (principalImage != null) {
      final byteData = await principalImage!.getByteData();
      final buffer = byteData.buffer.asUint8List();
      await tempFile.writeAsBytes(buffer);
    }

    print('Temporal $tempFile');
    editImage(tempFile);

    return tempFile;
  }

  Future<void> editImage(File tempFile) async {
    if (principalImage != null || urlPrincipalImage != null) {
      // 2. Editar Archivo temporal
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: tempFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );

      if (croppedFile != null) {
        final croppedBytes = await croppedFile.readAsBytes();

        setState(() {
          principalImageBytes = Uint8List.fromList(croppedBytes);
        });
      }
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
                                onPressed: agregarImagenes,
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
                            urlPrincipalImage != null &&
                                    principalImageBytes == null
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        45.0, 00.0, 0.0, 20.0),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: IndividualProductSample(
                                          urlImage: urlPrincipalImage,
                                          widthImage: 195.0,
                                          heightImage: 170.0),
                                    ),
                                  )
                                : principalImageBytes != null
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            45.0, 00.0, 0.0, 20.0),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: IndividualProductSample(
                                              imageBytes: principalImageBytes!,
                                              widthImage: 195.0,
                                              heightImage: 170.0),
                                        ),
                                      )
                                    : FutureBuilder<ByteData>(
                                        future: principalImage!.getByteData(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<ByteData> snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.data != null) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      45.0, 00.0, 0.0, 20.0),
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: IndividualProductSample(
                                                    imageBytes: snapshot
                                                        .data!.buffer
                                                        .asUint8List(),
                                                    widthImage: 195.0,
                                                    heightImage: 170.0),
                                              ),
                                            );
                                          } else {
                                            return CircularProgressIndicator(); // Mostrar un indicador de carga mientras se obtienen los datos de la imagen
                                          }
                                        },
                                      ),
                            Row(
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      convertToTempFile();
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

                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: GlobalDivider(),
                      ),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 12.0, 25.0, 0.0),
                            child: Text(
                              'Categorias',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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

                      ElevatedGlobalButton(
                        nameSavebutton: 'Seleccionar categorias',
                        onPress: () {
                          print("ALLCATEGORIES_: $categoriasDisponibles");
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) =>
                                ButtonSeleccionarCategorias(
                              categoriasDisponibles: categoriasDisponibles,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                          );
                        },
                        heightSizeBox: 52,
                        widthSizeBox: double.infinity,
                        borderRadius: BorderRadius.circular(30.0),
                        backgroundColor: Colors.blue.withOpacity(0.06),
                        paddingRight: 20.0,
                        paddingLeft: 20.0,
                        borderSideColor: Colors.blue,
                        colorNameSaveButton: Colors.blue,
                        widthBorderSide: 3.0,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        //color: Colors.blue.withOpacity(0.2),
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
                    int idNegocio = await crearNegocioSiNoExiste(idUsuario);

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
