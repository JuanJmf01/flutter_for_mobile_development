import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/serviceImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
import 'package:etfi_point/Components/Data/Firebase/Storage/productImagesStorage.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:etfi_point/Components/Utils/AssetToUint8List.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/crudImages.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/editarImagen.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/fileTemporal.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/myImageList.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/subCategoriaSeleccionadaProvider.dart';
import 'package:etfi_point/Components/Utils/Services/assingName.dart';
import 'package:etfi_point/Components/Utils/Services/selectImage.dart';
import 'package:etfi_point/Components/Utils/categoriesList.dart';
import 'package:etfi_point/Components/Utils/divider.dart';
import 'package:etfi_point/Components/Utils/elevatedGlobalButton.dart';
import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Components/Utils/showSampletAnyImage.dart';
import 'package:etfi_point/Pages/proServicios/buttonSeleccionarCategorias.dart';
import 'package:etfi_point/Pages/proServicios/sectionTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class AgregarServicio extends StatefulWidget {
  const AgregarServicio({
    super.key,
    this.servicio,
    required this.titulo,
    required this.nameSaveButton,
  });

  final ServicioTb? servicio;
  final String titulo;
  final String nameSaveButton;

  @override
  State<AgregarServicio> createState() => _AgregarServicioState();
}

class _AgregarServicioState extends State<AgregarServicio> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _descuentoController = TextEditingController();

  ServicioTb? _servicio;

  int enOferta = 0;
  bool isChecked = false;

  ImageList myImageList = ImageList([]);
  Asset? principalImage;
  Uint8List? principalImageBytes;
  String? urlPrincipalImage;

  List<CategoriaTb> categoriasDisponibles = [];
  List<SubCategoriaTb> categoriasSeleccionadas = [];

  void agregarDesdeGaleria() async {
    Asset? imagesAsset = await getImageAsset();

    if (imagesAsset != null) {
      setState(() {
        principalImage = imagesAsset;
      });
    }
  }

  Future<void> crearServicio(ServicioCreacionTb servicio, int idUsuario) async {
    int idServicio;
    try {
      idServicio =
          await ServicioDb.insertServicio(servicio, categoriasSeleccionadas);
      String finalNameImage = assingName(principalImage!.name!);

      if (principalImageBytes != null || principalImage != null) {
        ImageStorageCreacionTb image = ImageStorageCreacionTb(
          idUsuario: idUsuario,
          idProServicio: idServicio,
          newImageBytes:
              principalImageBytes ?? await assetToUint8List(principalImage!),
          fileName: 'servicios',
          finalNameImage: finalNameImage,
        );
        String url = await ProductImagesStorage.cargarImage(image);

        ProServicioImageCreacionTb productImage = ProServicioImageCreacionTb(
          idProServicio: idServicio,
          nombreImage: finalNameImage,
          urlImage: url,
          width: principalImage!.originalWidth!.toDouble(),
          height: principalImage!.originalHeight!.toDouble(),
          isPrincipalImage: 1,
        );

        await ServiceImageDb.insertServiceImage(productImage);
      }

      if (myImageList.items.isNotEmpty) {
        for (var imagen in myImageList.items) {
          String finalNameImage = assingName(principalImage!.name!);
          if (imagen is ProductImageToUpload) {
            Uint8List imageBytes = await assetToUint8List(imagen.newImage);

            ImageStorageCreacionTb image = ImageStorageCreacionTb(
              idUsuario: idUsuario,
              idProServicio: idServicio,
              newImageBytes: imageBytes,
              finalNameImage: finalNameImage,
              fileName: 'servicios',
            );

            String url = await ProductImagesStorage.cargarImage(image);

            ProServicioImageCreacionTb serviceImage =
                ProServicioImageCreacionTb(
              idProServicio: idServicio,
              nombreImage: finalNameImage,
              urlImage: url,
              width: principalImage!.originalWidth!.toDouble(),
              height: principalImage!.originalHeight!.toDouble(),
              isPrincipalImage: 0,
            );
            await ServiceImageDb.insertServiceImage(serviceImage);
          }
        }
      }
    } catch (error) {
      print('Problemas al insertar el servicio $error');
    }
  }

  void getListSecondaryProductImages() async {
    int? idServicio = _servicio?.idServicio;
    if (idServicio != null) {
      List<ProservicioImagesTb> ServiceSecondaryImagesAux =
          await ServiceImageDb.getServiceSecondaryImages(idServicio);

      setState(() {
        //productSecondaryImages = productSecondaryImagesAux;
        myImageList.items.addAll(ServiceSecondaryImagesAux);

        print('Mi lista de imagenes: $myImageList');
      });
    }
  }

  ServicioTb? assingValuesToInputs() {
    ServicioTb? servicio = _servicio;
    if (servicio != null) {
      _nombreController.text = servicio!.nombre;
      _precioController.text = (servicio.precio).toStringAsFixed(0);
      _descripcionController.text = servicio.descripcion ?? '';
      _descuentoController.text = servicio.descuento.toString();
      urlPrincipalImage = servicio.urlImage;

      enOferta = servicio.oferta;

      getListSecondaryProductImages();
      estaEnOferta();

      return servicio;
    }
    return null;
  }

  void estaEnOferta() {
    enOferta == 1
        ? isChecked = true
        : enOferta == 0
            ? isChecked = false
            : isChecked = false;
  }

  String newPrice() {
    double precioInicial = double.tryParse(_precioController.text) ?? 0.0;
    double descuento = double.tryParse(_descuentoController.text) ?? 0.0;

    // Asegúrate de que el descuento esté dentro del rango de 1 a 100
    if (descuento < 0) {
      descuento = 0;
      _descuentoController.text = '0';
    } else if (descuento > 100.0) {
      descuento = 100.0;
      _descuentoController.text = '100';
    }

    // Calcula el nuevo precio
    double nuevoPrecio = precioInicial - (precioInicial * (descuento / 100.0));

    return 'Nuevo precio con descuento: \$${nuevoPrecio.toStringAsFixed(2)}';
  }

  @override
  void initState() {
    super.initState();

    if (widget.servicio != null) {
      _servicio = widget.servicio;
    }

    ServicioTb? servicio = assingValuesToInputs();

    CategoriaDb.obtenerCategorias(context, MisRutas.rutaCategoriasServicios);

    if (widget.servicio != null) {
      context
          .read<SubCategoriaSeleccionadaProvider>()
          .obtenerSubCategoriasSeleccionadas(servicio!.idServicio, ServicioTb);
    }

    _precioController.addListener(_updatePrice);
    _descuentoController.addListener(_updatePrice);
  }

  void _updatePrice() {
    setState(() {});
  }

  void actualizarServicio(ServicioTb servicio, int idUsuario) async {
    int idServicio = servicio.idServicio;

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
        idFile: idServicio,
        newImageBytes:
            principalImageBytes ?? await assetToUint8List(principalImage!),
        fileName: 'servicios',
        imageName: servicio.nombreImage,
        width: 195.0,
        height: 170.0,
        isPrincipalImage: 0,
      );
      await ProductImagesStorage.updateImage(image);
    } else {
      print('Imagen a actualizar es null');
    }
    try {
      await ServicioDb.updateServicio(servicio, categoriasSeleccionadas);
      //mostrarCuadroExito(idProducto);
    } catch (error) {
      print('Problemas al actualizar el servicio $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuario;

    categoriasDisponibles =
        Provider.of<SubCategoriaSeleccionadaProvider>(context).allSubCategorias;
    categoriasSeleccionadas =
        Provider.of<SubCategoriaSeleccionadaProvider>(context)
            .subCategoriasSeleccionadas;
    Color colorTextField = Colors.white;
    double horizontalPadding = 16.0;
    double verticalPadding = 15.0;
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
          ),
        ),
        backgroundColor: Color.fromRGBO(240, 245, 251, 1.0),
        body: Column(
          children: [
            Expanded(
              child: FocusScope(
                node: _focusScopeNode,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 0.0),
                          child: ElevatedGlobalButton(
                            nameSavebutton: 'Servicio en oferta?',
                            borderSideColor:
                                !isChecked ? Colors.grey : Colors.transparent,
                            onPress: () {
                              setState(() {
                                isChecked = !isChecked;
                                enOferta = isChecked ? 1 : 0;
                                print("en oferta: $enOferta");
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
                              onImageSelected: (selectedImage) {
                                setState(() {
                                  if (principalImageBytes != null) {
                                    principalImageBytes = null;
                                  }
                                  if (selectedImage is Asset) {
                                    principalImage = selectedImage;
                                  }
                                });
                              },
                            )
                          : SizedBox.shrink(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GlobalTextButton(
                          onPressed: () async {
                            List<ProductImageToUpload> selectedImagesAux =
                                await CrudImages.agregarImagenes();
                            setState(() {
                              myImageList.items.addAll(selectedImagesAux);
                              if (selectedImagesAux.isNotEmpty) {
                                principalImage = selectedImagesAux[0].newImage;
                              }
                              // principalImage ??= selectedImagesAux[0]
                              //     .newImage; //Si 'principalImage' es null, asignar selectedImagesAux[0].newImage
                            });
                          },
                          padding: myImageList.items.isNotEmpty
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
                            ShowSampleAnyImage(
                              imageBytes: principalImageBytes,
                              imageAsset: principalImage,
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      File tempFile =
                                          await FileTemporal.convertToTempFile(
                                              image: principalImage);
                                      Uint8List? croppedBytes =
                                          await EditarImagen.editImage(tempFile,
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
                        textLabelOutside: 'Nombre',
                        labelText: "Nombre",
                        horizontalPadding: horizontalPadding,
                        verticalPadding: verticalPadding,
                        color: colorTextField,
                      ),
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
                      isChecked
                          ? GeneralInputs(
                              controller: _descuentoController,
                              horizontalPadding: 16.0,
                              verticalPadding: 15.0,
                              textLabelOutside: 'Descuento',
                              labelText:
                                  'Agrega un valor del 1 al 100 para el descuento',
                              color: colorTextField,
                              keyboardType: TextInputType.number,
                            )
                          : const SizedBox.shrink(),
                      Text(newPrice()),
                      GeneralInputs(
                        controller: _descripcionController,
                        textLabelOutside: 'Descripcion',
                        labelText: "Descripcion",
                        horizontalPadding: horizontalPadding,
                        verticalPadding: verticalPadding,
                        color: colorTextField,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                      ),
                      const GlobalDivider(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      const SectionTitle(
                        title: "Categorias",
                        padding: EdgeInsets.fromLTRB(0.0, 12.0, 25.0, 0.0),
                      ),
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
                    ],
                  ),
                ),
              ),
            ),
            ElevatedGlobalButton(
              nameSavebutton: widget.nameSaveButton,
              widthSizeBox: double.infinity,
              heightSizeBox: 50.0,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              onPress: () async {
                final nombreServicio = _nombreController.text;
                double precio = double.tryParse(_precioController.text) ?? 0.0;
                final descripcion = _descripcionController.text;

                ServicioCreacionTb servicioCreacion;
                int idNegocio =
                    await NegocioDb.crearNegocioSiNoExiste(idUsuario);
                int descuento = int.tryParse(_descuentoController.text) ?? 0;

                if (_servicio?.idServicio == null) {
                  servicioCreacion = ServicioCreacionTb(
                    idNegocio: idNegocio,
                    nombre: nombreServicio,
                    descripcion: descripcion,
                    precio: precio,
                    oferta: enOferta ?? 0,
                    descuento: isChecked ? descuento : 0,
                  );

                  if (idUsuario != null) {
                    crearServicio(servicioCreacion, idUsuario);
                  }
                } else {
                  _servicio = ServicioTb(
                    idServicio: _servicio!.idServicio,
                    idNegocio: _servicio!.idNegocio,
                    nombre: nombreServicio,
                    precio: precio,
                    oferta: enOferta,
                    urlImage: _servicio!.urlImage,
                    nombreImage: _servicio!.nombreImage,
                  );

                  print("PRIMER PARTE ${_servicio!.nombre}");

                  idUsuario != null
                      ? actualizarServicio(_servicio!, idUsuario)
                      : print('idUsuario es null');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
