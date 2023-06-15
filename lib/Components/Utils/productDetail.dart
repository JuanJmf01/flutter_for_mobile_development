import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
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

  List<CategoriaTb> categoriasSeleccionadas = [];


  
  Future<ProductoTb> producto() async {
    final ProductoTb productos = await ProductoDb.individualProduct(widget.id);

    return productos;
  }

  Future<List<CategoriaTb>> obtenerCategoriasSeleccionadas() async {
    List<CategoriaTb> categoriasSeleccionadas = [];
    if (widget.id != null) {
      categoriasSeleccionadas =
          await CategoriaDb.getCategoriasSeleccionadas(widget.id!);
    } else {
      print('idProducto es nulo');
    }

    return categoriasSeleccionadas;
  }



  // @override
  // void initState() {
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: FutureBuilder<ProductoTb>(
        future: producto(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final producto = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBarDetail(imagePath: producto.imagePath),
                      FastDescription(producto: producto),
                      AdvancedDescription(
                        descripcionDetallada: producto.descripcion,
                      ),
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
  const FastDescription({super.key, required this.producto});

  final ProductoTb producto;

  @override
  State<FastDescription> createState() => _FastDescriptionState();
}

class _FastDescriptionState extends State<FastDescription> {
  int rating = 0;

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
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0)),
            color: Colors.grey.shade100),
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 7.0, 20.0, 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          color: i <= rating
                              ? Colors.yellow.shade700
                              : Colors.grey,
                          size: 30,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 12.0, 0.0, 0.0),
                        child: Container(
                          height: 23,
                          width: 1.3,
                          //margin: EdgeInsets.all(5.0),
                          color: Colors.grey[500],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade700,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text(
                              '+ 1k',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'COP ${producto.precio}',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 20.0),
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

class StaticBottomNavigator extends StatefulWidget {
  const StaticBottomNavigator({super.key});

  @override
  State<StaticBottomNavigator> createState() => _StaticBottomNavigatorState();
}

class _StaticBottomNavigatorState extends State<StaticBottomNavigator> {
  bool pressHearIndex = false;

  void _selectedHeard() {
    setState(() {
      pressHearIndex = !pressHearIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57.0,
      color: Colors.white,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                SizedBox(
                  width: 35.0,
                  child: IconButton(
                    onPressed: () {
                      _selectedHeard();
                    },
                    icon: Icon(
                      pressHearIndex
                          ? CupertinoIcons.heart
                          : CupertinoIcons.heart_fill,
                      color: pressHearIndex ? Colors.black : Colors.red,
                      size: pressHearIndex ? 30 : 33,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 0, 9.0, 0.0),
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

class RelatedCategories extends StatelessWidget {
  const RelatedCategories({super.key, required this.categorias});

  final List<CategoriaTb> categorias;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 35.0),
        child: Wrap(
          children: categorias.map((categoria) {
            return Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    categoria.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
