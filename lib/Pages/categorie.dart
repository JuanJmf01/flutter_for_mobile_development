import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Utils/IndividualProduct.dart';
import 'package:flutter/material.dart';

class Categorie extends StatelessWidget {
  const Categorie({super.key, required this.idCategoria});

  final int idCategoria;

  @override
  Widget build(BuildContext context) {

    List<ProductoTb> productos = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        //title: const Text('Title', style: TextStyle(color: Colors.black),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 23,),
          onPressed: () =>  Navigator.pop(context),
        )
      ),
      body: FutureBuilder<List<ProductoTb>>(
        future: ProductoDb.getProductosByCategoria(idCategoria), // Llamada al método que recupera los productos
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            productos = snapshot.data!;
            return ListView(
              children: [
                RowProducts(productos:productos), // Pasar la lista de productos al widget RowProducts
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error al cargar los productos');
          }
          // Mostrar un indicador de carga
          return const Center(child: CircularProgressIndicator());
          
        },
      ),
    );
  }
}
