import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

// Center(
//   child: Icon(
//     _controller.value.isPlaying
//         ? Icons.pause
//         : Icons.play_arrow,
//     size: 50.0,
//     color: Colors.white,
//   ),
// ),

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
                        //Aqui podriamos mostrar un icono de pausa o despausa algo asi:
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
                              duration: Duration(milliseconds: 10),
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
                Positioned.fill(
                  child: Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 60,
                      color: Colors.white70,
                    ),
                  ),
                ),
              OptionsScreen(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 110),
                  Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person, size: 18),
                        radius: 16,
                      ),
                      SizedBox(width: 6),
                      Text('flutter_developer02'),
                      SizedBox(width: 10),
                      Icon(Icons.verified, size: 15),
                      SizedBox(width: 6),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 6),
                  Text('Flutter is beautiful and fast 💙❤💛 ..'),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 15,
                      ),
                      Text('Original Audio - some music track--'),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.favorite_outline),
                  Text('601k'),
                  SizedBox(height: 20),
                  Icon(Icons.comment_rounded),
                  Text('1123'),
                  SizedBox(height: 20),
                  Transform(
                    transform: Matrix4.rotationZ(5.8),
                    child: Icon(Icons.send),
                  ),
                  SizedBox(height: 50),
                  Icon(Icons.more_vert),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
