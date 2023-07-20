import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/shoppingCartTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/shoppingCartDb.dart';
import 'package:etfi_point/Components/Utils/Icons/cartIcons.dart';
import 'package:etfi_point/Components/Utils/Icons/deletedIcons.dart';
import 'package:etfi_point/Components/Utils/Icons/modifyIcons.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/productDetail.dart';
import 'package:etfi_point/Pages/editarProducto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RowProducts extends StatefulWidget {
  RowProducts({super.key, required this.productos});

  final List<ProductoTb> productos;

  @override
  State<RowProducts> createState() => _RowProductsState();
}

class _RowProductsState extends State<RowProducts> {
  List<ProductoTb> productos = [];
  int? result;

  @override
  void initState() {
    super.initState();

    productos = widget.productos;
  }

  Future<void> _navigateToProductDetail(int productId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetail(id: productId),
      ),
    );
  }

  //ACTUALIZACION DE ESTADO
  //Actualiza el producto en la lista 'productos' una vez se actualizo en BD (update)
  void renderizarProductoModificado(idProducto) async {
    try {
      final productoAux = await ProductoDb.getProducto(idProducto);
      setState(() {
        productos.removeWhere((element) => element.idProducto == idProducto);
        productos.add(productoAux);
        productos.sort((a, b) => a.idProducto.compareTo(b.idProducto));
      });
    } catch (error) {
      print(
          'Error al obtener el producto (individualProduct, renderizarProductoAgregadoOModificado): $error');
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
    int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuario;

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
                          _navigateToProductDetail(producto.idProducto);
                        },
                        child: ShowImage(
                          height: 180.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          networkImage: producto.urlImage,
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
                            CartPrincipalIcon(onpress: () async {
                              if (idUsuario != null) {
                                ShoppingCartCreacionTb shoppingCartProduct =
                                    ShoppingCartCreacionTb(
                                  idUsuario: idUsuario,
                                  idProducto: producto.idProducto,
                                  cantidad: 1,
                                );
                                await ShoppingCartDb.insertShoppingCartProduct(
                                    shoppingCartProduct);
                              }
                            }),
                            ModifyPrincipalIcon(onpress: () async {
                              print(producto.idProducto);
                              result = await Navigator.push<int>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditarProducto(producto: producto),
                                ),
                              );
                              if (result != null) {
                                print('Funciona $result');
                                renderizarProductoModificado(result);
                              }
                            }),
                            DeletedPrincipalIcon(
                              onpress: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmationDialog(
                                      titulo: 'Advertencia',
                                      message:
                                          '¿Seguro que deseas eliminar este producto?',
                                      onAcceptMessage: 'Aceptar',
                                      onCancelMessage: 'Cancelar',
                                      onAccept: () async {
                                        try {
                                          print(
                                              'Id producto: ${producto.idProducto}');
                                          await ProductoDb.deleteProducto(
                                              producto.idProducto);
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                          deleteProduct(producto.idProducto);
                                        } catch (error) {
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
                            )
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
