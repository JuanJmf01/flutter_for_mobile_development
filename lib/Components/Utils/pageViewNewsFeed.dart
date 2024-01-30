import 'package:chewie/chewie.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/showVideo.dart';
import 'package:etfi_point/Pages/NewsFeed/contenidoImages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class PageViewNewsFeed extends StatefulWidget {
  const PageViewNewsFeed({super.key, required this.newsFeedItems});

  final List<NewsFeedItem> newsFeedItems;

  @override
  State<PageViewNewsFeed> createState() => _PageViewNewsFeedState();
}

class _PageViewNewsFeedState extends State<PageViewNewsFeed> {
  late PageController _pageController;
  late List<ChewieController> _videoControllers;
  List<NewsFeedItem> newsFeedItems = [];

  @override
  void initState() {
    super.initState();
    newsFeedItems.addAll(widget.newsFeedItems);
    manageVideo();
  }

  void manageVideo() {
    _pageController = PageController();
    _videoControllers = List.generate(newsFeedItems.length, (index) {
      dynamic itemVideo = newsFeedItems[index];
      if (itemVideo is NeswFeedReelProductTb ||
          itemVideo is NeswFeedReelServiceTb ||
          itemVideo is NeswFeedReelPublicacionTb) {
        return ChewieController(
          videoPlayerController: VideoPlayerController.networkUrl(
              //Uri.parse(RecoverFieldsUtiliti.getReelPublicacion(itemVideo)!),
              Uri.parse(
                  "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4")),
          autoPlay: true,
          looping: true,
          showControls: false, // Oculta los controles del reproductor
        );
      } else {
        //Controlador en caso de un item diferente a video
        return ChewieController(
          videoPlayerController:
              VideoPlayerController.networkUrl(Uri.parse('')),
          autoPlay: false,
          looping: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int? idUsuarioActual =
        Provider.of<UsuarioProvider>(context).idUsuarioActual;
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: newsFeedItems.length,
        itemBuilder: (context, index) {
          NewsFeedItem item = newsFeedItems[index];
          if (item is NewsFeedProductosTb ||
              item is NewsFeedServiciosTb ||
              item is NeswFeedPublicacionesTb) {
            return ContenidoImages(
                item: item, idUsuarioActual: idUsuarioActual);
          } else if (item is NeswFeedReelProductTb ||
              item is NeswFeedReelServiceTb ||
              item is NeswFeedReelPublicacionTb) {
            return VideoFullScreen(
              videoItem: item,
              chewieController: _videoControllers[index],
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class ManageVideo extends StatefulWidget {
  const ManageVideo({super.key});

  @override
  State<ManageVideo> createState() => _ManageVideoState();
}

class _ManageVideoState extends State<ManageVideo> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class VideoFullScreen extends StatefulWidget {
  const VideoFullScreen(
      {super.key, required this.videoItem, required this.chewieController});

  final dynamic videoItem;
  final ChewieController chewieController;

  @override
  State<VideoFullScreen> createState() => _VideoFullScreeState();
}

class _VideoFullScreeState extends State<VideoFullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            // Reproducción del video con restricciones explícitas
            SizedBox(
              child: Chewie(
                controller: widget.chewieController,
              ),
            ),
            // Otros elementos superpuestos en la parte inferior e inferior derecha
            OptionsScreen2(),
            OptionsScreen()
          ],
        ),
      ),
    );
  }
}

class ImagePublicacion extends StatelessWidget {
  const ImagePublicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                width: double.infinity,
                height: 200.0,
                color: Colors.black,
              )),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Descripción de la imagen...',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}



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