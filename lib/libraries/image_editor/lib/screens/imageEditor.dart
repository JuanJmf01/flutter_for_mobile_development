import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_editor/image_editor.dart';

class ImageEditor2 extends StatefulWidget {
  const ImageEditor2({
    super.key,
    required this.selectedImage,
    required this.width,
    required this.height,
    required this.screenWidth,
  });

  // final List<AssetEntity> selectedImages;
  final Uint8List selectedImage;
  final int width;
  final int height;
  final double screenWidth;

  @override
  State<ImageEditor2> createState() => _ImageEditor2State();
}

class _ImageEditor2State extends State<ImageEditor2> {
  int selectedIndex = 0;
  //late AssetEntity selectedImage;
  late Uint8List selectedImage;
  late RenderBox imageRenderBox;

  Uint8List? editedImage;
  double _x = 0;
  double _y = 0;
  double _width = 150;
  double _height = 150;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.selectedImage;

    // selectedImage = widget.selectedImages[0];
  }

  void cutImage() async {
    // Obtener las dimensiones de la imagen original
    final double imageWidth = widget.width.toDouble();
    final double imageHeight = widget.height.toDouble();

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double screenImageHeight = screenHeight / 2;

    print("imageWidth: $imageWidth");
    print("imageHeight: $imageHeight");
    print("screenImageHeight: $screenImageHeight");
    print("screenWidth: $screenWidth");

    double x = imageWidth / (screenWidth / _x);
    double y = imageHeight / (screenImageHeight / _y);
    double width = (_width * imageWidth) / screenWidth;
    double height = (_height * imageHeight) / screenImageHeight;

    // Ajustar las coordenadas y dimensiones para el recorte
    final ImageEditorOption option = ImageEditorOption();
    option.addOption(ClipOption(x: x, y: y, width: width, height: height));

    print("_x: $x");
    print("_y: $y");
    print("width: $_width");
    print("height: $_height");

    try {
      // Realizar el recorte de la imagen
      final editedImageAux = await ImageEditor.editImage(
        image: widget.selectedImage,
        imageEditorOption: option,
      );

      // Actualizar la imagen con la imagen recortada
      if (editedImageAux != null) {
        setState(() {
          editedImage = editedImageAux;
        });
      }
    } catch (e) {
      print('Error al recortar la imagen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    void handleOptionButtonTap(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight / 2,
              color: Colors.grey.shade200,
              child: Stack(
                children: [
                  Image.memory(
                    widget.selectedImage,
                    width: double.infinity,
                    height: screenHeight / 2,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            editedImage != null
                ? Image.memory(
                    editedImage!,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Posición: ($_x, $_y), Ancho: $_width, Alto: $_height');
          cutImage();
        },
        child: Icon(Icons.done),
      ),

      //  Column(
      //   children: [
      //     Container(
      //       width: double.infinity,
      //       height: screenHeight / 1.7,
      //       color: Colors.grey.shade300,
      //       // child: Image(
      //       //   image: AssetEntityImageProvider(widget.selectedImages[0]),
      //       //   fit: BoxFit.cover,
      //       //   height: screenHeight / 1.7,
      //       //   width: double.infinity,
      //       // ),
      //       child: Image.memory(
      //         widget.selectedImage,
      //         width: double.infinity,
      //         height: screenHeight / 1.7,
      //         fit: BoxFit.cover, // Ajuste para cubrir el contenedor
      //       ),
      //     ),
      //     ElevatedButton(
      //         onPressed: () {
      //           openImageEditor();
      //         },
      //         child: Text("editar")),
      //     Align(
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           _buildOptionButton(
      //             screenWidth,
      //             () => handleOptionButtonTap(0),
      //             selectedIndex == 0,
      //             const Icon(CupertinoIcons.color_filter),
      //             borderTopLeft: const Radius.circular(30),
      //             borderBottomLeft: const Radius.circular(30),
      //           ),
      //           _buildOptionButton(
      //             screenWidth,
      //             () => handleOptionButtonTap(1),
      //             selectedIndex == 1,
      //             const Icon(Icons.filter_alt_rounded),
      //           ),
      //           _buildOptionButton(
      //             screenWidth,
      //             () => handleOptionButtonTap(2),
      //             selectedIndex == 2,
      //             const Icon(CupertinoIcons.color_filter),
      //             borderTopRight: const Radius.circular(30),
      //             borderBottomRight: const Radius.circular(30),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildOptionButton(
    double screenWidth,
    void Function() onTap,
    bool isSelected,
    Icon icon, {
    Radius? borderTopLeft,
    Radius? borderTopRight,
    Radius? borderBottomLeft,
    Radius? borderBottomRight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: (screenWidth / 1.7) / 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: borderTopLeft ?? Radius.zero,
            topRight: borderTopRight ?? Radius.zero,
            bottomLeft: borderBottomLeft ?? Radius.zero,
            bottomRight: borderBottomRight ?? Radius.zero,
          ),
          color: isSelected ? Colors.grey.shade500 : Colors.grey.shade100,
        ),
        child: icon,
      ),
    );
  }
}


//  SizedBox(
//             height: screenHeight / 1.7,
//             child: PageView.builder(
//               itemCount: widget.selectedImages.length,
//               itemBuilder: (context, index) {
//                 final image = widget.selectedImages[index];
//                 return Container(
//                   width: double.infinity,
//                   height: screenHeight / 1.7,
//                   color: Colors.grey.shade300,
//                   child: Image(
//                     image: AssetEntityImageProvider(image),
//                     fit: BoxFit.cover,
//                     height: screenHeight / 1.7,
//                     width: double.infinity,
//                   ),
//                 );
//               },
//             ),
//           ),


// SizedBox(
//   height: 110,
//   child: ListView.builder(
//     scrollDirection: Axis.horizontal,
//     itemCount: widget.selectedImages.length,
//     itemBuilder: (BuildContext context, int index) {
//       isSelectedImage = widget.selectedImages[index] == selectedImage;
//       return Padding(
//           padding: EdgeInsets.only(right: 10),
//           child: Container(
//             width: 110,
//             decoration: isSelectedImage
//                 ? BoxDecoration(
//                     border: Border.all(
//                       color: Colors.grey,
//                       width: 3,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   )
//                 : null, // Sin borde
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   selectedImage = widget.selectedImages[index];
//                 });
//               },
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8.0),
//                 child: Image(
//                   image: AssetEntityImageProvider(
//                       widget.selectedImages[index]),
//                   fit: BoxFit.cover,
//                   height: 120,
//                   width: 120,
//                 ), // Reemplaza YourChildWidget con el widget que desees mostrar dentro del contenedor
//               ),
//             ),
//           ));
//     },
//   ),
// ),
