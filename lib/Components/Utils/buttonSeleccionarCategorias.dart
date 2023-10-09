import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Utils/Providers/subCategoriaSeleccionadaProvider.dart';
import 'package:etfi_point/Components/Utils/categoriesList.dart';
import 'package:etfi_point/Components/Utils/lineForDropdownButton.dart';
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

    _tabController =
        TabController(length: widget.categoriasDisponibles.length, vsync: this);


    // // Oyente para cada cambio de pestaña en el tabBar
    // _tabController.addListener(() {
    //   final currentIndex = _tabController.index;
    //   final currentCategoria = widget.categoriasDisponibles[currentIndex];
    //   print("Pestaña seleccionada: ${currentCategoria.nombre}");
    //   print("ID de la pestaña: ${currentCategoria.idCategoria}");
    //   // Realiza cualquier acción de impresión que necesites aquí
    // });
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
    categoriasSeleccionadas =
        Provider.of<SubCategoriaSeleccionadaProvider>(context)
            .subCategoriasSeleccionadas;

    return Container(
      height: 630,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22.0),
          topRight: Radius.circular(22.0),
        ),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
              child: Column(
            children: [
              const LineForDropdownButton(
                paddingTop: 5.0,
                paddingBottom: 15.0,
              ),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: GlobalTextButton(
              //     onPressed: () {},
              //     textButton: "Guardar",
              //     fontSizeTextButton: 18,
              //     fontWeightTextButton: FontWeight.bold,
              //     letterSpacing: 0.7,
              //   ),
              // ),
              const Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Selecciona tus categorias",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                    ],
                  )),
              CategoriesList(
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 15.0),
                onlyShow: false,
                delete: true,
                elementos: categoriasSeleccionadas,
                marginContainer: const EdgeInsets.all(5.0),
                paddingContainer: const EdgeInsets.all(12.0),
              ),
            ],
          )),
          SliverToBoxAdapter(
            child: TabBar(
              isScrollable: true,
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              controller: _tabController,
              tabs: widget.categoriasDisponibles.map((categoria) {
                int index = widget.categoriasDisponibles.indexOf(categoria);
                return Tab(
                  text: categoria.nombre,
                  // Puedes acceder al idCategoria aquí:
                  // Suponiendo que idCategoria es un atributo de la clase CategoriaTb
                  key: ValueKey<int>(
                      categoria.idCategoria), // Usamos el id como clave
                );
              }).toList(),
            ),
          )
        ],
        body: TabBarView(
          controller: _tabController,
          children: widget.categoriasDisponibles.map((categoria) {
            return SingleChildScrollView(
              child: CategoriesList(
                elementos: categoria.subCategorias,
                categoriasSeleccionadas: categoriasSeleccionadas,
                onlyShow: true,
                marginContainer: EdgeInsets.all(5.0),
                paddingContainer: EdgeInsets.all(12.0),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
