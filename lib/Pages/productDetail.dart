import 'dart:io';
import 'dart:typed_data';

import 'package:etfi_point/Components/Data/EntitiModels/productImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/ratingsTb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/ratingsDb.dart';
import 'package:etfi_point/Components/Utils/IndividualProduct.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Services/selectImage.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/reviewsAndOpinions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Future<ProductoTb> producto() async {
    final ProductoTb producto = await ProductoDb.getProducto(widget.id);

    return producto;
  }

//Modificar para retornar productos relacionados
  Future<List<ProductoTb>> obtenerProductosRelacionados() async {
    List<ProductoTb> productosRelacionados = [];
    // if (widget.id != null) {
    //   productosRelacionados =
    //       await ProductoDb.getProductosByCategoria(widget.id);
    //   print('Relacionados_: $productosRelacionados');
    // } else {
    //   print('idProducto es nulo');
    // }

    return productosRelacionados;
  }

  Future<bool> existeOrNotUserRatingByProducto(idUsuario) async {
    int idProducto = widget.id;

    bool result = await RatingsDb.existOrNotRating(idUsuario, idProducto);

    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuario;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: FutureBuilder<ProductoTb>(
        future: producto(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final producto = snapshot.data!;
            return FutureBuilder<List<ProductoTb>>(
                future: obtenerProductosRelacionados(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final productosRelacionados = snapshot.data!;
                    return FutureBuilder<bool>(
                        future: existeOrNotUserRatingByProducto(idUsuario),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            bool result = snapshot.data!;
                            return Column(
                              children: [
                                Expanded(
                                  child: CustomScrollView(
                                    slivers: [
                                      SliverAppBarDetail(
                                          urlImage: producto.urlImage),
                                      FastDescription(
                                          producto: producto,
                                          ifExistOrNotUserRatingByProducto:
                                              result,
                                          idUsuario: idUsuario!),
                                      AdvancedDescription(
                                        descripcionDetallada:
                                            producto.descripcion,
                                        idProducto: widget.id,
                                      ),
                                      SummaryReviews(
                                          idProducto: producto.idProducto),
                                      ProductosRelacionados(
                                          productos: productosRelacionados)
                                    ],
                                  ),
                                ),
                                const StaticBottomNavigator()
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return const Text('Error al obtener los datos');
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        });
                  } else if (snapshot.hasError) {
                    return const Text('Error al obtener los datos');
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          } else if (snapshot.hasError) {
            return const Text('Error al obtener los datos');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class SliverAppBarDetail extends StatefulWidget {
  const SliverAppBarDetail({super.key, required this.urlImage});

  final String urlImage;

  @override
  State<SliverAppBarDetail> createState() => _SliverAppBarDetailState();
}

class _SliverAppBarDetailState extends State<SliverAppBarDetail> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      pinned: true,
      centerTitle: false,
      stretch: true,
      expandedHeight: 350.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
          stretchModes: const [StretchMode.zoomBackground],
          background: ShowImage(
            networkImage: widget.urlImage,
            fit: BoxFit.cover,
          )),
    );
  }
}

class FastDescription extends StatefulWidget {
  const FastDescription(
      {super.key,
      required this.producto,
      required this.ifExistOrNotUserRatingByProducto,
      required this.idUsuario});

  final ProductoTb producto;
  final bool ifExistOrNotUserRatingByProducto;
  final int idUsuario;

  @override
  State<FastDescription> createState() => _FastDescriptionState();
}

class _FastDescriptionState extends State<FastDescription> {
  RatingsCreacionTb? ratingsAndOthers;
  bool pressHearIndex = false;
  int? rating = 0;
  bool ifExistOrNotUserRatingByProducto = false;

  void _selectedHeard() {
    setState(() {
      pressHearIndex = !pressHearIndex;
    });

    _updateRatingsAndOthers();
  }

  void rateStar(int starIndex) {
    if (starIndex == rating) {
      setState(() {
        rating = 0;
      });
    } else {
      setState(() {
        rating = starIndex;
      });
    }
    _updateRatingsAndOthers();
  }

  void _updateRatingsAndOthers() async {
    int idUsuario = widget.idUsuario;
    int? idProducto = widget.producto.idProducto;
    int like = pressHearIndex ? 1 : 0;

    RatingsCreacionTb ratingsAndothers = RatingsCreacionTb(
        idUsuario: idUsuario,
        idProducto: idProducto,
        likes: like,
        ratings: rating ?? 0);

    await RatingsDb.saveRating(
        ratingsAndothers, ifExistOrNotUserRatingByProducto);

    ifExistOrNotUserRatingByProducto = true;
  }

  void obtenerRatingsAndOther() async {
    ratingsAndOthers = await RatingsDb.getRatingByProductoAndUsuario(
        widget.idUsuario, widget.producto.idProducto);
    print(ratingsAndOthers);

    if (ratingsAndOthers?.likes == 1) {
      setState(() {
        pressHearIndex = true;
      });
    } else if (ratingsAndOthers?.likes == 0) {
      setState(() {
        pressHearIndex = false;
      });
    }

    rating = ratingsAndOthers?.ratings ?? 0;
  }

  @override
  void initState() {
    super.initState();

    ifExistOrNotUserRatingByProducto = widget.ifExistOrNotUserRatingByProducto;

    bool result = widget.ifExistOrNotUserRatingByProducto;
    if (result) {
      obtenerRatingsAndOther();
    }

    print('existe :  ${widget.ifExistOrNotUserRatingByProducto}');
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0)),
            color: Colors.grey.shade100),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3.0, 7.0, 20.0, 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _selectedHeard();
                        },
                        icon: Icon(
                          pressHearIndex
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: pressHearIndex ? Colors.red : Colors.black,
                          size: pressHearIndex ? 32 : 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send_outlined,
                          size: 27,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (int i = 1; i <= 5; i++)
                        SizedBox(
                          width: 25.0,
                          child: IconButton(
                            onPressed: () {
                              rateStar(i);
                            },
                            icon: Icon(
                              Icons.star_rounded,
                              color: i <= rating!
                                  ? Colors.yellow.shade700
                                  : Colors.grey,
                              size: 30,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          height: 20,
                          color: Colors.grey,
                          margin: const EdgeInsets.only(left: 0.0),
                        ),
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(4.5, 8.0, 3.0, 0.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewsAndOpinions(
                                    idProducto: widget.producto.idProducto,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                '+ 20K',
                                style: TextStyle(
                                  color: Colors.blue[500],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
                    child: Text(
                      'COP ${producto.precio}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20.0, 20.0, 20.0),
                child: Text(
                  'No hay descripcion que mostrar',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AdvancedDescription extends StatefulWidget {
  const AdvancedDescription(
      {super.key, this.descripcionDetallada, required this.idProducto});

  final String? descripcionDetallada;
  final int idProducto;

  @override
  State<AdvancedDescription> createState() => _AdvancedDescriptionState();
}

class _AdvancedDescriptionState extends State<AdvancedDescription> {
  File? imagenToUpload;
  List<ProductImagesTb> productSecondaryImages = [];
  List<Asset?> selectedImages = [];
  List<String?> urlImages = [];

  void insertProductImage() async {
    if (selectedImages.isNotEmpty) {
      for (Asset? image in selectedImages) {
        await productImageDb.uploadImage(
            image!, 'productos', widget.idProducto, 0);
      }
    }
  }

  void getListSecondaryProductImages() async {
    productSecondaryImages =
        await productImageDb.getProductSecondaryImages(widget.idProducto);

    setState(() {
      urlImages =
          productSecondaryImages.map((image) => image.urlImage).toList();
    });

    print('URL IMAGES_: $urlImages');
  }

  @override
  void initState() {
    super.initState();

    getListSecondaryProductImages();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.grey.shade100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 20.0, 0.0, 0.0),
                  child: Text(
                    'Descripcion detallada',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 23.0, 30.0, 30.0),
                  child: widget.descripcionDetallada != null &&
                          widget.descripcionDetallada!.isNotEmpty
                      ? Text(
                          widget.descripcionDetallada!,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          'No hay descripción que mostrar',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 16,
                          ),
                        ),
                ),
              ],
            ),
            if (urlImages.isNotEmpty)
              for (var url in urlImages)
                ShowImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  networkImage: url,
                ),
            // Container(
            //   width: double.infinity,
            //   child: Image.network(
            //     url!,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            if (selectedImages.isNotEmpty)
              for (var asset in selectedImages)
                FutureBuilder<ByteData>(
                  future: asset!.getByteData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<ByteData> snapshot) {
                    if (snapshot.hasData) {
                      final byteData = snapshot.data!;
                      final bytes = byteData.buffer.asUint8List();
                      return Container(
                        width: double.infinity,
                        child: Image.memory(
                          bytes,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Error al cargar la imagen');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () async {
                      List<Asset?> imagesAsset =
                          await getImagesAsset(selectedImages);
                      if (imagesAsset.isNotEmpty) {
                        setState(() {
                          selectedImages = imagesAsset;
                        });
                      }
                    },
                    icon: Icon(CupertinoIcons.add_circled,
                        size: 40, color: Colors.grey.shade600)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 25.0),
              child: SizedBox(
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    insertProductImage();
                  },
                  child: const Text(
                    'Guardar Imagenes',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SummaryReviews extends StatefulWidget {
  const SummaryReviews({super.key, required this.idProducto});

  final int idProducto;

  @override
  State<SummaryReviews> createState() => _SummaryReviewsState();
}

class _SummaryReviewsState extends State<SummaryReviews> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.grey.shade200),
        child: Column(
          children: [
            Comments(
              idProducto: widget.idProducto,
              selectIndex: 0,
              maxCommentsToShow: 3,
              paddingOutsideHorizontal: 5.0,
              paddingOutsideVertical: 2.0,
              containerPadding: 10.0,
              color: Colors.grey[300],
              fontSizeDescription: 13,
              fontSizeName: 14,
              fontSizeStarts: 20,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewsAndOpinions(
                        idProducto: widget.idProducto,
                      ),
                    ),
                  );
                },
                child: Text(
                  'More Reviews',
                  style: TextStyle(color: Colors.blue[500], fontSize: 17),
                ))
          ],
        ),
      ),
    );
  }
}

class ProductosRelacionados extends StatefulWidget {
  const ProductosRelacionados({super.key, required this.productos});

  final List<ProductoTb> productos;

  @override
  State<ProductosRelacionados> createState() => _ProductosRelacionadosState();
}

class _ProductosRelacionadosState extends State<ProductosRelacionados> {
  @override
  void initState() {
    super.initState();

    //print(widget.productos);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: RowProducts(productos: widget.productos),
      ),
    );
  }
}

class StaticBottomNavigator extends StatefulWidget {
  const StaticBottomNavigator({super.key});

  @override
  State<StaticBottomNavigator> createState() => _StaticBottomNavigatorState();
}

class _StaticBottomNavigatorState extends State<StaticBottomNavigator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57.0,
      color: Colors.white60,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 0, 7.0, 0.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.store_outlined,
                      color: Colors.black,
                      size: 31,
                    ),
                  ),
                ),
                SizedBox(
                  width: 35.0,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.bubble_right,
                      size: 29,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 13.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: const Text(
                    'Comprar',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 17.5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: Container(
                    width: 55,
                    height: 47,
                    decoration: BoxDecoration(
                      color: Colors.pink[100],
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.cart,
                        color: Colors.pink,
                        size: 27,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
