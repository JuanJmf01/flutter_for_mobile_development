import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Utils/categoriesList.dart';
import 'package:etfi_point/Components/providers/categoriasProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ButtonSeleccionarCategorias extends ConsumerStatefulWidget {
  const ButtonSeleccionarCategorias({
    super.key,
    required this.categoriasDisponibles,
  });

  final List<CategoriaTb> categoriasDisponibles;

  @override
  ButtonSeleccionarCategoriasState createState() =>
      ButtonSeleccionarCategoriasState();
}

class ButtonSeleccionarCategoriasState
    extends ConsumerState<ButtonSeleccionarCategorias>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final initialIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
        length: widget.categoriasDisponibles.length,
        vsync: this,
        initialIndex: initialIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Código a ejecutar después de que se haya construido el árbol de widgets
      _printSubcategorias(initialIndex);
      setState(() {});
    });
  }

  void _printSubcategorias(int index) {
    final categoriaSeleccionada = widget.categoriasDisponibles[index];
    List<SubCategoriaTb> selectedSubcategorias =
        List.from(categoriaSeleccionada.subCategorias);

    ref
        .read(subCategoriesByIndiceProvider.notifier)
        .update((state) => selectedSubcategorias);
  }

  @override
  Widget build(BuildContext context) {
    final subCategoriesSelected = ref.watch(subCategoriasSelectedProvider);

    print("SELECCIONMADAS 1: $subCategoriesSelected");
    return Expanded(
      child: Column(
        children: [
          CategoriesList(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 15.0),
            onlyShow: false,
            delete: true,
            elementos: subCategoriesSelected,
            marginContainer: const EdgeInsets.all(5.0),
            paddingContainer: const EdgeInsets.all(12.0),
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            onTap: _printSubcategorias,
            tabs: widget.categoriasDisponibles
                .map((categoria) => Tab(text: categoria.nombre))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics:
                  const NeverScrollableScrollPhysics(), // Evita el desplazamiento horizontal
              children: widget.categoriasDisponibles
                  .map(
                    (categoria) => CategoriesList(
                      elementos: categoria.subCategorias,
                      categoriasSeleccionadas: subCategoriesSelected,
                      onlyShow: true,
                      marginContainer: const EdgeInsets.all(5.0),
                      paddingContainer: const EdgeInsets.all(12.0),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );

    // Expanded(
    //   child: NestedScrollView(
    //     headerSliverBuilder: (context, innerBoxIsScrolled) => [
    //       SliverToBoxAdapter(
    //         child: CategoriesList(
    //           padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 15.0),
    //           onlyShow: false,
    //           delete: true,
    //           elementos: subCategoriasSeleccionadas,
    //           marginContainer: const EdgeInsets.all(5.0),
    //           paddingContainer: const EdgeInsets.all(12.0),
    //         ),
    //       ),
    //       SliverToBoxAdapter(
    //         child: TabBar(
    //           isScrollable: true,
    //           indicatorColor: Colors.black,
    //           labelColor: Colors.black,
    //           controller: _tabController,
    //           tabs: widget.categoriasDisponibles.map((categoria) {
    //             //int index = widget.categoriasDisponibles.indexOf(categoria);
    //             return Tab(
    //               text: categoria.nombre,
    //               // Puedes acceder al idCategoria aquí:
    //               // Suponiendo que idCategoria es un atributo de la clase CategoriaTb
    //               key: ValueKey<int>(
    //                   categoria.idCategoria), // Usamos el id como clave
    //             );
    //           }).toList(),
    //         ),
    //       )
    //     ],
    //     body: TabBarView(
    //       controller: _tabController,
    //       children: widget.categoriasDisponibles.map((categoria) {
    //         print("subCategorias new: ${categoria.subCategorias}");
    //         return SingleChildScrollView(
    //           child: CategoriesList(
    //             elementos: categoria.subCategorias,
    //             categoriasSeleccionadas: subCategoriasSeleccionadas,
    //             onlyShow: true,
    //             marginContainer: const EdgeInsets.all(5.0),
    //             paddingContainer: const EdgeInsets.all(12.0),
    //           ),
    //         );
    //       }).toList(),
    //     ),
    //   ),
    // );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
