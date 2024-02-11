import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Pages/NewsFeed/contenidoImages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageViewNewsFeed extends StatefulWidget {
  const PageViewNewsFeed({super.key, required this.newsFeedItems});

  final List<NewsFeedItem> newsFeedItems;

  @override
  State<PageViewNewsFeed> createState() => _PageViewNewsFeedState();
}

class _PageViewNewsFeedState extends State<PageViewNewsFeed> {
  //late PageController _pageController;
  //late List<ChewieController> _videoControllers;
  List<NewsFeedItem> newsFeedItems = [];

  @override
  void initState() {
    super.initState();
    newsFeedItems.addAll(widget.newsFeedItems);
    //manageVideo();

    //_pageController = PageController();
  }

  // void manageVideo() {
  //   _pageController = PageController();
  //   _videoControllers = List.generate(newsFeedItems.length, (index) {
  //     dynamic itemVideo = newsFeedItems[index];
  //     if (itemVideo is NeswFeedReelProductTb ||
  //         itemVideo is NeswFeedReelServiceTb ||
  //         itemVideo is NeswFeedReelPublicacionTb) {
  //       return ChewieController(
  //         videoPlayerController: VideoPlayerController.networkUrl(
  //             //Uri.parse(RecoverFieldsUtiliti.getReelPublicacion(itemVideo)!),
  //             Uri.parse(
  //                 "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4")),
  //         autoPlay: true,
  //         looping: true,
  //         showControls: false, // Oculta los controles del reproductor
  //         //aspectRatio: MediaQuery.of(context).size.aspectRatio,
  //       );
  //     } else {
  //       //Controlador en caso de un item diferente a video
  //       return ChewieController(
  //         videoPlayerController:
  //             VideoPlayerController.networkUrl(Uri.parse('')),
  //         autoPlay: false,
  //         looping: false,
  //       );
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    int? idUsuarioActual =
        Provider.of<UsuarioProvider>(context).idUsuarioActual;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enlaces"),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: newsFeedItems.length,
        itemBuilder: (context, index) {
          NewsFeedItem item = newsFeedItems[index];
          if (item is NewsFeedProductosTb ||
              item is NewsFeedServiciosTb ||
              item is NeswFeedPublicacionesTb) {
            if (idUsuarioActual != null) {
              return ContenidoImages(
                  item: item, idUsuarioActual: idUsuarioActual);
            } else {
              return const Text("Manage logueo");
            }
          }
          //  else if (item is NeswFeedReelProductTb ||
          //     item is NeswFeedReelServiceTb ||
          //     item is NeswFeedReelPublicacionTb) {
          //   return VideoFullScreen(
          //     videoItem: item,
          //     chewieController: _videoControllers[index],
          //   );
          // }
          return null;
        },
      ),
    );
  }

  // Scaffold(
  //   body: PageView.builder(
  //     scrollDirection: Axis.vertical,
  //     itemCount: newsFeedItems.length,
  //     itemBuilder: (context, index) {
  //       NewsFeedItem item = newsFeedItems[index];
  //       if (item is NewsFeedProductosTb ||
  //           item is NewsFeedServiciosTb ||
  //           item is NeswFeedPublicacionesTb) {
  //         if (idUsuarioActual != null) {
  //           return ContenidoImages(
  //               item: item, idUsuarioActual: idUsuarioActual);
  //         } else {
  //           return Text("Manage logueo");
  //         }
  //       } else if (item is NeswFeedReelProductTb ||
  //           item is NeswFeedReelServiceTb ||
  //           item is NeswFeedReelPublicacionTb) {
  //         return VideoFullScreen(
  //           videoItem: item,
  //           chewieController: _videoControllers[index],
  //         );
  //       }
  //       return null;
  //     },
  //   ),
  // );

  // Widget imageContent(NewsFeedItem item, {int? idUsuarioActual}) {
  //   return Flexible(
  //     child: GestureDetector(
  //       onVerticalDragStart: (details) {
  //         _startDragY = details.globalPosition.dy;
  //       },
  //       onVerticalDragUpdate: (details) {
  //         _currentDragY = details.globalPosition.dy;
  //       },
  //       onVerticalDragEnd: (details) {
  //         double dragDistance = _startDragY - _currentDragY;
  //         double screenHeight = MediaQuery.of(context).size.height;

  //         if (dragDistance > screenHeight * 0.1) {
  //           _pageController.nextPage(
  //               duration: Duration(milliseconds: 500), curve: Curves.ease);
  //         } else if (dragDistance < -screenHeight * 0.1) {
  //           _pageController.previousPage(
  //               duration: Duration(milliseconds: 500), curve: Curves.ease);
  //         }
  //       },
  //       child: idUsuarioActual != null ? ContenidoImages(item: item, idUsuarioActual: idUsuarioActual) : Text("Manage logueo"),
  //     ),
  //   );
  // }

  //@override
  // void dispose() {
  //   _pageController.dispose();
  //   for (var controller in _videoControllers) {
  //     controller.dispose();
  //   }
  //   super.dispose();
  // }
}

// class VideoFullScreen extends StatefulWidget {
//   const VideoFullScreen(
//       {super.key, required this.videoItem, required this.chewieController});

//   final dynamic videoItem;
//   final ChewieController chewieController;

//   @override
//   State<VideoFullScreen> createState() => _VideoFullScreeState();
// }

// class _VideoFullScreeState extends State<VideoFullScreen> {
//   late ChewieController currentController;
//   bool _isVideoPaused = false; // Variable para controlar el estado de pausa

//   @override
//   void initState() {
//     super.initState();

//     currentController = widget.chewieController;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       body: SafeArea(
//         top: false,
//         bottom: false,
//         child: GestureDetector(
//           onTap: () {
//             if (currentController.videoPlayerController.value.isPlaying) {
//               currentController.pause();
//               setState(() {
//                 _isVideoPaused = true;
//               });
//             } else {
//               currentController.play();
//               setState(() {
//                 _isVideoPaused = false;
//               });
//             }
//           },
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // Reproducción del video con restricciones explícitas
//               SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Chewie(
//                   controller: currentController,
//                 ),
//               ),
//               // Otros elementos superpuestos en la parte inferior e inferior derecha
//               OptionsScreen2(),
//               OptionsScreen()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


  // UsuarioTb usuario = UsuarioTb(idUsuario: 1, nombres: "epoeo");

    // NeswFeedReelProductTb reelProducto = NeswFeedReelProductTb(
    //   idProductEnlaceReel: 1,
    //   idProducto: 1,
    //   urlReel:
    //       "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    //   // urlReel:
    //   //     "https://firebasestorage.googleapis.com/v0/b/marketpointappi.appspot.com/o/videos%2F8%2FonlyReel%2F20240128_174648_z35g32k_WhatsApp%20Video%202023-12-10%20at%205.mp4?alt=media&token=ffd2ed6f-6f0c-4f3b-817f-b00ee6c155d0",
    //   fechaCreacion: "fechaCreacion",
    //   likes: 1,
    //   usuario: usuario,
    // );

    // newsFeedItems.add(reelProducto);