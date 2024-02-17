import 'package:etfi_point/Data/models/newsFeedTb.dart';
import 'package:etfi_point/Data/services/api/newsFeedDb.dart';
import 'package:etfi_point/components/widgets/showModalsButtons/ButtonMenu.dart';
import 'package:etfi_point/Data/services/providers/userStateProvider.dart';
import 'package:etfi_point/Screens/NewsFeed/imagePostContent.dart';
import 'package:etfi_point/Screens/NewsFeed/contenidoReels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // UTILIZAR  LA CLASE globalButtonBase EN LA CLASE ButtonMenu
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) => const ButtonMenu(),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: const NewsFeed(),
    );
  }
}

class NewsFeed extends StatelessWidget {
  const NewsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Historias(),
            const NewsFeedContent(),
            // Otros elementos si es necesario
          ]),
        ),
      ],
    );
  }
}

class Historias extends StatelessWidget {
  Historias({super.key});

  final List<String> userStories = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: userStories.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 10.0, 0, 5.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey.shade300,
              ),
              width: 120,
              child: Center(child: Text(userStories[index])),
            ),
          );
        },
      ),
    );
  }
}

class NewsFeedContent extends ConsumerWidget {
  const NewsFeedContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int? idUsuarioActual = ref.watch(getCurrentUserProvider).value;

    return FutureBuilder<NewsFeedTb>(
        future: idUsuarioActual != null
            ? NewsFeedDb.getAllNewsFeed(idUsuarioActual)
            : null, //En caso de que no existe idUsuarioActual debemos mostrar NewsFeed publicas de cualquier otra cuenta
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            NewsFeedTb newsFeed = snapshot.data!;
            List<NewsFeedItem> items = newsFeed.newsFeed;
            if (items.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // Evita el desplazamiento independiente de este ListView
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    NewsFeedItem item = items[index];
                    if (item is NewsFeedServiciosTb ||
                        item is NewsFeedProductosTb ||
                        item is NeswFeedPublicacionesTb) {
                      if (idUsuarioActual != null) {
                        return ImagePostContent(
                          item: item,
                          idUsuarioActual: idUsuarioActual,
                        );
                      } else {
                        return const Text("Manage logueo");
                      }
                    } else if (item is NeswFeedReelServiceTb ||
                        item is NeswFeedReelPublicacionTb ||
                        item is NeswFeedReelProductTb) {
                      if (idUsuarioActual != null) {
                        return ContenidoReels(
                          item: item,
                          idUsuarioActual: idUsuarioActual,
                        );
                      } else {
                        return const Text("Manage logueo");
                      }
                    }
                    return null;
                  },
                ),
              );
            } else {
              return const Text('La lista está vacía');
            }
          } else if (snapshot.hasError) {
            return const Text('Error al obtener los datos');
          } else {
            return const Center(child: Text("No hay newsFeed que mostrar"));
          }
        });
  }
}

class HorizontalList extends StatelessWidget {
  const HorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 255,
      child: ListView.separated(
        padding: const EdgeInsets.all(15.0),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (context, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) => buildCard(),
      ),
    );
  }

  Widget buildCard() => SizedBox(
        width: 200,
        //color: Colors.redAccent.shade200,
        child: Column(
          children: [
            Expanded(
                child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(33.0),
                      child: Container(
                        color:
                            Colors.grey[200], //Intercambior por iamgen  (abajo)
                      ),
                      // child: Material(
                      //   child: Ink.image(
                      //     image: AssetImage('lib/images/PapasSaladas.jpg'),
                      //     fit: BoxFit.cover,
                      //     child: InkWell(
                      //       onTap: (){},
                      //     ),
                      //   ),
                      // )
                    ))),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'Prueba title',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      );
}
