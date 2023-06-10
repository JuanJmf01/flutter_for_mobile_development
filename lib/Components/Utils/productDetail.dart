import 'dart:io';

import 'package:etfi_point/Components/Auth/auth.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Utils/ConfirmationDialog.dart';
import 'package:etfi_point/Components/Utils/buttonLogin.dart';
import 'package:etfi_point/Pages/editarProducto.dart';
import 'package:flutter/material.dart';




class ProductDetail extends StatefulWidget {
  ProductDetail({super.key, required this.id,});

  final int id;
  

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {

  //GoogleSignIn googleSignIn = Auth.googleSignIn;


  ProductoTb? producto;
  ProductoTb productoAux = ProductoTb(
    nombreProducto: '',
    precio: 0,
    cantidadDisponible: 0,
    imagePath: ''
  );

  String? accionA_Ejecutar;

  @override
  void initState() {
    super.initState();
    //print(result);

    // print(update);
    // if(update == true){
    //   print(update);
    //   print('Funciona');
    //   //updatedProduct();
    // }

  }

void updatedProduct() async {
  print(accionA_Ejecutar);
  try {
    final productoAux = await ProductoDb.individualProduct(widget.id);
    setState(() {
      producto = productoAux;
      //result = false;
    });
    } catch (error) {
      print('Error al obtener el producto: $error');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        leading: IconButton(
          icon: const Icon( Icons.arrow_back, color: Colors.black, size: 23, ),
          onPressed: () => Navigator.pop(context, accionA_Ejecutar),
        ),
        actions: [
          const SizedBox(width: 100,),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(17),
              ),
              child: IconButton(
                onPressed: () async{
                  if (producto != null) {
                    accionA_Ejecutar = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarProducto(producto: producto ?? productoAux),
                      ),
                    );
                  } else {
                    // Manejar la situación cuando producto es nulo
                    // Por ejemplo, mostrar un mensaje de error o tomar otra acción apropiada
                  }
                  if(accionA_Ejecutar == 'update'){
                    updatedProduct();
                  }
                },               
                icon: const Icon(
                  Icons.mode_edit_outline_sharp, size: 27,
                  color: Colors.blue,
                ),
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(17),
              ),
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        icon: Icons.thumb_up_alt_outlined,
                        titulo: 'Advertencia',
                        message: '¿Seguro que deseas eleiminar este producto?',
                        onAcceptMessage: 'Aceptar',
                        onCancelMessage: 'Cancelar',
                        onAccept: () async {
                          try {
                            await ProductoDb.delete(widget.id);
                            Navigator.of(context).pop(); 
                            Navigator.pop(context, 'delete');
                            // Realizar cualquier otra acción necesaria después de eliminar el producto
                            } catch (error) {
                              // Manejar cualquier error que ocurra durante la eliminación del producto
                              print('Error al eliminar el producto: $error');
                            }
                        },
                        onCancel: () {
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => const MisProductos()));
                          Navigator.of(context).pop();
                        },
                        
                      );
                    },
                  );               
                },
                icon: const Icon(
                  Icons.delete_rounded, size: 26,
                  color: Color.fromARGB(255, 255, 17, 0)
                ),
              ),
            )
          ),
        ],
      ),
      body: FutureBuilder<ProductoTb>(
        future: ProductoDb.individualProduct(widget.id), // Consultar el producto por idProducto
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            producto = snapshot.data!;
            return Container(
              child: Stack(
                children: [
                  Center(
                    child: ListView(
                      children: [
                        Image.file(File(producto!.imagePath), width: null,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 3.0, 10.0),
                          child: Row(
                            children: [
                              const Text('COP ', style: TextStyle( fontWeight: FontWeight.w700, fontSize: 19)),
                              Container(
                                margin: const EdgeInsets.only(top: 5.4),
                                child: Text(producto!.precio.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                              )
                            ],
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 25.0, 0.0),
                            child: Text(
                              producto!.descripcion!.isNotEmpty ? producto!.descripcion! : 'No hay descripcion que mostrar para este producto', 
                              style: const TextStyle(fontSize: 13.3),
                            ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 80.0),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 57.0,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (Auth.isUserSignedIn()) {
                                print('Se ha iniciado sesion');
                                } else {
                                  showModalBottomSheet(
                                    context: context, 
                                    isScrollControlled: true, 
                                    builder: (BuildContext context) => ButtonLogin(titulo: 'Iniciar sesion para continuar',),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                    ),
                                  );
                                }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[100],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80, vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Text('Comprar', style: TextStyle( color: Colors.blue, fontSize: 15,),),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 15.0, 0.0),
                            child: Container(
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.pink[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.shopping_cart_sharp,
                                  color: Colors.pink,
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('Error al cargar el producto');
          }
          // Mientras se carga el producto, puedes mostrar un indicador de carga, por ejemplo:
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
