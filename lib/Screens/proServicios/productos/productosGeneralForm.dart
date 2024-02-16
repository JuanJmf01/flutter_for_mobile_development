import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/FirebaseStorage/firebaseImagesStorage.dart';
import 'package:etfi_point/Components/Utils/ElevatedGlobalButton.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/crudImages.dart';
import 'package:etfi_point/Components/Utils/Services/editarImagen.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/fileTemporal.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/myImageList.dart';
import 'package:etfi_point/Components/Utils/Services/MediaPicker.dart';
import 'package:etfi_point/Components/Utils/Services/randomServices.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/Components/Utils/divider.dart';
import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Components/providers/userStateProvider.dart';
import 'package:etfi_point/Screens/proServicios/sectionTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProductosGeneralForm extends ConsumerStatefulWidget {
  const ProductosGeneralForm({
    super.key,
    this.producto,
    this.exitoTitle,
    required this.titulo,
    required this.nameSavebutton,
    required this.exitoMessage,
  });

  final ProductoTb? producto;
  final String titulo;
  final String nameSavebutton;
  final String? exitoTitle;
  final String exitoMessage;

  @override
  ProductosGeneralFormState createState() => ProductosGeneralFormState();
}

class ProductosGeneralFormState extends ConsumerState<ProductosGeneralForm> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _precioConDescuentoController =
      TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _cantidadDisponibleController =
      TextEditingController();
  final TextEditingController _descuentoController = TextEditingController();

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

    if (widget.producto != null) {
      _producto = widget.producto;
    }
    ProductoTb? producto = assingValuesToInputs();

    // CategoriaDb.obtenerCategorias(
    //   context,
    //   MisRutas.rutaCategorias2,
    // );

    // if (widget.producto != null) {
    //   context
    //       .read<SubCategoriaSeleccionadaProvider>()
    //       .obtenerSubCategoriasSeleccionadas(producto!.idProducto, ProductoTb);
    // }

    _precioController.addListener(() {
      newPrice();
    });
    _descuentoController.addListener(() {
      newPrice();
    });
  }

  ProductoTb? assingValuesToInputs() {
    ProductoTb? producto = _producto;
    if (producto?.idProducto != null) {
      _nombreController.text = producto!.nombre;
      _precioController.text = (producto.precio).toStringAsFixed(0);
      _descripcionController.text = producto.descripcion ?? '';
      _cantidadDisponibleController.text =
          producto.cantidadDisponible.toString();
      _descuentoController.text = producto.descuento.toString();

      urlPrincipalImage = producto.urlImage;

      enOferta = producto.oferta;

      getListSecondaryProductImages();
      estaEnOferta();

      return producto;
    }
    return null;
  }

  void getListSecondaryProductImages() async {
    int? idProducto = _producto?.idProducto;
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

  Future<void> crearProducto(ProductoCreacionTb producto, int idUsuario) async {
    int idProducto;

    try {
      idProducto =
          await ProductoDb.insertProducto(producto, categoriasSeleccionadas);

      if (principalImageBytes != null || principalImage != null) {
        ImagesStorageTb image = ImagesStorageTb(
          idUsuario: idUsuario,
          idFile: idProducto,
          newImageBytes: principalImageBytes ??
              await RandomServices.assetToUint8List(principalImage!),
          imageName: principalImage!.name!,
          fileName: 'productos',
        );

        String url = await ImagesStorage.cargarImage(image);
        ProServicioImageCreacionTb productImage = ProServicioImageCreacionTb(
          idProServicio: idProducto,
          nombreImage: principalImage!.name!,
          urlImage: url,
          width: principalImage!.originalWidth!.toDouble(),
          height: principalImage!.originalHeight!.toDouble(),
          isPrincipalImage: 1,
        );

        await ProductImageDb.insertProductImages(productImage);
      }

      if (myImageList.items.isNotEmpty) {
        for (var imagen in myImageList.items) {
          if (imagen is ProServicioImageToUpload) {
            Uint8List imageBytes =
                await RandomServices.assetToUint8List(imagen.newImage);

            ImagesStorageTb image = ImagesStorageTb(
              idUsuario: idUsuario,
              idFile: idProducto,
              newImageBytes: imageBytes,
              imageName: imagen.nombreImage,
              fileName: 'productos',
            );

            String url = await ImagesStorage.cargarImage(image);

            ProServicioImageCreacionTb productImage =
                ProServicioImageCreacionTb(
              idProServicio: idProducto,
              nombreImage: principalImage!.name!,
              urlImage: url,
              width: principalImage!.originalWidth!.toDouble(),
              height: principalImage!.originalHeight!.toDouble(),
              isPrincipalImage: 0,
            );

            await ProductImageDb.insertProductImages(productImage);
          }
        }
      }
      mostrarCuadroExito(idProducto);
    } catch (error) {
      print('Problemas al insertar el producto $error');
    }
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
      ImagesStorageTb image = ImagesStorageTb(
        idUsuario: idUsuario,
        idFile: idProducto,
        newImageBytes: principalImageBytes ??
            await RandomServices.assetToUint8List(principalImage!),
        fileName: 'productos',
        imageName: producto.nombreImage,
      );

      await ImagesStorage.updateImage(image);
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

  void agregarDesdeGaleria() async {
    Asset? imagesAsset = await getImageAsset();

    if (imagesAsset != null) {
      setState(() {
        principalImage = imagesAsset;
        urlPrincipalImage = null;
      });
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

  void newPrice() {
    double precioInicial = double.tryParse(_precioController.text) ?? 0.0;
    double descuento = double.tryParse(_descuentoController.text) ?? 0.0;

    // Asegurarse de que el descuento esté dentro del rango de 1 a 100
    if (descuento < 0) {
      descuento = 0;
      _descuentoController.text = '0';
    } else if (descuento > 100.0) {
      descuento = 100.0;
      _descuentoController.text = '100';
    }

    // Calcular el nuevo precio
    double nuevoPrecio = precioInicial - (precioInicial * (descuento / 100.0));
    _precioConDescuentoController.text = nuevoPrecio.toString();
  }

  void guardar(int idUsuario) async {
    //--- Se asigna cada String de los campos de texto a una variable ---//
    final nombreProducto = _nombreController.text;
    double precio = double.tryParse(_precioController.text) ?? 0.0;
    final descripcion = _descripcionController.text;
    int cantidadDisponible =
        int.tryParse(_cantidadDisponibleController.text) ?? 0;
    int descuento = int.tryParse(_descuentoController.text) ?? 0;

    ProductoCreacionTb productoCreacion;
    int idNegocio = await NegocioDb.createBusiness(idUsuario);

    if (_producto?.idProducto == null) {
      //-- Creamos el producto --//
      productoCreacion = ProductoCreacionTb(
        idNegocio: idNegocio,
        nombreProducto: nombreProducto,
        precio: precio,
        descripcion: descripcion,
        cantidadDisponible: cantidadDisponible,
        oferta: enOferta,
        descuento: isChecked ? descuento : 0,
      );

      myImageList.items.isNotEmpty
          ? crearProducto(productoCreacion, idUsuario)
          : print('imagenToUpload es null o idUsuario es null');
    } else {
      //Actualizar ya que idProducto != null
      _producto = ProductoTb(
        idProducto: _producto!.idProducto,
        idNegocio: _producto!.idNegocio,
        nombre: nombreProducto,
        precio: precio,
        descripcion: descripcion,
        cantidadDisponible: cantidadDisponible,
        oferta: enOferta,
        urlImage: _producto!.urlImage,
        nombreImage: _producto!.nombreImage,
      );

      actualizarProducto(_producto!, idUsuario);
    }
  }

  @override
  Widget build(BuildContext context) {
    //bool isUserSignedIn = context.watch<LoginProvider>().isUserSignedIn;
    //int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuarioActual;
    final isUserSignedIn = ref.watch(userStateProvider);
    final int? idUsuarioActual = ref.watch(getCurrentUserProvider).value;

    // categoriasSeleccionadas =
    //     Provider.of<SubCategoriaSeleccionadaProvider>(context)
    //         .subCategoriasSeleccionadas;
    // categoriasDisponibles =
    //     Provider.of<SubCategoriaSeleccionadaProvider>(context).allSubCategorias;

    categoriasSeleccionadas = [];
    categoriasDisponibles = [];

    Color colorTextField = Colors.white;
    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.titulo),
              GlobalTextButton(
                onPressed: () {
                  if (idUsuarioActual != null && isUserSignedIn) {
                    guardar(idUsuarioActual);
                  }
                },
                textButton: 'Guardar',
                fontSizeTextButton: 19,
                letterSpacing: 0.3,
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FocusScope(
                node: _focusScopeNode,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Checked button

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
                          : const SizedBox.shrink(),
                      _producto?.idProducto == null
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: GlobalTextButton(
                                onPressed: () async {
                                  List<ProServicioImageToUpload>
                                      selectedImagesAux =
                                      await CrudImages.agregarImagenes();
                                  setState(() {
                                    myImageList.items.addAll(selectedImagesAux);
                                    if (_producto?.idProducto == null &&
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
                            const GlobalDivider(),
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
                            // ShowSampleAnyImage(
                            //   urlImage: urlPrincipalImage,
                            //   imageBytes: principalImageBytes,
                            //   imageAsset: principalImage,
                            // ),
                            Row(
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      File tempFile =
                                          await FileTemporal.convertToTempFile(
                                              urlImage: urlPrincipalImage,
                                              image: principalImage);
                                      Uint8List? croppedBytes =
                                          await EditarImagen.editImage(
                                              tempFile, 2.3, 2);

                                      setState(() {
                                        if (croppedBytes != null) {
                                          principalImageBytes =
                                              Uint8List.fromList(croppedBytes);
                                        }
                                      });
                                    },
                                    child: const Text('Editar')),
                                ElevatedButton(
                                    onPressed: () {
                                      agregarDesdeGaleria();
                                    },
                                    child: const Text('Agregar dede galeria')),
                              ],
                            )
                          ],
                        ),

                      const GlobalDivider(),

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
                                //print("en oferta: ${obtenerFechaHoraActual()}");
                              });
                            },
                            backgroundColor:
                                isChecked ? Colors.blue : Colors.white,
                            colorNameSaveButton:
                                isChecked ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(8.0),
                            //borderSideColor: Colors.grey
                            fontSize: 16,
                          ),
                        ),
                      ),

                      GeneralInputs(
                        controller: _nombreController,
                        textLabelOutside: 'Nombre',
                        labelText: 'Agrega un nombre',
                        color: colorTextField,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: GeneralInputs(
                              controller: _precioController,
                              textLabelOutside:
                                  !isChecked ? 'Precio' : 'Precio antes',
                              labelText: 'Agrega un precio',
                              color: colorTextField,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                          ),
                          isChecked
                              ? Expanded(
                                  child: GeneralInputs(
                                    controller: _precioConDescuentoController,
                                    textLabelOutside: 'Precio despues',
                                    color: const Color.fromARGB(11, 0, 0, 0),
                                    keyboardType: TextInputType.number,
                                    enable: false,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),

                      isChecked
                          ? GeneralInputs(
                              controller: _descuentoController,
                              textLabelOutside: '% Descuento',
                              labelText:
                                  'Agrega un valor de 0% a 100% para el descuento',
                              color: colorTextField,
                              keyboardType: TextInputType.number,
                            )
                          : const SizedBox.shrink(),

                      GeneralInputs(
                        controller: _descripcionController,
                        textLabelOutside: 'Descripcion',
                        labelText: 'Agrega una descripción',
                        color: colorTextField,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                      ),

                      GeneralInputs(
                        controller: _cantidadDisponibleController,
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
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.fromLTRB(35.0, 20.0, 20.0, 25.0),
                      //   child: CategoriesList(
                      //     onlyShow: false,
                      //     elementos: categoriasSeleccionadas,
                      //     marginContainer: const EdgeInsets.all(5.0),
                      //     paddingContainer: const EdgeInsets.all(12.0),
                      //   ),
                      // ),

                      // ButtonSeleccionarCategoriasProServicios(
                      //   categoriasDisponibles: categoriasDisponibles,
                      // ),
                      const SizedBox(height: 100.0)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
