import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/crudImages.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Components/Utils/pageViewImagesScroll.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/enlaces/cargarMediaDeEnlaces.dart';
import 'package:etfi_point/Pages/enlaces/paginaUno.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrearEnlace extends StatefulWidget {
  const CrearEnlace({super.key, required this.idUsuario});

  final int idUsuario;

  @override
  State<CrearEnlace> createState() => _CrearEnlaceState();
}

class _CrearEnlaceState extends State<CrearEnlace> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final TextEditingController _descripcionController = TextEditingController();

  List<ProServicioImageToUpload> imagesToUpload = [];

  int indicePagina = 1;

  bool automaticallyImplyLeading = true;
  bool isProducto = true;

  dynamic selectedProServicio;

  void updateSelectedProServicio(dynamic proServicio) {
    setState(() {
      selectedProServicio = proServicio;
    });
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
                    CargarMediaDeEnlaces.guardarEnlace(
                      _descripcionController,
                      selectedProServicio,
                      widget.idUsuario,
                      imagesToUpload,
                    );
                  } else {
                    setState(() {
                      indicePagina += 1;
                      automaticallyImplyLeading = false;
                    });
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
              : paginaDos(),
        ),
      ),
    );
  }

  Widget paginaDos() {
    return Container(
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
                    style:
                        TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),
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
                    20.0, 0.0, 0.0, imagesToUpload.isNotEmpty ? 10.0 : 30.0),
                child: imagesToUpload.isNotEmpty
                    ? PageViewImagesScroll(images: imagesToUpload)
                    : const SizedBox.shrink()),
            Align(
              alignment: Alignment.centerRight,
              child: GlobalTextButton(
                onPressed: () async {
                  List<ProServicioImageToUpload> selectedImagesAux =
                      await CrudImages.agregarImagenes();
                  setState(() {
                    imagesToUpload.addAll(selectedImagesAux);
                  });
                },
                fontWeightTextButton: FontWeight.w700,
                letterSpacing: 0.7,
                fontSizeTextButton: 17.5,
                textButton: 'Agregar imagen(es)',
              ),
            )
          ],
        ),
      ),
    );
  }
}
