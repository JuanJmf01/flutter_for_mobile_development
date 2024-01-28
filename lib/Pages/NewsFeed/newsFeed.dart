import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/Entities/newsFeedDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/ButtonMenu.dart';
import 'package:etfi_point/Pages/NewsFeed/contenidoImages.dart';
import 'package:etfi_point/Pages/NewsFeed/contenidoReels.dart';
import 'package:etfi_point/Pages/proServicios/proServicioDetail.dart';
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
        children: const [
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
                      return ContenidoImages(
                        descripcion: item.descripcion ?? '',
                        images: item.enlaceProductoImages,
                        objectType: NewsFeedProductosTb,
                        index: index,
                        usuario: item.usuario,
                        likes: item.likes,
                        idPublicacion: item.idEnlaceProducto,
                        idProServicio: item.idProducto,
                        idUsuarioActual: idUsuarioActual,
                      );
                    } else if (item is NewsFeedServiciosTb) {
                      return ContenidoImages(
                        descripcion: item.descripcion ?? '',
                        images: item.enlaceServicioImages,
                        objectType: NewsFeedServiciosTb,
                        index: index,
                        usuario: item.usuario,
                        likes: item.likes,
                        idPublicacion: item.idEnlaceServicio,
                        idProServicio: item.idServicio,
                        idUsuarioActual: idUsuarioActual,
                      );
                    } else if (item is NeswFeedPublicacionesTb) {
                      return ContenidoImages(
                        descripcion: item.descripcion ?? '',
                        images: item.enlacePublicacionImages,
                        objectType: NewsFeedServiciosTb,
                        index: index,
                        usuario: item.usuario,
                        likes: item.likes,
                        idPublicacion: item.idFotoPublicacion,
                        idUsuarioActual: idUsuarioActual,
                      );
                    } else if (item is NeswFeedReelProductTb) {
                      return ContenidoReels(
                        descripcion: item.descripcion ?? '',
                        urlReel: item.urlReel,
                        index: index,
                        usuario: item.usuario,
                        objectType: NeswFeedReelProductTb,
                        likes: item.likes,
                        idPublicacion: item.idProductEnlaceReel,
                        idProServicio: item.idProducto,
                        idUsuarioActual: idUsuarioActual,
                      );
                    } else if (item is NeswFeedReelServiceTb) {
                      return ContenidoReels(
                        descripcion: item.descripcion ?? '',
                        urlReel: item.urlReel,
                        index: index,
                        usuario: item.usuario,
                        objectType: NeswFeedReelServiceTb,
                        likes: item.likes,
                        idPublicacion: item.idServiceEnlaceReel,
                        idProServicio: item.idServicio,
                        idUsuarioActual: idUsuarioActual,
                      );
                    } 
                    // else if (item is NeswFeedReelPublicacionTb) {
                    //   return ContenidoReels2(
                    //     item: item,
                    //     index: index,
                    //     idUsuarioActual: idUsuarioActual,
                    //   );
                    // }
                    // else if (item is NeswFeedReelPublicacionTb) {
                    //   return ContenidoReels(
                    //     descripcion: item.descripcion ?? '',
                    //     urlReel: item.urlReel,
                    //     index: index,
                    //     usuario: item.usuario,
                    //     objectType: NeswFeedReelPublicacionTb,
                    //     likes: item.likes,
                    //     idPublicacion: item.idReelPublicacion,
                    //     idUsuarioActual: idUsuarioActual,
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
}

// class ContenidoReels2 extends StatelessWidget {
//   const ContenidoReels2({
//     super.key,
//     required this.item,
//     required this.index,
//     this.idProServicio,
//     required this.idUsuarioActual,
//   });

//   final NewsFeedItem item;
//   final int index;
//   final int? idProServicio;
//   final int idUsuarioActual;

//   @override
//   Widget build(BuildContext context) {
//     double paddingTopEachPublicacion = 40.0;
//     Object newItem = ({});

//     if (item is NeswFeedReelPublicacionTb) {
//       newItem = item as NeswFeedReelPublicacionTb;
//     }

//     return Padding(
//       padding: EdgeInsets.only(top: paddingTopEachPublicacion),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           newItem is NeswFeedReelPublicacionTb
//               ? ContenidoParteSuperior2(
//                   idUsuario: newItem.usuario.idUsuario,
//                   nombreUsuario: newItem.usuario.nombres)
//               : Text(""),

//           Padding(
//             padding: EdgeInsets.fromLTRB(15.0, 8.0, 0.0, 10.0),
//             child: Text(
//               descripcion,
//               style: TextStyle(fontSize: 16.8),
//             ),
//           ),
//           ShowVideo(
//             urlReel:
//                 "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
//           ),
//           // Fila de iconos
//           FilaIconos(
//             index: index,
//             idProServicio: idProServicio,
//             idUsuarioActual: idUsuarioActual,
//           )
//         ],
//       ),
//     );
//   }
// }

// class ContenidoParteSuperior2 extends StatelessWidget {
//   const ContenidoParteSuperior2({
//     super.key,
//     required this.idUsuario,
//     required this.nombreUsuario,
//     this.urlFotoPerfil,
//   });

//   final int idUsuario;
//   final String nombreUsuario;
//   final String? urlFotoPerfil;

//   @override
//   Widget build(BuildContext context) {
//     BorderRadius borderImageProfile = BorderRadius.circular(50.0);
//     double sizeImageProfile = 53.0;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => Menu(
//               currentIndex: 1,
//               idUsuario: idUsuario,
//             ),
//           ),
//         );
//       },
//       child: Row(
//         children: [
//           urlFotoPerfil != null && urlFotoPerfil != ''
//               ? ShowImage(
//                   networkImage: urlFotoPerfil,
//                   widthNetWork: sizeImageProfile,
//                   heightNetwork: sizeImageProfile,
//                   borderRadius: borderImageProfile,
//                   fit: BoxFit.cover,
//                 )
//               : Container(
//                   height: sizeImageProfile,
//                   width: sizeImageProfile,
//                   decoration: BoxDecoration(
//                       borderRadius: borderImageProfile,
//                       color: Colors.grey.shade200),
//                 ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 7.0),
//             child: Text(
//               nombreUsuario,
//               style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class FilaIconos2 extends StatefulWidget {
//   const FilaIconos2({
//     super.key,
//     required this.index,
//     this.idProServicio,
//     required this.idUsuarioActual,
//   });

//   final int index;
//   final int? idProServicio;
//   final int idUsuarioActual;

//   @override
//   State<FilaIconos2> createState() => _FilaIconosState();
// }

// class _FilaIconosState extends State<FilaIconos2> {
//   bool isLiked = false;

//   @override
//   void initState() {
//     super.initState();

//     isLiked = widget.like == 1;
//   }

//   void saveRatingEnlaceProServicio() {
//     print('Like: $isLiked');
//     RatingsEnlaceProServicioTb ratingEnlaceProducto =
//         RatingsEnlaceProServicioTb(
//       idUsuario: widget.idUsuarioActual,
//       idEnlaceProServicio: widget.idPublicacion,
//       likes: isLiked ? 0 : 1,
//     );

//     RatingsEnlaceProServicioDb.saveRating(widget.idPublicacion,
//         widget.idUsuarioActual, ratingEnlaceProducto, widget.objectType);
//   }

//   void saveRatingPublicacion() {
//     RatingsPublicacionesTb ratingPublicacion = RatingsPublicacionesTb(
//         idUsuario: widget.idUsuarioActual,
//         idPublicacion: widget.idPublicacion,
//         likes: isLiked ? 0 : 1);

//     RatingsFotoAndReelPublicacionDb.saveRating(widget.idPublicacion,
//         widget.idUsuarioActual, ratingPublicacion, widget.objectType);
//   }

//   void handleLike(bool like) {
//     print("TIPO OBJETOI: ${widget.objectType}");
//     if (widget.objectType == NeswFeedReelPublicacionTb ||
//         widget.objectType == NeswFeedPublicacionesTb) {
//       saveRatingPublicacion();
//     } else {
//       saveRatingEnlaceProServicio();
//     }
//     setState(() {
//       isLiked = like;
//     });
//   }

//   void navigateToServiceOrProductDetail(Type objectType, int idProServicio) {
//     if (objectType == NewsFeedProductosTb ||
//         objectType == NeswFeedReelProductTb) {
//       navigateToProductDetail(idProServicio);
//     } else if (objectType == NewsFeedServiciosTb ||
//         objectType == NeswFeedReelServiceTb) {
//       navigateToServiceDetail(idProServicio);
//     }
//   }

//   void navigateToServiceDetail(int idServicio) {
//     ServicioDb.getServicio(idServicio).then((servicio) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ProServicioDetail(proServicio: servicio),
//         ),
//       );
//     });
//   }

//   void navigateToProductDetail(int idProducto) {
//     ProductoDb.getProducto(idProducto).then((producto) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ProServicioDetail(proServicio: producto),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     //bool isLiked = isLikedMap[index] ?? (like == 1); // Asumimos 'false' si es nulo
//     double iconSize = 32.0;
//     double iconPaddingRight = 20.0;
//     double paddingMedia = 20.0;

//     return Padding(
//       padding: EdgeInsets.fromLTRB(paddingMedia, 10.0, 0.0, 0.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           isLiked == true
//               ? ManageIcon(
//                   size: iconSize,
//                   icon: CupertinoIcons.heart_fill,
//                   color: Colors.red,
//                   paddingLeft: 10.0,
//                   paddingRight: 15.0,
//                   onTap: () => handleLike(false),
//                 )
//               : ManageIcon(
//                   icon: CupertinoIcons.heart,
//                   size: iconSize,
//                   paddingLeft: 10.0,
//                   paddingRight: iconPaddingRight,
//                   onTap: () => handleLike(true),
//                 ),
//           ManageIcon(
//             size: iconSize,
//             paddingRight: iconPaddingRight,
//             icon: CupertinoIcons.chat_bubble_text,
//           ),
//           ManageIcon(
//             size: iconSize,
//             paddingRight: iconPaddingRight,
//             icon: CupertinoIcons.paperplane,
//           ),
//           ManageIcon(
//             icon: CupertinoIcons.square,
//             paddingRight: iconPaddingRight,
//             size: iconSize,
//           ),
//           Spacer(),
//           widget.idProServicio != null
//               ? ManageIcon(
//                   icon: CupertinoIcons.arrow_turn_up_right,
//                   size: iconSize,
//                   paddingRight: 10.0,
//                   onTap: () {
//                     navigateToServiceOrProductDetail(
//                         widget.objectType, widget.idProServicio!);
//                   },
//                 )
//               : SizedBox.shrink()
//         ],
//       ),
//     );
//   }
// }

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
