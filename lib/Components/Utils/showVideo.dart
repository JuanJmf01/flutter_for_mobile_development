import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ShowVideo extends StatefulWidget {
  const ShowVideo({
    super.key,
    required this.urlReel,
  });

  final String urlReel;

  @override
  State<ShowVideo> createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  late VideoPlayerController _controller;
  Duration? _savedPosition; // Guarda la posición del video al hacer clic
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.urlReel));

    _controller.initialize().then((_) {
      if (_savedPosition != null) {
        _controller
            .seekTo(_savedPosition!); // Mueve el video a la posición guardada
      }
      if (mounted) {
        setState(() {});
      }
    });

    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.urlReel),
      onVisibilityChanged: (visibilityInfo) {
        if (mounted) {
          setState(() {
            _isVisible = visibilityInfo.visibleFraction > 0.5;
            if (_isVisible &&
                _controller.value.isInitialized &&
                !_controller.value.isPlaying) {
              _controller.play();
            } else if (!_isVisible && _controller.value.isPlaying) {
              _controller.pause();
            }
          });
        }
      },
      child: _controller.value.isInitialized
          ? GestureDetector(
              onTap: () async {
                _savedPosition =
                    await _controller.position; // Guarda la posición actual

                if (mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ShowVideoFullScreen(
                        urlReel: widget.urlReel,
                        savedPosition: _savedPosition,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.only(left: 20.0),
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio * 1.2,
                    child: Stack(
                      children: [
                        VideoPlayer(_controller),
                        //Aqui podriamos mostrar un icono de pausa o despausa
                      ],
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ShowVideoFullScreen extends StatefulWidget {
  const ShowVideoFullScreen(
      {Key? key, required this.urlReel, this.savedPosition})
      : super(key: key);

  final String urlReel;
  final Duration? savedPosition;

  @override
  State<ShowVideoFullScreen> createState() => _ShowVideoFullScreenState();
}

class _ShowVideoFullScreenState extends State<ShowVideoFullScreen> {
  //late VideoPlayerController _videoPlayerController;
  //ChewieController? _chewieController;
  late PageController _pageController;
  bool _liked = false;
  bool _isVideoPaused = false; // Variable para controlar el estado de pausa

  bool _isVideoInitialized = false;
  double _currentSliderValue = 0.0; // Valor actual de la barra de progreso

  int _currentPage = 0; // Mantener el seguimiento de la página actual
  int maxPage = 0;

  List<ChewieController> chewieControllers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    //Este metodo solo se ejecuta dentro del initState al cambiar de pestaña de reels
    _pageController.addListener(_handlePageChange);

    _initializeChewieControllers(
      widget.urlReel,
      true,
      savedPosition: widget.savedPosition,
    );
    nextReel();
  }

  void _handlePageChange() {
    if (_pageController.page != null) {
      int lastPage = _currentPage;

      setState(() {
        _currentPage = _pageController.page!.round();
      });

      _updatePlayback(_currentPage);

      if (_currentPage > lastPage && maxPage == (_currentPage - 1)) {
        nextReel();
        setState(() {
          maxPage = _currentPage;
        });
      }
    }
  }

  void _updatePlayback(int pageIndex) {
    for (int i = 0; i < chewieControllers.length; i++) {
      if (i == pageIndex) {
        // Esta página es la que esta actualmente en pantalla, por lo que debería reproducirse
        chewieControllers[i].play();
        setState(() {
          _isVideoPaused = false;
        });
      } else {
        // Las demás páginas estan fuera de la pantalla, por lo que deberian pausarse
        chewieControllers[i].pause();
      }
    }
  }

  void _initializeChewieControllers(String urlReel, bool autoPlay,
      {Duration? savedPosition}) {
    VideoPlayerController videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(urlReel));

    videoPlayerController.addListener(() {
      if (videoPlayerController.value.isPlaying) {
        if (mounted) {
          setState(() {
            _currentSliderValue =
                videoPlayerController.value.position.inSeconds.toDouble();
          });
        }
      }
    });

    videoPlayerController.initialize().then((_) {
      if (savedPosition != null) {
        videoPlayerController
            .seekTo(savedPosition); // Mueve el video a la posición guardada
      }
      if (mounted) {
        ChewieController chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: autoPlay,
          looping: true,
          showControls: false,
          showControlsOnInitialize: false,
          //aspectRatio: MediaQuery.of(context).size.aspectRatio,
        );
        setState(() {
          _isVideoInitialized = true;
          chewieControllers.add(chewieController);
        });
      }
    });

    videoPlayerController.setLooping(true);
  }

  void nextReel() {
    //Hacer consulta sql para nuevo reel
    String nextUrlReel = widget.urlReel;

    _initializeChewieControllers(nextUrlReel, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        top: false,
        bottom: false,
        child: GestureDetector(
          onTap: () {
            if (_currentPage >= 0 && _currentPage < chewieControllers.length) {
              ChewieController currentController =
                  chewieControllers[_currentPage];

              if (currentController.videoPlayerController.value.isPlaying) {
                currentController.pause();
                setState(() {
                  _isVideoPaused = true;
                });
              } else {
                currentController.play();
                setState(() {
                  _isVideoPaused = false;
                });
              }
            }
          },
          onDoubleTap: () {
            setState(() {
              _liked = !_liked;
            });
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                itemCount: chewieControllers.length,
                scrollDirection: Axis.vertical,
                controller: _pageController,
                itemBuilder: (BuildContext context, int index) {
                  return _isVideoInitialized
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // Ancho igual al de la pantalla
                              child:
                                  Chewie(controller: chewieControllers[index]),
                            ),
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 300),
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: LinearProgressIndicator(
                                value: (_currentSliderValue /
                                        chewieControllers[index]
                                            .videoPlayerController
                                            .value
                                            .duration
                                            .inSeconds)
                                    .toDouble(),
                                minHeight: 3.5,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey.shade600),
                              ),
                            ),
                          ],
                        )
                      : Center(child: CircularProgressIndicator());
                },
              ),
              // Otros widgets adicionales
              if (_liked) Center(child: Icon(Icons.favorite)),
              if (_isVideoPaused) // Mostrar el botón de pausa si está pausado
                const Positioned.fill(
                  child: Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 60,
                      color: Colors.white70,
                    ),
                  ),
                ),
              OptionsScreen(),
              OptionsScreen2(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (ChewieController? controller in chewieControllers) {
      controller?.dispose();
    }
    super.dispose();
  }
}

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 0.0, 8.0, 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.grey.shade400),
                    width: 45.0,
                    height: 45.0,
                  ),
                ),
                const Text(
                  "Nombre usuario",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 5.0),
              child: Text(
                "Esta es mi descripcion, larga o corta... 😘🍟🍾",
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ));
  }
}

class OptionsScreen2 extends StatelessWidget {
  const OptionsScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    double iconsSize = 35.0;
    Color iconColor = Colors.white;
    FontWeight iconFontWeight = FontWeight.w700;

    void handleIconTap(BuildContext context, int index) {
      // Agrega lógica para manejar el clic en los íconos aquí
      // Por ejemplo, podrías llamar a funciones diferentes dependiendo del ícono presionado
      switch (index) {
        case 0: // Ícono del corazón
          print("Corazon");
          break;
        case 1: // Ícono del chat
          print("Chat");
          break;
        case 2: // Ícono de compartir
          print("compartir");

        case 3: // Ícono del enlace
          print("enlace");
          break;
        default:
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: FractionallySizedBox(
            heightFactor: 0.6,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => handleIconTap(context, 0),
                        child: Icon(
                          CupertinoIcons.heart,
                          size: iconsSize,
                          color: iconColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "313.3",
                          style: TextStyle(
                            color: iconColor,
                            fontWeight: iconFontWeight,
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => handleIconTap(context, 1),
                        child: Icon(
                          CupertinoIcons.chat_bubble,
                          size: iconsSize,
                          color: iconColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "313.3",
                          style: TextStyle(
                            color: iconColor,
                            fontWeight: iconFontWeight,
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => handleIconTap(context, 2),
                        child: Icon(
                          CupertinoIcons.paperplane,
                          size: iconsSize,
                          color: iconColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "313.3",
                          style: TextStyle(
                            color: iconColor,
                            fontWeight: iconFontWeight,
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => handleIconTap(context, 3),
                    child: Icon(
                      CupertinoIcons.arrow_turn_up_right,
                      color: iconColor,
                      size: iconsSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // Otros widgets aquí
    );
  }
}
