import 'dart:io';
import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/crudImages.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/editarImagen.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/fileTemporal.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/myImageList.dart';
import 'package:etfi_point/Components/Utils/IndividualProduct.dart';
import 'package:etfi_point/Components/Utils/Services/selectImage.dart';
import 'package:etfi_point/Components/Utils/divider.dart';
import 'package:etfi_point/Components/Utils/elevatedGlobalButton.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Components/Utils/showSampletAnyImage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AgregarServicio extends StatefulWidget {
  const AgregarServicio({super.key});

  @override
  State<AgregarServicio> createState() => _AgregarServicioState();
}

class _AgregarServicioState extends State<AgregarServicio> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  bool isChecked = false;

  ImageList myImageList = ImageList([]);
  Asset? principalImage;
  Uint8List? principalImageBytes;

  void agregarDesdeGaleria() async {
    Asset? imagesAsset = await getImageAsset();

    if (imagesAsset != null) {
      setState(() {
        principalImage = imagesAsset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              principalImage ??= selectedImagesAux[0]
                                  .newImage; //Si 'principalImage' es null, asignar selectedImagesAux[0].newImage
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
                        )
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
              onPress: () {},
            )
          ],
        ),
      ),
    );
  }
}
