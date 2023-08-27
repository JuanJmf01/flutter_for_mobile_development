// import 'package:flutter/material.dart';

// class ImageList extends StatelessWidget {
//   const ImageList({
//     super.key,
//     this.padding
  
//   });

//   final EdgeInsets? padding;
//   final double maxHeight;



//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
//       child: Container(
//         constraints: const BoxConstraints(
//           maxHeight: 260, // Altura máxima para la lista de imágenes
//         ),
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: selectedImages.length,
//           itemBuilder: (BuildContext context, int index) {
//             final image = selectedImages[index];
//             double originalWidth = image.newImage.originalWidth!.toDouble();
//             double originalHeight = image.newImage.originalHeight!.toDouble();
//             double desiredWidth = 600.0;
//             double desiredHeight =
//                 desiredWidth * (originalHeight / originalWidth);

//             bool isSelected = principalImage == image.newImage;

//             return Column(
//               children: [
//                 Expanded(
//                     child: Padding(
//                   padding: const EdgeInsets.fromLTRB(5.0, 0.0, 4.0, 8.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         principalImage = image.newImage;
//                       });
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20.0),
//                           border: isSelected
//                               ? Border.all(color: Colors.blue, width: 4.5)
//                               : null),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(16.0),
//                         child: AssetThumb(
//                           asset: image.newImage,
//                           width: desiredWidth.toInt(),
//                           height: desiredHeight.toInt(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )),
//                 if (isSelected)
//                   Text(
//                     'Imagen principal',
//                     style: TextStyle(
//                         color: Colors.grey.shade400,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
