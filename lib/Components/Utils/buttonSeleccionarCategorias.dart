import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Utils/Providers/subCategoriaSeleccionadaProvider.dart';
import 'package:etfi_point/Components/Utils/categoriesList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonSeleccionarCategorias extends StatefulWidget {
  const ButtonSeleccionarCategorias({
    super.key,
    required this.categoriasDisponibles,
  });

  final List<CategoriaTb> categoriasDisponibles;

  @override
  State<ButtonSeleccionarCategorias> createState() =>
      _ButtonSeleccionarCategoriasState();
}

class _ButtonSeleccionarCategoriasState
    extends State<ButtonSeleccionarCategorias>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<SubCategoriaTb> categoriasSeleccionadas = [];

  @override
  void initState() {
    super.initState();

    obtenerSubCateProvider();

    _tabController =
        TabController(length: widget.categoriasDisponibles.length, vsync: this);
  }

  void obtenerSubCateProvider() async {
    await context
        .read<SubCategoriaSeleccionadaProvider>()
        .obtenerSubCategorias();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<SubCategoriaTb> subCate = [];
  List<SubCategoriaTb> allSubCate = [];

  @override
  Widget build(BuildContext context) {
    subCate =
        Provider.of<SubCategoriaSeleccionadaProvider>(context).subCate;
    allSubCate =
        Provider.of<SubCategoriaSeleccionadaProvider>(context).allSubCat;

    //subCate = context.watch<SubCategoriaSeleccionadaProvider>().subCate;
    //allSubCate = context.watch<SubCategoriaSeleccionadaProvider>().allSubCat;
    return Column(
      children: [
        SizedBox(
          height: 100.0,
        ),
        // Llamamos a 'CategoriesList' para mostrar solo las categorias seleccionadas = 'elementos'
        CategoriesList(
          elementos: subCate,
          marginContainer: EdgeInsets.all(10.0),
          paddingContainer: EdgeInsets.all(5.0),
          onlyShow: false,
        ),
        SizedBox(
          height: 130.0,
        ),

        // En este caso llamamos a 'CategoriesList' para mostrar todas las categorias
        // En este caso le pasamos todas las subCategorias disponibles en 'elementos y tambien le pasamos las categorias seleccionadas en 'categoriasSeleccionadas'
        // de esta manera podemos mostrar con un fondo azul las categorias seleccionadas y con un fondo blando las no seleccionadas
        CategoriesList(
          elementos: allSubCate,
          categoriasSeleccionadas: subCate,
          marginContainer: EdgeInsets.all(10.0),
          paddingContainer: EdgeInsets.all(5.0),
          onlyShow: true,
        ),
      ],
    );
    //   return Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(22.0),
    //         topRight: Radius.circular(22.0),
    //       ),
    //     ),
    //     child: NestedScrollView(
    //       headerSliverBuilder: (context, innerBoxIsScrolled) => [
    //         SliverToBoxAdapter(
    //           child: CategoriesList(
    //             onlyShow: false,
    //             elementos: categoriasSeleccionadas,
    //             marginContainer: const EdgeInsets.all(5.0),
    //             paddingContainer: const EdgeInsets.all(12.0),
    //           ),
    //         ),
    //         SliverToBoxAdapter(
    //           child: TabBar(
    //             isScrollable: true,
    //             indicatorColor: Colors.black,
    //             labelColor: Colors.black,
    //             controller: _tabController,
    //             tabs: widget.categoriasDisponibles
    //                 .map((categoria) => Tab(text: categoria.nombre))
    //                 .toList(),
    //           ),
    //         )
    //       ],

    //       body: TabBarView(
    //         controller: _tabController,
    //         children: widget.categoriasDisponibles.map((categoria) {
    //           return SingleChildScrollView(
    //             child: CategoriesList(
    //               elementos: categoria.subCategorias ?? [],
    //               categoriasSeleccionadas: categoriasSeleccionadas,

    //               onlyShow: true,
    //               marginContainer: EdgeInsets.all(5.0),
    //               paddingContainer: EdgeInsets.all(12.0),
    //             ),
    //           );
    //         }).toList(),
    //       ),
    //     ),
    //   );
    // }
  }
}
