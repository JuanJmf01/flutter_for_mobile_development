import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/ratingsTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/ratingsDb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:etfi_point/Components/Utils/IndividualProduct.dart';
import 'package:etfi_point/Pages/reviewsAndOpinions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  int idUsuario = 0;

  void obtenerIdUsuario() async {
    idUsuario = await UsuarioDb.getIdUsuario();
  }

  Future<ProductoTb> producto() async {
    final ProductoTb productos = await ProductoDb.getProducto(widget.id);

    return productos;
  }

  Future<List<ProductoTb>> obtenerProductosRelacionados() async {
    List<ProductoTb> productosRelacionados = [];
    if (widget.id != null) {
      productosRelacionados =
          await ProductoDb.getProductosPorIdProducto(widget.id);
    } else {
      print('idProducto es nulo');
    }

    return productosRelacionados;
  }

  Future<bool> existeOrNotUserRatingByProducto() async {
    int idProducto = widget.id;
    idUsuario = idUsuario;

    bool result = await RatingsDb.existOrNotRating(idUsuario, idProducto);

    return result;
  }

  @override
  void initState() {
    super.initState();

    obtenerIdUsuario();
  }

  @override
  Widget build(BuildContext context) {
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
                        future: existeOrNotUserRatingByProducto(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            bool result = snapshot.data!;
                            return Column(
                              children: [
                                Expanded(
                                  child: CustomScrollView(
                                    slivers: [
                                      SliverAppBarDetail(
                                          imagePath: producto.imagePath),
                                      FastDescription(
                                          producto: producto,
                                          ifExistOrNotUserRatingByProducto:
                                              result,
                                          idUsuario: idUsuario),
                                      //
                                      // SliverToBoxAdapter(
                                      //     child: Container(
                                      //   height: 400,
                                      //   child: Comments(idProducto: widget.id),
                                      // )),
                                      AdvancedDescription(
                                        descripcionDetallada:
                                            producto.descripcion,
                                      ),
                                      ProductosRelacionados(
                                          productos: productosRelacionados)
                                    ],
                                  ),
                                ),
                                StaticBottomNavigator()
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error al obtener los datos');
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        });
                  } else if (snapshot.hasError) {
                    return Text('Error al obtener los datos');
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          } else if (snapshot.hasError) {
            return Text('Error al obtener los datos');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class SliverAppBarDetail extends StatefulWidget {
  const SliverAppBarDetail({super.key, required this.imagePath});

  final String imagePath;

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
      expandedHeight: 380.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Image(
          image: FileImage(File(widget.imagePath)),
          fit: BoxFit.cover,
        ),
      ),
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

    await RatingsDb.saveRating(ratingsAndothers, widget.ifExistOrNotUserRatingByProducto);
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
          padding: EdgeInsets.fromLTRB(3.0, 7.0, 20.0, 15.0),
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
                          width: 1,
                          color: Colors.grey,
                          margin: EdgeInsets.only(left: 15.0),
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
                            child: Text(
                              '+ 1k',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
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
  const AdvancedDescription({super.key, this.descripcionDetallada});

  final String? descripcionDetallada;

  @override
  State<AdvancedDescription> createState() => _AdvancedDescriptionState();
}

class _AdvancedDescriptionState extends State<AdvancedDescription> {
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
                  padding: const EdgeInsets.fromLTRB(16.0, 23.0, 30.0, 60.0),
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
            Container(
              width: double.infinity,
              height: 320,
              child: Image.asset(
                'lib/images/feature.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              height: 320,
              child: Image.asset(
                'lib/images/PapasSaladas.jpg',
                fit: BoxFit.cover,
              ),
            ),
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
      color: Colors.white,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Row(
              children: [
                // SizedBox(
                //   width: 35.0,
                //   child: IconButton(
                //     onPressed: () {
                //       _selectedHeard();
                //     },
                //     icon: Icon(
                //       pressHearIndex
                //           ? CupertinoIcons.heart_fill
                //           : CupertinoIcons.heart,
                //       color: pressHearIndex ? Colors.red : Colors.black,
                //       size: pressHearIndex ? 32 : 30,
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 0, 7.0, 0.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
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
                    icon: Icon(
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
