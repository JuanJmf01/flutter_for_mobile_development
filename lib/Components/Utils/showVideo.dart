import 'package:chewie/chewie.dart';
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
                        //Aqui podriamos mostrar un icono de pausa o despausa algo asi:
                        // Center(
                        //   child: Icon(
                        //     _controller.value.isPlaying
                        //         ? Icons.pause
                        //         : Icons.play_arrow,
                        //     size: 50.0,
                        //     color: Colors.white,
                        //   ),
                        // ),
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
  late PageController _pageController;
  late List<ChewieController> _chewieControllers;

  List<String> urlReels = [];

  bool _liked = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    urlReels.add(widget.urlReel);
    urlReels.add(widget.urlReel);
    urlReels.add(widget.urlReel);

    _initializeControllers();
  }

  void _initializeControllers() {
    _pageController = PageController(initialPage: _currentPage);
    _chewieControllers = List.generate(urlReels.length, (index) {
      var videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(urlReels[index]));

      videoPlayerController.initialize().then((_) {
        if (mounted) {
          setState(() {
            _chewieControllers[index] = ChewieController(
              videoPlayerController: videoPlayerController,
              autoPlay: index == _currentPage,
              looping: true,
            );

            if (widget.savedPosition != null && index == _currentPage) {
              _chewieControllers[index]!.seekTo(widget.savedPosition!);
            }
          });
        }
      });

      videoPlayerController.setLooping(true);
      return ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onDoubleTap: () {
            setState(() {
              _liked = !_liked;
            });
          },
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              _pageController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            } else if (details.primaryVelocity! < 0) {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          },
          child: PageView.builder(
            controller: _pageController,
            itemCount: urlReels.length,
            scrollDirection: Axis.vertical, // Cambio a desplazamiento vertical

            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  _chewieControllers[index] != null
                      ? FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child:
                                Chewie(controller: _chewieControllers[index]!),
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                  if (_liked) Center(child: Icon(Icons.favorite)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _chewieControllers.forEach((controller) => controller?.dispose());
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
