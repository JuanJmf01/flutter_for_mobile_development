import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Utils/productDetail.dart';
import 'package:flutter/material.dart';

class RowProducts extends StatefulWidget {
  RowProducts({super.key, required this.productos});

  final List<ProductoTb> productos;

  @override
  State<RowProducts> createState() => _RowProductsState();
}

class _RowProductsState extends State<RowProducts> {

  List<ProductoTb> productos = [];

  bool hasProducts = false;
  String? result = '';

  @override
  void initState() {
    super.initState();

    print(result);

    productos = widget.productos;
    hasProducts = widget.productos.isNotEmpty;
  }

  Future<void> _navigateToProductDetail(int productId) async {
    result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetail(id: productId),
      ),
    );
    print('Ha llegado a _navigateToProduct');
    print(result);
    if(result == 'update'){
      updatedProduct(productId);
    }else if(result == 'delete'){
      print('ha llegado al if delete');
      deleteProduct(productId);
    }else if(result == 'add'){

    }
  }

  //ACTUALIZACION DE ESTADO
  //Actualiza el producto en la lista 'productos' una vez se actualizo en BD (update)
  void updatedProduct(id) async {
    print('Ha llegado a updateproduct');
    print(result);
    try {
      final productoAux = await ProductoDb.individualProduct(id);
      setState(() {
        productos.removeWhere((element) => element.idProducto == id);
        productos.add(productoAux);
        productos.sort((a, b) => a.idProducto!.compareTo(b.idProducto ?? 1));
      });
    } catch (error) {
      print('Error al obtener el producto: $error');
    }
  }

  
  //ACTUALIZACION DE ESTADO
  //Actualiza el producto en la lista 'productos' una vez se actualizo en BD (Delete)
  void deleteProduct(id){
    print('Ha llegado a deleteProduct');
    print(result);
    setState(() {
      productos.removeWhere((element) => element.idProducto == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (productos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: Text('No hay productos que mostrar'),
        ),
      );
    } else {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10.0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: productos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            mainAxisSpacing: 15, // Spacing between each row
            crossAxisSpacing: 0, // Spacing between each column
            childAspectRatio: 1, // Width/height ratio of each child
          ),
          itemBuilder: (BuildContext context, int index) {
            final ProductoTb producto = productos[index];
            return Column(
              children: [
                Expanded(
                  child: InkWell(
                      onTap: () {
                        _navigateToProductDetail(producto.idProducto ?? 1);
                      },
                      child: SizedBox(
                        width: 180.0,
                        child: Image.file(File(producto.imagePath)),
                      )),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                  child: Row(
                    children: [
                      const Text(
                        'COP: ',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18.0),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 2.0),
                        child: Text(
                          producto.precio.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16.6),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );

            // return IndividualProduct(
            //   producto: producto,
            // );
          },
        ),
      );
    }
  }
}