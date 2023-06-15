import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/Components/Utils/productDetail.dart';
import 'package:etfi_point/Pages/editarProducto.dart';
import 'package:flutter/cupertino.dart';
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
    if (result == 'update') {
      updatedProduct(productId);
    } else if (result == 'delete') {
      deleteProduct(productId);
    }
  }

  //ACTUALIZACION DE ESTADO
  //Actualiza el producto en la lista 'productos' una vez se actualizo en BD (update)
  void updatedProduct(id) async {
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
  void deleteProduct(id) {
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
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 20.0,
          mainAxisExtent: 300,
        ),
        itemCount: productos.length,
        itemBuilder: (BuildContext context, index) {
          final ProductoTb producto = productos[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  16.0,
                ),
                color: Colors.grey.shade200,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          _navigateToProductDetail(producto.idProducto ?? 1);
                        },
                        child: Image.file(
                          File(producto.imagePath),
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto.nombreProducto,
                          style: Theme.of(context).textTheme.titleMedium!.merge(
                                const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          "Price two",
                          style: Theme.of(context).textTheme.titleSmall!.merge(
                                TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                        ),
                        Row(
                          children: [
                            // IconButton(
                            //   onPressed: () {},
                            //   icon: Icon(CupertinoIcons.heart, size: 20,),
                            // ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(CupertinoIcons.cart),
                            ),
                            IconButton(
                              onPressed: () async{
                                print(producto.idProducto);
                                result = await Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditarProducto(producto: producto),
                                  ),
                                );
                                if(result == 'update'){
                                  print('Funciona');
                                  print(producto.idProducto);
                                  updatedProduct(producto.idProducto);
                                }
                              },
                              icon: Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmationDialog(
                                      titulo: 'Advertencia',
                                      message:
                                          '¿Seguro que deseas eleiminar este producto?',
                                      onAcceptMessage: 'Aceptar',
                                      onCancelMessage: 'Cancelar',
                                      onAccept: () async {
                                        try {
                                          print(
                                              'Id producto: ${producto.idProducto}');
                                          await ProductoDb.delete(
                                              producto.idProducto ?? 1);
                                          Navigator.of(context).pop();
                                          deleteProduct(producto.idProducto);
                                          // Realizar cualquier otra acción necesaria después de eliminar el producto
                                        } catch (error) {
                                          // Manejar cualquier error que ocurra durante la eliminación del producto
                                          print(
                                              'Error al eliminar el producto: $error');
                                        }
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                CupertinoIcons.delete,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
