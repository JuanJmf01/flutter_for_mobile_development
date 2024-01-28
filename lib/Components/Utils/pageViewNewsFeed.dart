import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/enlacePublicacionesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:flutter/material.dart';

class PageViewNewsFeed extends StatelessWidget {
  const PageViewNewsFeed({super.key, required this.newsFeedItems});

  final List<NewsFeedItem> newsFeedItems;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: newsFeedItems.length,
      itemBuilder: (context, index) {
        NewsFeedItem item = newsFeedItems[index];
        if (item is EnlacePublicacionesTb) {
          return const ImagePublicacion();
        } else if (item is NeswFeedReelProductTb) {
          // Mostrar video, descripcionVideo, like, likes, comentarios, datos usuario
        }
      },
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
                width: 200.0,
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
