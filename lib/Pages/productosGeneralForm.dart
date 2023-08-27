import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/negocioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/subCategoriasDb.dart';
import 'package:etfi_point/Components/Data/Firebase/Storage/productImagesStorage.dart';
import 'package:etfi_point/Components/Utils/AssetToUint8List.dart';
import 'package:etfi_point/Components/Utils/ElevatedGlobalButton.dart';
import 'package:etfi_point/Components/Utils/IndividualProduct.dart';
import 'package:etfi_point/Components/Utils/Services/assingName.dart';
import 'package:etfi_point/Components/Utils/Services/selectImage.dart';
import 'package:etfi_point/Components/Utils/categoriesList.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/Components/Utils/divider.dart';
import 'package:etfi_point/Components/Utils/dropDownButtonFormField.dart';
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
  List<CategoriaTb> categoriasSeleccionadas = [];

  List<SubCategoriaTb> subCategoriasDisponibles = [];
  List<SubCategoriaTb> subCategoriasSeleccionadas = [];

  String? urlImage;
  Asset? imagenToUpload;

  int? enOferta = 0;
  bool isChecked = false;

  ProductoTb? _producto;

  List<ProductImageToUpload> selectedImages = [];
  Asset? principalImage;
  Uint8List? principalImageBytes;

  ProductSample? productSample;

  @override
  void initState() {
    super.initState();

    print('dataUpdat_: ${widget.data}');

    _nombreController.text = widget.data?.nombreProducto ?? '';
    _precioController.text = (widget.data?.precio ?? 0).toStringAsFixed(0);
    _descripcionController.text = widget.data?.descripcion ?? '';
    _cantidadDisponibleController.text =
        widget.data?.cantidadDisponible.toString() ?? '';
    urlImage = widget.data?.urlImage;
    enOferta = widget.data?.oferta;
    estaEnOferta();

    obtenerCategoriasSeleccionadas();
    obtenerCategorias();
    getListSecondaryProductImages();

    //obtenerSubCategoriasSeleccionadas();

    if (widget.data != null) {
      _producto = widget.data;
    }
  }

  
  //UTILIZAR
  List<ProductImagesTb> productSecondaryImages = [];
  List<dynamic> allProductImages = [];

  void getListSecondaryProductImages() async {
    int? idProducto = widget.data?.idProducto;
    if (idProducto != null) {
      List<ProductImagesTb> productSecondaryImagesAux =
          await ProductImageDb.getProductSecondaryImages(idProducto);

      setState(() {
        productSecondaryImages = productSecondaryImagesAux;
        allProductImages.addAll(productSecondaryImagesAux);
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

  void obtenerCategoriasSeleccionadas() async {
    int? idProducto = widget.data?.idProducto;
    if (idProducto != null) {
      List<CategoriaTb> categoriasSeleccionadasAux =
          await CategoriaDb.getCategoriasSeleccionadas(idProducto);

      List<SubCategoriaTb> subCategoriasSeleccionadasAux =
          await SubCategoriasDb.getSubCategoriasSeleccionadas(idProducto);

      List<SubCategoriaTb> subCategorias = [];

      for (int i = 0; i < categoriasSeleccionadasAux.length; i++) {
        for (var subCategoriaSeleccionada in subCategoriasSeleccionadasAux) {
          if (subCategoriaSeleccionada.idCategoria ==
              categoriasSeleccionadasAux[i].idCategoria) {
            subCategorias.add(subCategoriaSeleccionada);
          }
        }
        categoriasSeleccionadasAux[i] = categoriasSeleccionadasAux[i]
            .copyWith(subCategoriasSeleccionadas: subCategorias);
      }
      setState(() {
        categoriasSeleccionadas.addAll(categoriasSeleccionadasAux);
        subCategoriasSeleccionadas.addAll(subCategorias);
      });

      print('IMPORTANTE ANTES_: $categoriasSeleccionadas');
    }
  }

  // void obtenerSubCategoriasSeleccionadas() {
  //   List<SubCategoriaTb> subCategoriasSeleccionadasAux = [];
  //   print('categoriasSeleccionadasInReturnCate_: $categoriasSeleccionadas');

  //   for (var categoriaSeleccionada in categoriasSeleccionadas) {
  //     if (categoriaSeleccionada.subCategoriasSeleccionadas != null) {
  //       subCategoriasSeleccionadasAux
  //           .addAll(categoriaSeleccionada.subCategoriasSeleccionadas!);
  //     }
  //   }

  //   setState(() {
  //     subCategoriasSeleccionadas.addAll(subCategoriasSeleccionadasAux);
  //   });
  // }

  void obtenerCategorias() async {
    List<CategoriaTb> categoriasDisponiblesAux =
        await CategoriaDb.getCategorias();

    setState(() {
      categoriasDisponibles.addAll(categoriasDisponiblesAux);
    });
  }

  // void obtenerSubCategorias(int idCategoria) async {
  //   List<SubCategoriaTb> subCatgoriasAux =
  //       await subCategoriasDb.getSubCategorias(idCategoria);

  //   setState(() {
  //     subCategoriasDisponibles.addAll(subCatgoriasAux);
  //   });
  // }

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
        ProductCreacionImagesStorageTb image = ProductCreacionImagesStorageTb(
            idUsuario: idUsuario,
            idProducto: idProducto,
            newImageBytes:
                principalImageBytes ?? await assetToUint8List(principalImage!),
            imageName: principalImage!.name!,
            fileName: 'productos',
            width: principalImage!.originalWidth!.toDouble(),
            height: principalImage!.originalHeight!.toDouble(),
            isPrincipalImage: 1);

        await ProductImagesStorage.cargarImage(image);
      }

      if (selectedImages.isNotEmpty) {
        for (var imagen in selectedImages) {
          Uint8List imageBytes = await assetToUint8List(imagen.newImage);
          ProductCreacionImagesStorageTb image = ProductCreacionImagesStorageTb(
              idUsuario: idUsuario,
              idProducto: idProducto,
              newImageBytes: imageBytes,
              imageName: imagen.nombreImage,
              fileName: 'productos',
              width: imagen.width,
              height: imagen.height,
              isPrincipalImage: 0);

          await ProductImagesStorage.cargarImage(image);
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
    if (imagenToUpload != null) {
      ProductImageStorageTb image = ProductImageStorageTb(
          idUsuario: idUsuario,
          idProducto: idProducto,
          newImage: imagenToUpload!,
          fileName: 'productos',
          nombreImagen: producto.nombreImage,
          width: imagenToUpload!.originalWidth!.toDouble(),
          height: imagenToUpload!.originalHeight!.toDouble(),
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

        selectedImages.add(selectedImage);
      }

      setState(() {
        selectedImages = [...selectedImages, ...selectedImagesAux];
        principalImage = imagesAsset[0];
      });
    }

    print('Imagenes seleccionadas3: $imagesAsset');
  }

  void takeOutImage() {}

  Future<void> editImage() async {
    // 1. Convertir Asset a Archivo temporal
    if (principalImage != null) {
      final byteData = await principalImage!.getByteData();
      final buffer = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image.jpg');
      await tempFile.writeAsBytes(buffer);

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
                            color: isChecked ? Colors.blue : Colors.white,
                            colorNameSaveButton:
                                isChecked ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(17.0),
                            //borderSideColor: Colors.grey
                            fontSize: 16,
                          ),
                        ),
                      ),
                      selectedImages.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 30.0, 0.0, 0.0),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxHeight:
                                      260, // Altura máxima para la lista de imágenes
                                ),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: selectedImages.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final image = selectedImages[index];
                                    double originalWidth = image
                                        .newImage.originalWidth!
                                        .toDouble();
                                    double originalHeight = image
                                        .newImage.originalHeight!
                                        .toDouble();
                                    double desiredWidth = 600.0;
                                    double desiredHeight = desiredWidth *
                                        (originalHeight / originalWidth);

                                    bool isSelected =
                                        principalImage == image.newImage;

                                    return Column(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5.0, 0.0, 4.0, 8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                principalImage = image.newImage;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  border: isSelected
                                                      ? Border.all(
                                                          color: Colors.blue,
                                                          width: 4.5)
                                                      : null),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                child: AssetThumb(
                                                  asset: image.newImage,
                                                  width: desiredWidth.toInt(),
                                                  height: desiredHeight.toInt(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                        if (isSelected)
                                          Text(
                                            'Imagen principal',
                                            style: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                          : SizedBox.shrink(),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: GlobalTextButton(
                          onPressed: agregarImagenes,
                          padding: selectedImages.isNotEmpty
                              ? const EdgeInsets.only(left: 5.0, top: 10.0)
                              : const EdgeInsets.fromLTRB(0.0, 40.0, 20.0, 0.0),
                          fontWeightTextButton: FontWeight.w700,
                          letterSpacing: 0.7,
                          fontSizeTextButton: 17.5,
                          textButton: 'Agregar imagen(es)',
                        ),
                      ),

                      if (principalImage != null)
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
                            principalImageBytes != null
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
                                          padding: const EdgeInsets.fromLTRB(
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
                            ElevatedButton(
                                onPressed: () {
                                  editImage();
                                },
                                child: Text('Editar'))
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

                      const GlobalDivider(),

                      DropDownButtonFormField(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        hintText: 'Selecciona las categorias',
                        onChanged: (dynamic newValue) {
                          setState(() {
                            if (!categoriasSeleccionadas.contains(newValue)) {
                              categoriasSeleccionadas.add(newValue!);
                            }
                          });
                          //obtenerSubCategorias(newValue.idCategoria);
                        },
                        elementosDisponibles: categoriasDisponibles,
                      ),

                      //Categorias seleccionadas
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: CategoriesList(
                            elementos: categoriasSeleccionadas,
                            marginContainer: EdgeInsets.all(5.0),
                            paddingContainer: EdgeInsets.all(12.0),
                            // subCategoriasSeleccionadas:
                            //     categoriasSeleccionadas,
                          )),

                      const GlobalDivider(),

                      DropDownButtonFormField(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          hintText: 'Selecciona las subCategorias',
                          onChanged: (dynamic newValue) {
                            setState(() {
                              if (!subCategoriasSeleccionadas
                                  .contains(newValue)) {
                                subCategoriasSeleccionadas.add(newValue!);
                              }
                            });
                          },
                          elementosDisponibles: []),

                      //Sub-Categorias seleccionadas
                      Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: CategoriesList(
                            elementos: subCategoriasSeleccionadas,
                            marginContainer: EdgeInsets.all(5.0),
                            paddingContainer: EdgeInsets.all(12.0),
                          )),

                      //if (imagenToUpload != null || urlImage != null)
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                      //   child: ShowImage(
                      //     width: 350,
                      //     height: 300,
                      //     color: Colors.grey[300],
                      //     borderRadius: BorderRadius.circular(20.0),
                      //     widthAsset: 350,
                      //     heightAsset: 300,
                      //     imageAsset: imagenToUpload,
                      //     networkImage: urlImage,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                      //   child: ElevatedButton.icon(
                      //     onPressed: () async {
                      //       final asset = await getImageAsset();
                      //       if (asset != null) {
                      //         setState(() {
                      //           imagenToUpload = asset;
                      //         });
                      //       }
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       padding: const EdgeInsets.all(
                      //           16.0), // Ajustar el padding del botón
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(
                      //             10.0), // Establecer bordes redondeados
                      //       ),
                      //     ),
                      //     icon: Icon(Icons.image),
                      //     label: imagenToUpload != null
                      //         ? Text('Cambiar imagen')
                      //         : Text('Agrega una imagen'),
                      //   ),
                      // ),
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

                      selectedImages.isNotEmpty && idUsuario != null
                          ? crearProducto(productoCreacion, idUsuario)
                          : print('imagenToUpload es null o idUsuario es null');
                    } else {
                      _producto = ProductoTb(
                        idProducto: widget.data!.idProducto,
                        idNegocio: widget.data!.idNegocio,
                        nombreProducto: nombreProducto,
                        precio: precio,
                        descripcion: descripcion,
                        cantidadDisponible: cantidadDisponible,
                        oferta: enOferta,
                        urlImage: urlImage!,
                        nombreImage: widget.data!.nombreImage,
                      );

                      urlImage != null && idUsuario != null
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

//  Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 15.0),
//                           child: DropdownButtonFormField<CategoriaTb>(
//                             decoration: InputDecoration(
//                               hintText: 'Selecciona una categoría',
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   borderSide: BorderSide.none),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             //value: categoriaSeleccionada,
//                             items: categoriasDisponibles
//                                 .map(
//                                   (categoria) => DropdownMenuItem<CategoriaTb>(
//                                     value: categoria,
//                                     child: Text(
//                                       categoria.nombre,
//                                       style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                             onChanged: (CategoriaTb? newValue) {
//                               setState(() {
//                                 if (!categoriasSeleccionadas
//                                     .contains(newValue)) {
//                                   categoriasSeleccionadas.add(newValue!);
//                                 }
//                               });
//                             },
//                             dropdownColor: Colors.grey[200],
//                           ),
//                         ),
