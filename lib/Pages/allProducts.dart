import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Utils/roundedSearchBar.dart';
import 'package:etfi_point/Pages/categorie.dart';
import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(115.0),
        child: AppBar(
          backgroundColor: Colors.grey[200],
          title:  Column(
            children: [
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.black,
                tabs: const [
                  Tab(
                    child: Text('Productos', style: TextStyle(color: Colors.black),),
                  ),
                  Tab(
                    child: Text('Ofertas', style: TextStyle(color: Colors.black),),
                  ),
                  Tab(
                    child: Text('Domiciliarios', style: TextStyle(color: Colors.black),),
                  ),
                ]
              ),
              const SizedBox(height: 12,)
              //RoundedSearchBar(controller: searchController)
            ],
            
          ),

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
           child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: RoundedSearchBar(
              controller: searchController
            ),
           ), 
          ),

        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(
            children: [
              HorizontalList(),
              HorizontalCategories(),
              //RowProducts(producto: producto)
            ],
          ),
          // Agrega aquí el contenido de la pestaña "Ofertas"
          Ofertas(),
          // Agrega aquí el contenido de la pestaña "Nuevos"
          Container(
            child: Center(
              child: Text('Nuevos'),
            ),
          ),
        ],
      ),
    );
  }
}




class Ofertas extends StatelessWidget { 
  const Ofertas({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView(
      children: [
        HorizontalList(),
        HorizontalCategories()
      ],
    );
  }

}



class HorizontalList extends StatelessWidget {
   HorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Producto> producto = [
      const Producto(id: 1, idCategorie: 1, image: 'https://colombinacontentmanager-prd.s3.us-east-1.amazonaws.com/Dulces/7702011128072_A1N1_es.jpg', price: '2800'),
      const Producto(id: 2, idCategorie: 2, image: 'https://locatelcolombia.vtexassets.com/arquivos/ids/194239/7702535005354.png?v=636153524310130000', price: '2800'),
      const Producto( id: 3, idCategorie: 3, image: 'https://i0.wp.com/marvin.com.mx/wp-content/uploads/2020/12/mcdonalds-gran-dia-big-mac-fundacion-infantil-2020.jpg', price: '5400'),
      const Producto( id: 4, idCategorie: 2, image: 'https://static.merqueo.com/images/products/large/5e1499d4-a8c5-45c8-b13f-304a2f43e554.png', price: '5400'),
      const Producto(id: 5, idCategorie: 3, image: 'https://clubvivamos.ceet.co/club-suscriptores-api/v1/handler/M/beneficio/944', price: '2800'),
      const Producto( id: 6, idCategorie: 1, image: 'https://jumbocolombiaio.vtexassets.com/arquivos/ids/213425/7702011200785.jpg?v=637814238918200000', price: '5400'),
    ];
    
    return Container(
      height: 210.0,
      color: Colors.grey[200],
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: producto.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            // child: IndividualProduct(
            //     id: producto[index].id,
            //     image: producto[index].image,
            //     price: producto[index].price
            //   ),
          );
        },
      ),
    );
  }
}


class HorizontalCategories extends StatelessWidget {
   HorizontalCategories({super.key});

    List<CategoriaTb> categorias = [];


  @override
  Widget build(BuildContext context) {

    final List<Categories> categoria = [
      const Categories(id: 1, idCategoria: 1, image: 'lib/images/chucheria.png', categoria: 'Mecato'),
      const Categories( id: 2, idCategoria: 3, image: 'lib/images/pizza.png', categoria: 'Restaurante'),
      const Categories( id: 3, idCategoria: 2, image: 'lib/images/refresco.png', categoria: 'Refresco'),
      const Categories( id: 4, idCategoria: 1, image: 'lib/images/chucheria.png', categoria: 'Mecato'),
      const Categories( id: 5, idCategoria: 3, image: 'lib/images/pizza.png', categoria: 'Restaurante'),
      const Categories( id: 6, idCategoria: 2, image: 'lib/images/refresco.png', categoria: 'Refresco'),
    ];



    return FutureBuilder<List<CategoriaTb>>(
      future: CategoriaDb.categorias(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          categorias = snapshot.data!;
          return SizedBox(
      height: 95.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        itemBuilder: (BuildContext context, int index) {
          final CategoriaTb categoria = categorias[index];
          return Container(
            padding: const EdgeInsets.all(10.0),
            width: 100.0,
             child: Column(
              children: [
                Container(
                  
                  padding: const EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
                  child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  Categorie(idCategoria: categoria.idCategoria!))
                    );
                  },
                  child: SizedBox(
                    height: 48.0,
                    child: Image.file(File(categoria.imagePath!)),
                  )
                  
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(categoria.nombre, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),),
                )
              ],
            ),
          );
        }
      )
    );
        }else if(snapshot.hasError){
          return Text('Error al cargas las categorias');
        }
          return const Center(child: CircularProgressIndicator());
      }
    );
    
  
  }
}



class Producto extends StatefulWidget {
  const Producto(
      {super.key,
        required this.id,
        required this.idCategorie,
        required this.image, 
        required this.price
      });

  final id;
  final idCategorie;
  final image;
  final price;

  @override
  State<Producto> createState() => _ProductoState();
}

class _ProductoState extends State<Producto> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class Categories extends StatefulWidget {
  const Categories({super.key, required this.id, required this.idCategoria, required this.image, required this.categoria});

  final int id;
  final int idCategoria;
  final String image;
  final String categoria;

  @override
  State<Categories> createState() => _CategoriesState();
}


class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
