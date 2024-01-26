import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/enlaces/ratingsEnlaceProServicioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/Publicaciones/noEnlaces/ratingsPublicacionesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Data/Entities/Publicaciones/enlaces/ratingsEnlaceProServicioDb.dart';
import 'package:etfi_point/Components/Data/Entities/Publicaciones/no%20enlaces/ratingsFotoAndReelPublicacionDb.dart';
import 'package:etfi_point/Components/Data/Entities/newsFeedDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
import 'package:etfi_point/Components/Utils/Icons/icons.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/pageViewImagesScroll.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/ButtonMenu.dart';
import 'package:etfi_point/Components/Utils/showVideo.dart';
import 'package:etfi_point/Pages/proServicios/proServicioDetail.dart';
import 'package:etfi_point/main.dart';
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
                // UTILIZAR  LA CLASE globalButtonBase EN LA CLASE ButtonMenu
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
    int? idUsuarioActual =
        Provider.of<UsuarioProvider>(context).idUsuarioActual;

    return FutureBuilder<NewsFeedTb>(
        future: idUsuarioActual != null
            ? NewsFeedDb.getAllNewsFeed(idUsuarioActual)
            : null,
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
                        item.usuario,
                        likes: item.likes,
                        idPublicacion: item.idEnlaceProducto,
                        idProServicio: item.idProducto,
                        idUsuarioActual: idUsuarioActual,
                      );
                    } else if (item is NewsFeedServiciosTb) {
                      return contenidoImages(
                        item.descripcion ?? '',
                        item.enlaceServicioImages,
                        NewsFeedServiciosTb,
                        index,
                        item.usuario,
                        likes: item.likes,
                        idPublicacion: item.idEnlaceServicio,
                        idProServicio: item.idServicio,
                        idUsuarioActual: idUsuarioActual,
                      );
                    } else if (item is NeswFeedPublicacionesTb) {
                      return contenidoImages(
                        item.descripcion ?? '',
                        item.enlacePublicacionImages,
                        NeswFeedPublicacionesTb,
                        index,
                        item.usuario,
                        likes: item.likes,
                        idUsuarioActual: idUsuarioActual,
                        idPublicacion: item.idFotoPublicacion,
                      );
                    } else if (item is NeswFeedReelProductTb) {
                      return contenidoReels(
                        item.descripcion ?? '',
                        item.urlReel,
                        index,
                        item.usuario,
                        NeswFeedReelProductTb,
                        likes: item.likes,
                        idPublicacion: item.idProductEnlaceReel,
                        idProServicio: item.idProducto,
                        idUsuarioActual: idUsuarioActual,
                      );
                    } else if (item is NeswFeedReelServiceTb) {
                      return contenidoReels(
                        item.descripcion ?? '',
                        item.urlReel,
                        index,
                        item.usuario,
                        NeswFeedReelServiceTb,
                        likes: item.likes,
                        idPublicacion: item.idServiceEnlaceReel,
                        idProServicio: item.idServicio,
                        idUsuarioActual: idUsuarioActual,
                      );
                    } else if (item is NeswFeedReelPublicacionTb) {
                      return contenidoReels(
                        item.descripcion ?? '',
                        item.urlReel,
                        index,
                        item.usuario,
                        NeswFeedReelPublicacionTb,
                        likes: item.likes,
                        idUsuarioActual: idUsuarioActual,
                        idPublicacion: item.idReelPublicacion,
                      );
                    }
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

  Widget contenidoImages(String descripcion, List<dynamic> images,
      Type objectType, int index, UsuarioTb usuario,
      {int? likes,
      int? idPublicacion,
      int? idProServicio,
      int? idUsuarioActual}) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTopEachPublicacion),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Contenido parte superior de cada publicacion
          contenidoParteSuperior(usuario.idUsuario, usuario.nombres,
              urlFotoPerfil: usuario.urlFotoPerfil),
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
          filaIconos(objectType, index,
              like: likes,
              idPublicacion: idPublicacion,
              idProServicio: idProServicio,
              idUsuarioActual: idUsuarioActual)
        ],
      ),
    );
  }

  Widget filaIconos(Type objectType, int index,
      {int? like,
      int? idPublicacion,
      int? idProServicio,
      int? idUsuarioActual}) {
    bool isLiked =
        isLikedMap[index] ?? (like == 1); // Asumimos 'false' si es nulo
    double iconSize = 32.0;
    double iconPaddingRight = 20.0;

    void saveRatingEnlaceProServicio() {
      print('Like: $isLiked');
      if (idUsuarioActual != null && idPublicacion != null) {
        RatingsEnlaceProServicioTb ratingEnlaceProducto =
            RatingsEnlaceProServicioTb(
                idUsuario: idUsuarioActual,
                idEnlaceProServicio: idPublicacion,
                likes: isLiked ? 0 : 1);

        RatingsEnlaceProServicioDb.saveRating(
            idPublicacion, idUsuarioActual, ratingEnlaceProducto, objectType);
      }
    }

    void saveRatingPublicacion() {
      if (idUsuarioActual != null && idPublicacion != null) {
        RatingsPublicacionesTb ratingPublicacion = RatingsPublicacionesTb(
            idUsuario: idUsuarioActual,
            idPublicacion: idPublicacion,
            likes: isLiked ? 0 : 1);

        RatingsFotoAndReelPublicacionDb.saveRating(
            idPublicacion, idUsuarioActual, ratingPublicacion, objectType);
      }
    }

    void handleLike(bool like) {
      setState(() {
        isLikedMap[index] = like;
      });
      if (objectType == NeswFeedReelPublicacionTb ||
          objectType == NeswFeedPublicacionesTb) {
        saveRatingPublicacion();
      } else {
        saveRatingEnlaceProServicio();
      }
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(paddingMedia, 10.0, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isLiked == true
              ? FutureBuilder<void>(
                  // Use FutureBuilder para asegurar la actualización inmediata del estado
                  future: Future<void>.delayed(Duration.zero),
                  builder: (context, snapshot) {
                    return ManageIcon(
                      size: iconSize,
                      icon: CupertinoIcons.heart_fill,
                      color: Colors.red,
                      paddingLeft: 10.0,
                      paddingRight: 15.0,
                      onTap: () => handleLike(false),
                    );
                  },
                )
              : ManageIcon(
                  icon: CupertinoIcons.heart,
                  size: iconSize,
                  paddingLeft: 10.0,
                  paddingRight: iconPaddingRight,
                  onTap: () => handleLike(true),
                ),
          ManageIcon(
            size: iconSize,
            paddingRight: iconPaddingRight,
            icon: CupertinoIcons.chat_bubble_text,
          ),
          ManageIcon(
            size: iconSize,
            paddingRight: iconPaddingRight,
            icon: CupertinoIcons.paperplane,
          ),
          ManageIcon(
            icon: CupertinoIcons.square,
            paddingRight: iconPaddingRight,
            size: iconSize,
          ),
          Spacer(),
          idProServicio != null
              ? ManageIcon(
                  icon: CupertinoIcons.arrow_turn_up_right,
                  size: iconSize,
                  paddingRight: 10.0,
                  onTap: () {
                    navigateToServiceOrProductDetail(objectType, idProServicio);
                  },
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }

  Widget contenidoParteSuperior(
    int idUsuario,
    String nombreUsuario, {
    String? urlFotoPerfil,
  }) {
    BorderRadius borderImageProfile = BorderRadius.circular(50.0);
    double sizeImageProfile = 53.0;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(
              currentIndex: 1,
              idUsuario: idUsuario,
            ),
          ),
        );
      },
      child: Row(
        children: [
          urlFotoPerfil != null && urlFotoPerfil != ''
              ? ShowImage(
                  networkImage: urlFotoPerfil,
                  widthNetWork: sizeImageProfile,
                  heightNetwork: sizeImageProfile,
                  borderRadius: borderImageProfile,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: sizeImageProfile,
                  width: sizeImageProfile,
                  decoration: BoxDecoration(
                      borderRadius: borderImageProfile,
                      color: Colors.grey.shade200),
                ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 7.0),
            child: Text(
              nombreUsuario,
              style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  Widget contenidoReels(
    String descripcion,
    String urlReel,
    int index,
    UsuarioTb usuario,
    Type objectType, {
    int? likes,
    int? idPublicacion,
    int? idProServicio,
    int? idUsuarioActual,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTopEachPublicacion),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          contenidoParteSuperior(usuario.idUsuario, usuario.nombres),
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 8.0, 0.0, 10.0),
            child: Text(
              descripcion,
              style: TextStyle(fontSize: 16.8),
            ),
          ),
          ShowVideo(
            urlReel:
                "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
          ),
          // Fila de iconos
          filaIconos(objectType, index,
              like: likes,
              idPublicacion: idPublicacion,
              idProServicio: idProServicio,
              idUsuarioActual: idUsuarioActual)
        ],
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
