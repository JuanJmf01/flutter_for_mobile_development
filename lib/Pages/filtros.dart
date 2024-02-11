import 'package:flutter/material.dart';

class Filtros extends StatefulWidget {
  const Filtros({super.key});

  @override
  State<Filtros> createState() => _FiltrosState();
}

class _FiltrosState extends State<Filtros> {
  bool isSelected = false;

  List<String> subcategories = [
    'Subcategoría 1',
    'Subcategoría 2',
    'Subcategoría 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Center(
              child: Text('Categorias'),
            ),
          ),
          SizedBox(
            height: 35,
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
                icon: Icon(
                  isSelected ? Icons.check_circle : Icons.panorama_fish_eye,
                  size: 19,
                ),
                label: const Text(
                  'data',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: subcategories
                  .map(
                    (subcat) => GestureDetector(
                      onTap: () {
                        // Aquí puedes agregar la funcionalidad para navegar a la subcategoría
                      },
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Text(subcat),
                            ],
                          )),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      )),
    );
  }
}

class ButtonLateralMenu extends StatefulWidget {
  const ButtonLateralMenu({super.key});

  @override
  State<ButtonLateralMenu> createState() => _ButtonLateralMenuState();
}

class _ButtonLateralMenuState extends State<ButtonLateralMenu> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}




// class Filtros extends StatefulWidget {
//   const Filtros({Key? key}) : super(key: key);

//   @override
//   _FiltrosState createState() => _FiltrosState();
// }

// class _FiltrosState extends State<Filtros> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController searchController = TextEditingController();

//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(115.0),
//         child: AppBar(
//           backgroundColor: Colors.grey[200],
//           title: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: TabBar(
//                       controller: _tabController,
//                       indicatorSize: TabBarIndicatorSize.label,
//                       indicatorColor: Colors.grey[800],
//                       //isScrollable: true,
//                       tabs: const [
//                         Tab(
//                           child: FittedBox(
//                             fit: BoxFit.scaleDown,
//                             child: Text('Categorias',
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                         ),
//                         Tab(
//                           child: FittedBox(
//                             fit: BoxFit.scaleDown,
//                             child: Text('Ofertas',
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                         ),             
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(50.0),
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 12.0),
//               child: RoundedSearchBar(
//                 controller: searchController,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         physics:
//             const NeverScrollableScrollPhysics(), // Evita el desplazamiento horizontal
//         children: [
//           // ListView(
//           //   children: [
//           //     HorizontalList(),
//           //     HorizontalCategories(),
//           //     //RowProducts(producto: producto)
//           //   ],
//           // ),
//            Container(
//             child: Center(
//               child: Text('Nuevos'),
//             ),
//           ),
//            Container(
//             child: Center(
//               child: Text('Nuevos'),
//             ),
//           ),      
//         ],
//       ),
//     );
//   }
// }