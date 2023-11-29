import 'package:etfi_point/Components/Utils/MisProductos.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/ButtonMenu.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Pages/proServicios/misServicios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileNavigator extends StatefulWidget {
  const ProfileNavigator({super.key});

  @override
  State<ProfileNavigator> createState() => _ProfileNavigatorState();
}

class _ProfileNavigatorState extends State<ProfileNavigator>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int? result;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Oyente para cada cambio de pestaña en el tabBar
    // _tabController.addListener(() {
    //   final currentIndex = _tabController.index;
    //   print("INDEX: $currentIndex");
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isUserSignedIn = context.watch<LoginProvider>().isUserSignedIn;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: AppBar(
          backgroundColor: Colors.grey[200],
          title: const Text(
            'NickName',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            if (isUserSignedIn)
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
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
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
              ),
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const SliverToBoxAdapter(child: TopProfile()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: Icon(
                      _tabController.index == 0
                          ? CupertinoIcons.cube_box_fill
                          : CupertinoIcons.cube_box,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      _tabController.index == 1
                          ? CupertinoIcons.heart_circle_fill
                          : CupertinoIcons.heart_circle,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      _tabController.index == 2
                          ? CupertinoIcons.photo_fill_on_rectangle_fill
                          : CupertinoIcons.photo_on_rectangle,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      _tabController.index == 3
                          ? CupertinoIcons.rectangle_3_offgrid_fill
                          : CupertinoIcons.rectangle_3_offgrid,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller:
              _tabController, // Asignamos el TabController al TabBarView
          children: [
            SingleChildScrollView(
              child: MisProductos(),
            ),
            const SingleChildScrollView(
              child: MisServicios(),
            ),
            const SingleChildScrollView(
              child: Center(
                child: Text('Contenido de la pestaña 3 y otras imágenes'),
              ),
            ),
            const SingleChildScrollView(
              child: Center(
                child: Text('Contenido de la pestaña 4 y otras imágenes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopProfile extends StatefulWidget {
  const TopProfile({super.key});

  @override
  State<TopProfile> createState() => _TopProfileState();
}

class _TopProfileState extends State<TopProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 20.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end, // Alineación vertical hacia arriba
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '10k',
                    style: TextStyle(
                      fontSize: 21, // Tamaño de fuente
                      fontWeight: FontWeight.bold, // Negrita del texto
                      // Otros estilos según sea necesario
                    ),
                  ),
                  Text('Vendido'),
                ],
              ),
              SizedBox(width: 20), // Separación vertical entre los textos
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '23k',
                    style: TextStyle(
                      fontSize: 21, // Tamaño de fuente
                      fontWeight: FontWeight.bold, // Negrita del texto
                      //fontFamily: 'Montserrat'
                      // Otros estilos según sea necesario
                    ),
                  ),
                  Text('Comprado'),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

