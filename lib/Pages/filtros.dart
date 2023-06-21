import 'package:etfi_point/Components/Utils/ButtonMenu.dart';
import 'package:etfi_point/Components/Utils/roundedSearchBar.dart';
import 'package:etfi_point/Pages/allProducts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Filtros extends StatefulWidget {
  const Filtros({Key? key}) : super(key: key);

  @override
  _FiltrosState createState() => _FiltrosState();
}

class _FiltrosState extends State<Filtros> with SingleTickerProviderStateMixin {
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
          title: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.grey[800],
                      isScrollable: true,
                      tabs: const [
                        Tab(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Categorias',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        Tab(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Ofertas',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        Tab(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Domiciliarios',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: RoundedSearchBar(
                controller: searchController,
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics:
            const NeverScrollableScrollPhysics(), // Evita el desplazamiento horizontal
        children: [
          // ListView(
          //   children: [
          //     HorizontalList(),
          //     HorizontalCategories(),
          //     //RowProducts(producto: producto)
          //   ],
          // ),
           Container(
            child: Center(
              child: Text('Nuevos'),
            ),
          ),
           Container(
            child: Center(
              child: Text('Nuevos'),
            ),
          ),
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