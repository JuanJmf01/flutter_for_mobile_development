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

    _tabController =
        TabController(length: widget.categoriasDisponibles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
     categoriasSeleccionadas = Provider.of<SubCategoriaSeleccionadaProvider>(context).subCategoriasSeleccionadas;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22.0),
          topRight: Radius.circular(22.0),
        ),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: CategoriesList(
              onlyShow: false,

              elementos: categoriasSeleccionadas,
              marginContainer: const EdgeInsets.all(5.0),
              paddingContainer: const EdgeInsets.all(12.0),
            ),
          ),
          SliverToBoxAdapter(
            child: TabBar(
              isScrollable: true,
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              controller: _tabController,
              tabs: widget.categoriasDisponibles
                  .map((categoria) => Tab(text: categoria.nombre))
                  .toList(),
            ),
          )
        ],
        body: TabBarView(
          controller: _tabController,
          children: widget.categoriasDisponibles.map((categoria) {
            return SingleChildScrollView(
              child: CategoriesList(
                elementos: categoria.subCategorias ?? [],
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
