import 'package:etfi_point/Components/Data/EntitiModels/enlaces/ratingsEnlaceProServicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/publicacionesTb.dart';
import 'package:etfi_point/Components/Data/Entities/enlaces/ratingsEnlaceProServicioDb.dart';
import 'package:etfi_point/Components/Data/Entities/newsFeedDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/publicacionesDb.dart';
import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
import 'package:etfi_point/Components/Utils/Icons/icons.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/pageViewImagesScroll.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/ButtonMenu.dart';
import 'package:etfi_point/Components/Utils/showVideo.dart';
import 'package:etfi_point/Pages/proServicios/proServicioDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) => ButtonMenu(),
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
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(30.0), // Ajusta la altura de la pestaña

          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Tiendas que sigo',
              ),
              Tab(text: 'Todas las tiendas'),
            ],
            labelStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight
                    .w500), // Cambia el tamaño del texto de la pestaña activa
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          //Text("Solo texto"),
          TiendasQueSigo(),
          Center(child: Text('Contenido del Tab 2')),
        ],
      ),
    );
  }
}

class TiendasQueSigo extends StatelessWidget {
  const TiendasQueSigo({Key? key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Historias(),
            NewsFeed(),
            // Otros elementos si es necesario
          ]),
        ),
      ],
    );
  }
}

class Historias extends StatelessWidget {
  Historias({super.key});

  final List<String> UserStories = [
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
        itemCount: UserStories.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 10.0, 0, 5.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey.shade300,
              ),
              width: 120,
              child: Center(child: Text(UserStories[index])),
            ),
          );
        },
      ),
    );
  }
}

class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key});

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  double paddingTopEachPublicacion = 40.0;
  double paddingMedia = 20.0;
  Map<int, bool> isLikedMap = {};

  void heart() {
    print("Funciona");
  }

  void navigateToServiceOrProductDetail(Type objectType, int idProServicio) {
    if (objectType == NewsFeedProductosTb ||
        objectType == NeswFeedReelProductTb) {
      navigateToProductDetail(idProServicio);
    } else if (objectType == NewsFeedServiciosTb ||
        objectType == NeswFeedReelServiceTb) {
      navigateToServiceDetail(idProServicio);
    }
  }

  void navigateToServiceDetail(int idServicio) {
    ServicioDb.getServicio(idServicio).then((servicio) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProServicioDetail(proServicio: servicio),
        ),
      );
    });
  }

  void navigateToProductDetail(int idProducto) {
    ProductoDb.getProducto(idProducto).then((producto) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProServicioDetail(proServicio: producto),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuarioActual;

    return FutureBuilder<NewsFeedTb>(
        future: idUsuario != null ? NewsFeedDb.getAllNewsFeed(idUsuario) : null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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

                    if (item is NewsFeedProductosTb) {
                      return contenidoImages(
                        item.descripcion ?? '',
                        item.enlaceProductoImages,
                        NewsFeedProductosTb,
                        index,
                        likes: item.likes,
                        idPublicacion: item.idEnlaceProducto,
                        idProServicio: item.idProducto,
                        idUsuario: idUsuario,
                      );
                    } else if (item is NewsFeedServiciosTb) {
                      return contenidoImages(
                        item.descripcion ?? '',
                        item.enlaceServicioImages,
                        NewsFeedServiciosTb,
                        index,
                        idPublicacion: item.idEnlaceServicio,
                        idProServicio: item.idServicio,
                        idUsuario: idUsuario,
                      );
                    } else if (item is NeswFeedPublicacionesTb) {
                      return contenidoImages(
                        item.descripcion ?? '',
                        item.enlacePublicacionImages,
                        NeswFeedPublicacionesTb,
                        index,
                        idUsuario: idUsuario,
                        idPublicacion: item.idFotoPublicacion,
                      );
                    }
                    // } else if (item is NeswFeedReelProductTb) {
                    //   return contenidoReels(
                    //     item.descripcion ?? '',
                    //     item.urlReel,
                    //     NeswFeedReelProductTb,
                    //     idPublicacion: item.idProductEnlaceReel,
                    //     idUsuario: idUsuario,
                    //   );
                    // } else if (item is NeswFeedReelServiceTb) {
                    //   return contenidoReels(item.descripcion ?? '',
                    //       item.urlReel, NeswFeedReelServiceTb,
                    //       idPublicacion: item.idServiceEnlaceReel,
                    //       idUsuario: idUsuario);
                    // } else if (item is NeswFeedOnlyReelTb) {
                    //   return contenidoReels(
                    //     item.descripcion ?? '',
                    //     item.urlReel,
                    //     NeswFeedOnlyReelTb,
                    //     idUsuario: idUsuario,
                    //     idPublicacion: item.idReelPublicacion,
                    //   );
                    // }
                    return null;
                  },
                ),
              );
            } else {
              return Text('La lista está vacía');
            }
          } else if (snapshot.hasError) {
            return const Text('Error al obtener los datos');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget contenidoImages(
      String descripcion, List<dynamic> images, Type objectType, int index,
      {int? likes, int? idPublicacion, int? idProServicio, int? idUsuario}) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTopEachPublicacion),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Contenido parte superior de cada publicacion
          contenidoParteSuperior(),
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 8.0, 0.0, 0.0),
            child: Text(
              descripcion,
              style: TextStyle(fontSize: 16.8),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(paddingMedia, 10.0, 0.0, 0.0),
            child: Container(
              width: 355,
              height: 365,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: PageViewImagesScroll(images: images),
            ),
          ),
          filaIconos(objectType,
              like: likes,
              idPublicacion: idPublicacion,
              idUsuario: idUsuario,
              index: index)
        ],
      ),
    );
  }

  Widget filaIconos(Type objectType,
      {int? like, int? idPublicacion, int? idUsuario, required int index}) {
    bool isLiked =
        isLikedMap[index] ?? (like == 1); // Asumimos 'false' si es nulo

    void crearRatingEnlaceProServicio() {
      print('Like: $isLiked');
      if (idUsuario != null && idPublicacion != null) {
        RatingsEnlaceProServicioTb ratingEnlaceProducto =
            RatingsEnlaceProServicioTb(
                idUsuario: idUsuario,
                idEnlaceProServicio: idPublicacion,
                likes: isLiked ? 0 : 1);

        RatingsEnlaceProServicioDb.saveRating(
            idPublicacion, idUsuario, ratingEnlaceProducto, objectType);
      }
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(paddingMedia + 5.0, 5.0, 0.0, 0.0),
      child: Row(
        children: [
          isLiked == true
              ? FutureBuilder<void>(
                  // Use FutureBuilder para asegurar la actualización inmediata del estado
                  future: Future<void>.delayed(Duration.zero),
                  builder: (context, snapshot) {
                    return HeartSolidIcon(
                      size: 33.0,
                      color: Colors.red,
                      onTap: () {
                        setState(() {
                          isLikedMap[index] = false;
                        });
                      },
                    );
                  },
                )
              : HeartIcon(
                  size: 33.0,
                  onTap: () {
                    setState(() {
                      isLikedMap[index] = true;
                    });
                    crearRatingEnlaceProServicio();
                  },
                ),
        ],
      ),
    );
  }

  Widget contenidoParteSuperior() {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.grey.shade200),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 7.0),
          child: Text(
            'Bussines name',
            style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }

  //   void crearRatingPublicacion() {
  //   if (idUsuario != null && idPublicacion != null) {
  //     RatingsPublicacionesTb ratingPublicacion = RatingsPublicacionesTb(
  //         idUsuario: idUsuario,
  //         idPublicacion: idPublicacion,
  //         likes: isLiked ? 0 : 1);

  //     PublicacionesDb.saveRating(
  //         idPublicacion, idUsuario, ratingPublicacion, objectType);
  //   }
  // }

  // Widget contenidoReels(
  //   String descripcion,
  //   String urlReel,
  //   Type objectType, {
  //   int? idPublicacion,
  //   int? idUsuario,
  // }) {
  //   return Padding(
  //     padding: EdgeInsets.only(top: paddingTopEachPublicacion),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         contenidoParteSuperior(),
  //         Padding(
  //           padding: EdgeInsets.fromLTRB(15.0, 8.0, 0.0, 10.0),
  //           child: Text(
  //             descripcion,
  //             style: TextStyle(fontSize: 16.8),
  //           ),
  //         ),
  //         ShowVideo(
  //           urlReel:
  //               "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
  //         ),
  //         // Fila de iconos
  //         filaIconos(objectType,
  //             idPublicacion: idPublicacion, idUsuario: idUsuario)
  //       ],
  //     ),
  //   );
  // }

  // iconWidget(CupertinoIcons.heart, heart, paddingLeft: 5.0),
  // iconWidget(CupertinoIcons.chat_bubble_text, heart,
  //     paddingLeft: 5.0, iconSize: 33),
  // iconWidget(CupertinoIcons.share, heart,
  //     paddingLeft: 5.0, iconSize: 32.0),
  // Spacer(),
  // idProServicio != null
  //     ? iconWidget(CupertinoIcons.arrow_turn_up_right, () {
  //         navigateToServiceOrProductDetail(
  //           objectType,
  //           idProServicio,
  //         );
  //       }, paddingRight: 15.0)
  //     : SizedBox.shrink()

  Widget iconWidget(IconData icon, VoidCallback onPress,
      {double? paddingRight, double? paddingLeft, double? iconSize}) {
    return Padding(
      padding:
          EdgeInsets.only(right: paddingRight ?? 0.0, left: paddingLeft ?? 0.0),
      child: IconButton(
        icon: Icon(
          icon,
          size: iconSize ?? 35.0,
          color: Colors.black87,
        ),
        onPressed: onPress,
      ),
    );
  }
}

class HorizontalList extends StatelessWidget {
  const HorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255,
      child: ListView.separated(
        padding: EdgeInsets.all(15.0),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (context, _) => SizedBox(width: 12),
        itemBuilder: (context, index) => buildCard(),
      ),
    );
  }

  Widget buildCard() => Container(
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
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Prueba title',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      );
}
