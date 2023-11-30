import 'dart:io';

import 'package:etfi_point/Components/Utils/showModalsButtons/ButtonMenu.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
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
          TiendasQueSigo(),
          Center(child: Text('Contenido del Tab 2')),
        ],
      ),
    );
  }
}

class TiendasQueSigo extends StatelessWidget {
  const TiendasQueSigo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [Historias(), PictureDescription()],
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

class PictureDescription extends StatelessWidget {
  const PictureDescription({super.key});

  @override
  Widget build(BuildContext context) {
    String urlImage =
        "https://www.panoramaweb.com.mx/u/fotografias/fotosnoticias/2022/8/25/35305.jpg";

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.grey.shade200),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 7.0),
                    child: Text(
                      'Bussines name',
                      style: TextStyle(
                          fontSize: 15.5, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 0.0),
                child: Text(
                  'Lorem ipsum es el texto que se usa habitualmente en diseño gráfico en demostraciones de tipografías',
                  style: TextStyle(fontSize: 16.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                child: Container(
                  width: 340,
                  height: 320,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey.shade200),
                ),
              )
            ],
          ),
        ),
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
