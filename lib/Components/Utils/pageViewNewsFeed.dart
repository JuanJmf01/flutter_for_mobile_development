import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/providers/userStateProvider.dart';
import 'package:etfi_point/Screens/NewsFeed/contenidoImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageViewNewsFeed extends ConsumerWidget {
  const PageViewNewsFeed({super.key, required this.newsFeedItems});

  final List<NewsFeedItem> newsFeedItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //int? idUsuarioActual = Provider.of<UsuarioProvider>(context).idUsuarioActual;
    final int? idUsuarioActual = ref.watch(getCurrentUserProvider).value;

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

          return null;
        },
      ),
    );
  }
}
