import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/enlaces/enlaceProServicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/noEnlaces/publicacionesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Data/Entities/Publicaciones/enlaces/enlaceProServicioDb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/Publicaciones/no%20enlaces/publicacionesDb.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/Services/MediaPicker.dart';
import 'package:etfi_point/Components/Utils/Services/assingName.dart';
import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/cargarMediaDeEnlaces.dart';
import 'package:etfi_point/Pages/enlaces/paginaUno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CrearReel extends StatefulWidget {
  const CrearReel({super.key, required this.idUsuario});

  final int idUsuario;

  @override
  State<CrearReel> createState() => _CrearReelState();
}

class _CrearReelState extends State<CrearReel> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final TextEditingController _descripcionController = TextEditingController();

  VideoPlayerController? _controller;
  XFile? reel;

  dynamic selectedProServicio;

  void guardarReel() async {
    String descripcion = _descripcionController.text;
    String fileName = '';

    fileName = selectedProServicio is ProductoTb
        ? 'enlaceProductReel'
        : selectedProServicio is ServicioTb
            ? 'enlaceServiceReel'
            : 'onlyReel';

    if (reel != null) {
      String nombreReel = reel!.name;
      String finalNameVideo = assingName(nombreReel);

      VideoStorageCreacionTb video = VideoStorageCreacionTb(
        idUsuario: widget.idUsuario,
        video: reel!,
        fileName: fileName,
        finalNameVideo: finalNameVideo,
      );

      String urlReel = await CargarMediaDeEnlaces.uploadVideoAndGetURL(video);

      if (selectedProServicio is ProductoTb) {
        ProductEnlaceReelCreacionTb reel = ProductEnlaceReelCreacionTb(
          idProducto: selectedProServicio.idProducto,
          urlReel: urlReel,
          nombreReel: nombreReel,
          descripcion: descripcion,
        );

        EnlaceProServicioDb.insertEnlaceProServicio(reel);
      } else if (selectedProServicio is ServicioTb) {
        ServiceEnlaceReelCreacionTb reel = ServiceEnlaceReelCreacionTb(
          idServicio: selectedProServicio.idServicio,
          urlReel: urlReel,
          nombreReel: nombreReel,
          descripcion: descripcion,
        );

        EnlaceProServicioDb.insertEnlaceProServicio(reel);
      } else if (selectedProServicio == null) {
        int? idNegocio = await NegocioDb.checkBusinessExists(widget.idUsuario);
        if (idNegocio != null) {
          ReelCreacionTb reel = ReelCreacionTb(
            idNegocio: idNegocio,
            urlReel: urlReel,
            nombreReel: nombreReel,
          );
          PublicacionesDb.insertReelPublicacion(reel);
        }
        fileName = 'onlyReel';
      }
    }
  }

  void updateSelectedProServicio(dynamic proServicio) {
    setState(() {
      selectedProServicio = proServicio;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> initializeVideo() async {
    if (reel != null) {
      _controller = VideoPlayerController.file(File(reel!.path));
      await _controller?.initialize();
      setState(() {});
      _controller?.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isUserSignedIn = context.watch<LoginProvider>().isUserSignedIn;

    double fontSize = 19.0;
    double letterSpacing = 0.3;

    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(240, 245, 251, 1.0),
            iconTheme: const IconThemeData(color: Colors.black, size: 25),
            toolbarHeight: 60,
            //automaticallyImplyLeading: automaticallyImplyLeading,
            title: GlobalTextButton(
              onPressed: () {
                if (isUserSignedIn) {
                  guardarReel();
                }
              },
              textButton: 'Guardar',
              fontSizeTextButton: fontSize,
              letterSpacing: letterSpacing,
            )),
        backgroundColor: const Color.fromRGBO(240, 245, 251, 1.0),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: paginaPrincipal(),
        ),
      ),
    );
  }

  Widget paginaPrincipal() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.grey.shade200,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 7.0),
                  child: Text(
                    'Bussines name',
                    style:
                        TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
              child: GeneralInputs(
                controller: _descripcionController,
                labelText: 'Agrega una descripción',
                colorBorder: Colors.transparent,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  30.0, 0.0, 0.0, reel != null ? 10.0 : 30.0),
              child: reel != null
                  ? _controller != null
                      ? GestureDetector(
                          onTap: () {
                            if (_controller!.value.isPlaying) {
                              _controller!.pause();
                            } else {
                              _controller!.play();
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AspectRatio(
                                aspectRatio:
                                    _controller!.value.aspectRatio * 1.2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Stack(
                                    children: [
                                      VideoPlayer(_controller!),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: VideoProgressIndicator(
                                          _controller!,
                                          allowScrubbing: true,
                                          colors: VideoProgressColors(
                                            playedColor: Colors.grey
                                                .shade700, // Color de la parte ya reproducida
                                            bufferedColor: Colors
                                                .grey, // Color de la parte ya cargada pero no reproducida
                                            backgroundColor: Colors
                                                .transparent, // Color de fondo
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container()
                  : GestureDetector(
                      onTap: () async {
                        XFile? videoReel = await pickVideo();
                        if (videoReel != null) {
                          setState(() {
                            reel = videoReel;
                          });
                          await initializeVideo();
                        }
                      },
                      child: Container(
                        height: 470.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            width: 1.0,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        child: const Icon(CupertinoIcons.add),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaginaUno(callback: updateSelectedProServicio),
                        ),
                      );
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
          ],
        ),
      ),
    );
  }
}
