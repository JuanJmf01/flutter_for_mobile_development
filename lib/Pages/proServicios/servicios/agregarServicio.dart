import 'dart:io';
import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
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
  const AgregarServicio({super.key});

  @override
  State<AgregarServicio> createState() => _AgregarServicioState();
}

class _AgregarServicioState extends State<AgregarServicio> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  final TextEditingController _descripcionController = TextEditingController();

  bool isChecked = false;

  ImageList myImageList = ImageList([]);
  Asset? principalImage;
  Uint8List? principalImageBytes;

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

  @override
  void initState() {
    super.initState();
    String url = MisRutas.rutaCategoriasServicios;

    CategoriaDb.obtenerCategorias(context: context, url: url);
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
          title: const Text(
            "Agregar servicio",
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
                            nameSavebutton: '¿Producto en oferta?',
                            borderSideColor:
                                !isChecked ? Colors.grey : Colors.transparent,
                            onPress: () {
                              setState(() {
                                isChecked = !isChecked;
                                //enOferta = isChecked ? 1 : 0;
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
              nameSavebutton: "Agregar",
              widthSizeBox: double.infinity,
              heightSizeBox: 50.0,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              onPress: () async {
                print("IMAGENES: $myImageList");
                print("PRINCIPAL IMAGE: $principalImage");
                print("CATEGORIAS: $categoriasSeleccionadas");
                final nombreServicio = _nombreController.text;
                double precio = double.tryParse(_precioController.text) ?? 0.0;
                final descripcion = _descripcionController.text;

                ServicioCreacionTb servicioCreacion;
                int idNegocio =
                    await NegocioDb.crearNegocioSiNoExiste(idUsuario);

                servicioCreacion = ServicioCreacionTb(
                  idNegocio: idNegocio,
                  nombre: nombreServicio,
                  descripcion: descripcion,
                  precio: precio,
                  oferta: 0,
                );

                if (idUsuario != null) {
                  crearServicio(servicioCreacion, idUsuario);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
