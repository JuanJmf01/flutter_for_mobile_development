import 'dart:ffi';

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
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.urlReel));

    _controller.initialize().then((_) {
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
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: _controller.value.isInitialized
            ? Container(
              padding: EdgeInsets.only(left: 20.0),
                width:
                    double.infinity, // Ajusta este valor para cambiar el ancho del contenedor ClipRRect

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio * 1.3,
                    // Puedes ajustar este valor para cambiar el tamaño
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}



// class ShowVideoFullScreem extends StatefulWidget {
//   const ShowVideoFullScreem({super.key});

//   @override
//   State<ShowVideoFullScreem> createState() => _ShowVideoFullScreemState();
// }

// class _ShowVideoFullScreemState extends State<ShowVideoFullScreem> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           child: Stack(
//             children: [
//               PageView.builder(
//                 itemCount: ,
//                 itemBuilder: itemBuilder,
//                 )
//             ],
//           ),
//         ),
//       ),
//     )
//   }
// }
