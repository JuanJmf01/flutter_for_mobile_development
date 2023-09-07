import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Utils/categoriesList.dart';
import 'package:etfi_point/Components/Utils/elevatedGlobalButton.dart';
import 'package:etfi_point/Components/Utils/lineForDropdownButton.dart';
import 'package:flutter/material.dart';

class ButtonSeleccionarCategorias extends StatefulWidget {
  const ButtonSeleccionarCategorias({
    super.key,
    this.categoriasSeleccionadas,
    required this.categoriasDisponibles,
  });

  final List<CategoriaTb>? categoriasSeleccionadas;
  final List<CategoriaTb> categoriasDisponibles;

  @override
  State<ButtonSeleccionarCategorias> createState() =>
      _ButtonSeleccionarCategoriasState();
}

class _ButtonSeleccionarCategoriasState
    extends State<ButtonSeleccionarCategorias>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  void asignarCategorias() {}

  void asignarSubCategorias() {}

  @override
  Widget build(BuildContext context) {
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
            child: Text('Categorias seleccionadas'),
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
                onlyShow: true,
                marginContainer: EdgeInsets.all(5.0),
                paddingContainer: EdgeInsets.all(12.0),
              ),
            );
          }).toList(),
        ),
      ),
      // child: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     const LineForDropdownButton(),
      //     const Row(
      //       mainAxisAlignment: MainAxisAlignment.end,
      //       children: [
      //         Padding(
      //           padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 4.0),
      //           child: Text(
      //             'Todas las categorias',
      //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //           ),
      //         )
      //       ],
      //     ),

      //     Padding(
      //       padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      //       child: CategoriesList(
      //         onlyShow: true,
      //         elementos: categoriasDisponibles,
      //         categoriasSeleccionadas: categoriasSeleccionadas ?? [],
      //         marginContainer: EdgeInsets.all(5.0),
      //         paddingContainer: EdgeInsets.all(12.0),
      //       ),
      //     ),
      //     ElevatedGlobalButton(
      //         paddingTop: 50.0,
      //         nameSavebutton: 'Guardar',
      //         fontSize: 22,
      //         fontWeight: FontWeight.bold,
      //         borderRadius: BorderRadius.circular(30.0),
      //         widthSizeBox: double.infinity,
      //         heightSizeBox: 50,
      //         onPress: () {
      //           print('inicio sesion');
      //         }),
      //   ],
      // ),
    );
  }
}
