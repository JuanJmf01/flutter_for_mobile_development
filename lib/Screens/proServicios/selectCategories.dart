import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Utils/categoriesList.dart';
import 'package:etfi_point/Components/providers/categoriasProvider.dart';
import 'package:etfi_point/Screens/proServicios/sectionTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectCategories extends ConsumerStatefulWidget {
  const SelectCategories({
    super.key,
    required this.categoriasDisponibles,
  });

  final List<CategoriaTb> categoriasDisponibles;

  @override
  SelectCategoriesState createState() => SelectCategoriesState();
}

class SelectCategoriesState extends ConsumerState<SelectCategories>
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
    bool deleteOption = true;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  isScrollable: true,
                  onTap: _printSubcategorias,
                  tabs: widget.categoriasDisponibles
                      .map((categoria) => Tab(text: categoria.nombre))
                      .toList(),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: widget.categoriasDisponibles
                      .map(
                        (categoria) => CategoriesList(
                          elementos: categoria.subCategorias,
                          deleteOption: !deleteOption,
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 20.0),
              const SectionTitle(
                title: "Categorias seleccionadas",
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
              subCategoriesSelected.isNotEmpty
                  ? CategoriesList(
                      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 35.0),
                      deleteOption: deleteOption,
                      elementos: subCategoriesSelected,
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 35.0),
                      child: Text(
                        "No has seleccionado ninguna categoria",
                        style: TextStyle(
                            fontSize: 17, color: Colors.grey.shade500),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
