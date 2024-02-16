import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/noEnlaces/publicacionImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/noEnlaces/publicacionesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Entities/PublicacionImagesDb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/Publicaciones/no%20enlaces/publicacionesDb.dart';
import 'package:etfi_point/Components/Data/Entities/FirebaseStorage/firebaseImagesStorage.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/crudImages.dart';
import 'package:etfi_point/Components/Utils/Services/randomServices.dart';
import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Components/Utils/pageViewImagesScroll.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/cargarMediaDeEnlaces.dart';
import 'package:etfi_point/Components/providers/proServiciosProvider.dart';
import 'package:etfi_point/Components/providers/userStateProvider.dart';
import 'package:etfi_point/Screens/enlaces/selectEnlace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CrearEnlace extends ConsumerStatefulWidget {
  const CrearEnlace({super.key, required this.idUsuario});

  final int idUsuario;

  @override
  CrearEnlaceState createState() => CrearEnlaceState();
}

class CrearEnlaceState extends ConsumerState<CrearEnlace> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final TextEditingController _descripcionController = TextEditingController();

  List<ProServicioImageToUpload> imagesToUpload = [];
  bool isProducto = true;

  dynamic selectedProServicio;

  void updateSelectedProServicio(dynamic proServicio) {
    setState(() {
      selectedProServicio = proServicio;
    });
  }

  void selectEnlace(int idUsuarioActual) async {
    final List<ProductoTb> productos;
    final List<ServicioTb> servicios;

    final productosFuture =
        ref.read(productosByNegocioProvider(idUsuarioActual).future);
    productos = await productosFuture;

    final serviciosFuture =
        ref.read(serviciosByNegocioProvider(idUsuarioActual).future);
    servicios = await serviciosFuture;

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectEnlace(
            callback: updateSelectedProServicio,
            productos: productos,
            servicios: servicios,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //bool isUserSignedIn = context.watch<LoginProvider>().isUserSignedIn;
    final isUserSignedIn = ref.watch(userStateProvider);
    final int? idUsuarioActual = ref.watch(getCurrentUserProvider).value;

    double fontSize = 19.0;
    double letterSpacing = 0.3;

    void guardarPublicacion(int idUsuario) async {
      int? idNegocio = await NegocioDb.checkBusinessExists(idUsuario);

      if (idNegocio != null) {
        PublicacionesCreacionTb publicacion = PublicacionesCreacionTb(
          idNegocio: idNegocio,
          descripcion: _descripcionController.text,
        );

        int idPublicacion =
            await PublicacionesDb.insertFotoPublicacion(publicacion);

        for (var imageToUpload in imagesToUpload) {
          ImagesStorageTb image = ImagesStorageTb(
            idUsuario: idUsuario,
            idFile: idPublicacion,
            newImageBytes:
                await RandomServices.assetToUint8List(imageToUpload.newImage),
            fileName: 'publicaciones',
            imageName: imageToUpload.nombreImage,
          );

          String urlImage = await ImagesStorage.cargarImage(image);

          PublicacionImagesCreacionTb publicacionImage =
              PublicacionImagesCreacionTb(
            idFotoPublicacion: idPublicacion,
            nombreImage: imageToUpload.nombreImage,
            urlImage: urlImage,
            width: imageToUpload.width,
            height: imageToUpload.height,
          );

          PublicacionImagesDb.insertPublicacionImage(publicacionImage);
        }
      }
    }

    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: automaticallyImplyLeading, // Habilitar boton para retroceder
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GlobalTextButton(
                onPressed: () {
                  if (isUserSignedIn && selectedProServicio != null) {
                    CargarMediaDeEnlaces.guardarEnlace(
                      _descripcionController,
                      selectedProServicio,
                      widget.idUsuario,
                      imagesToUpload,
                    );
                  } else if (selectedProServicio == null) {
                    guardarPublicacion(widget.idUsuario);
                  }
                },
                textButton: 'Guardar',
                fontSizeTextButton: fontSize,
                letterSpacing: letterSpacing,
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: paginaPrincipal(idUsuarioActual: idUsuarioActual),
        ),
      ),
    );
  }

  Widget paginaPrincipal({int? idUsuarioActual}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.grey.shade200),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 7.0),
                child: Text(
                  'Bussines name',
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          GeneralInputs(
            controller: _descripcionController,
            labelText: 'Agrega una descripción',
            colorBorder: Colors.transparent,
          ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(
          //       20.0, 0.0, 0.0, imagesToUpload.isNotEmpty ? 10.0 : 30.0),
          //   child: imagesToUpload.isNotEmpty
          //       ? PageViewImagesScroll(images: imagesToUpload)
          //       : const SizedBox.shrink(),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: GestureDetector(
              onTap: () async {
                if (imagesToUpload.isEmpty) {
                  List<ProServicioImageToUpload> selectedImagesAux =
                      await CrudImages.agregarImagenes();
                  setState(() {
                    imagesToUpload.addAll(selectedImagesAux);
                  });
                }
              },
              child: Container(
                height: 340.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    width: 1.0,
                    color: Colors.grey.shade400,
                  ),
                ),
                child: imagesToUpload.isNotEmpty
                    ? PageViewImagesScroll(images: imagesToUpload)
                    : const Center(
                        child: Icon(CupertinoIcons.add),
                      ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (idUsuarioActual != null) {
                      selectEnlace(idUsuarioActual);
                    } else {
                      print("id usuario actual null");
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(
                        CupertinoIcons.link_circle,
                        size: 30.0,
                      ),
                      GlobalTextButton(
                        textButton: "Agregar enlace",
                        fontSizeTextButton: 19.0,
                        color: Colors.black,
                      ),
                      Spacer(),
                      Icon(
                        CupertinoIcons.forward,
                        size: 30.0,
                      ),
                    ],
                  ),
                ),
                selectedProServicio != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          selectedProServicio is ServicioTb ||
                                  selectedProServicio is ProductoTb
                              ? Text(
                                  selectedProServicio.nombre,
                                  style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w500),
                                )
                              : const SizedBox.shrink(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedProServicio = null;
                              });
                            },
                            child: const Icon(
                              CupertinoIcons.xmark,
                              size: 19.0,
                            ),
                          )
                        ],
                      )
                    : const SizedBox.shrink()
              ],
            ),
          )

          // Align(
          //   alignment: Alignment.centerRight,
          //   child: GlobalTextButton(
          //     onPressed: () async {
          //       List<ProServicioImageToUpload> selectedImagesAux =
          //           await CrudImages.agregarImagenes();
          //       setState(() {
          //         imagesToUpload.addAll(selectedImagesAux);
          //       });
          //     },
          //     fontWeightTextButton: FontWeight.w700,
          //     letterSpacing: 0.7,
          //     fontSizeTextButton: 17.5,
          //     textButton: 'Agregar imagen(es)',
          //   ),
          // )
        ],
      ),
    );
  }
}
