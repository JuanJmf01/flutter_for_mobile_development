import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/Services/MediaPicker.dart';
import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Pages/enlaces/paginaUno.dart';
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

  late ChewieController? _chewieController;

  int indicePagina = 1;

  bool automaticallyImplyLeading = true;
  dynamic selectedProServicio;

  XFile? reel;

  void updateSelectedProServicio(dynamic proServicio) {
    setState(() {
      selectedProServicio = proServicio;
    });
  }

  void _initializeChewieController(XFile videoFile) {
    final videoPlayerController =
        VideoPlayerController.file(File(videoFile.path));
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: videoPlayerController.value.aspectRatio,
      autoPlay: false, // Cambiar a true si deseas reproducción automática
      looping: false, // Cambiar a true si deseas reproducción en bucle
      allowFullScreen: true, // Permitir pantalla completa
    );
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
            backgroundColor: Color.fromRGBO(240, 245, 251, 1.0),
            iconTheme: IconThemeData(color: Colors.black, size: 25),
            toolbarHeight: 60,
            automaticallyImplyLeading: automaticallyImplyLeading,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                indicePagina == 1
                    ? const Text(
                        "Crear vinculo",
                        style: TextStyle(color: Colors.black),
                      )
                    : GlobalTextButton(
                        onPressed: () {
                          setState(() {
                            indicePagina -= 1;
                            automaticallyImplyLeading = true;
                          });
                        },
                        textButton: "Atras",
                        fontSizeTextButton: fontSize,
                        letterSpacing: letterSpacing,
                      ),
                GlobalTextButton(
                  onPressed: () {
                    if (isUserSignedIn && indicePagina == 2) {
                      // CargarMedia.guardarEnlace(
                      //   _descripcionController,
                      //   selectedProServicio,
                      //   widget.idUsuario,
                      //   imagesToUpload,
                      // );
                      print("Guardar");
                    } else {
                      setState(() {
                        indicePagina += 1;
                        automaticallyImplyLeading = false;
                      });
                      print("Siguiente");
                    }
                  },
                  textButton: indicePagina == 1 ? 'Siguiente' : 'Guardar',
                  fontSizeTextButton: fontSize,
                  letterSpacing: letterSpacing,
                )
              ],
            ),
          ),
          backgroundColor: Color.fromRGBO(240, 245, 251, 1.0),
          body: Padding(
              padding: EdgeInsets.all(8.0),
              child: indicePagina == 1
                  ? PaginaUno(
                      callback: updateSelectedProServicio,
                    )
                  : paginaDos()),
        ));
  }

  Widget paginaDos() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
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
                        color: Colors.grey.shade200),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 7.0),
                    child: Text(
                      'Bussines name',
                      style: TextStyle(
                          fontSize: 15.5, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                  child: GeneralInputs(
                    controller: _descripcionController,
                    labelText: 'Agrega una descripción',
                    colorBorder: Colors.transparent,
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    30.0, 0.0, 0.0, reel != null ? 10.0 : 30.0),
                child: reel != null
                    ? _chewieController != null
                        ? AspectRatio(
                            aspectRatio: _chewieController!
                                .videoPlayerController.value.aspectRatio,
                            child: GestureDetector(
                              onTap: () {
                                _chewieController!.enterFullScreen();
                              },
                              child: Chewie(
                                controller: _chewieController!,
                              ),
                            ),
                          )
                        : Container()
                    : const SizedBox.shrink(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GlobalTextButton(
                  onPressed: () async {
                    XFile? videoReel = await pickVideo();
                    if (videoReel != null) {
                      setState(() {
                        reel = videoReel;
                        _initializeChewieController(videoReel);
                      });
                    }
                  },
                  fontWeightTextButton: FontWeight.w700,
                  letterSpacing: 0.7,
                  fontSizeTextButton: 17.5,
                  textButton: 'Agregar reel',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
