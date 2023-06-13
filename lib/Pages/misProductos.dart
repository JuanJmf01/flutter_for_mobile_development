import 'package:etfi_point/Components/Auth/Pages/registerBusiness.dart';
import 'package:etfi_point/Components/Auth/auth.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Utils/IndividualProduct.dart';
import 'package:etfi_point/Components/Utils/ButtonMenu.dart';
import 'package:etfi_point/Components/Utils/roundedSearchBar.dart';
import 'package:etfi_point/Pages/crearProducto.dart';
import 'package:flutter/material.dart';


class MisProductos extends StatefulWidget {
  MisProductos({Key? key}) : super(key: key);

  @override
  State<MisProductos> createState() => _MisProductosState();
}

class _MisProductosState extends State<MisProductos> {

  List<ProductoTb> productos = [];

  ProductoTb? accionAEjecutar;

  @override
  void initState() {
    super.initState();

  }

  void addProduct(producto) async {
    print('Llega aca');
    print(producto);
    setState(() {
      productos.add(producto);
      //result = false;
    });
    print(productos);
  }


  @override
  Widget build(BuildContext context) {

  final TextEditingController searchController = TextEditingController();

  return Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(115.0), // Ajusta la altura según tus necesidades
      child: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text('NickName', style: TextStyle(color: Colors.black), ),
        actions: [
          if(Auth.isUserSignedIn())
            IconButton(
            onPressed: () async {
              accionAEjecutar = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const CrearProducto())
                //MaterialPageRoute(builder: (context) =>   RegisterBusiness())
              );
              //MaterialPageRoute(builder: (context) => const Pruebas()));
              if(accionAEjecutar != null){
                print('se ejecuto la accion');
                print(accionAEjecutar);
                addProduct(accionAEjecutar);
              }
            },
            icon: const Icon(Icons.add_circle_outline, color: Colors.black, size: 33, ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context, 
                  builder: (BuildContext context) => ButtonMenu(),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.menu,color: Colors.black,size: 35,),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), // Ajusta la altura según tus necesidades
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: RoundedSearchBar(
              controller: searchController,
            ),
          ),
        ),
      ),
    ),

      body: FutureBuilder<List<ProductoTb>>(
        future: ProductoDb.getProductosByIdNegocio(), // Llamada al método que recupera los productos
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            productos = snapshot.data!;
            return ListView(
              children: [
                const TopProfile(),
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



class TopProfile extends StatefulWidget {
  const TopProfile({super.key});

  @override
  State<TopProfile> createState() => _TopProfileState();
}

class _TopProfileState extends State<TopProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 30.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment
            .end, //crossAxisAlignment: CrossAxisAlignment.start, // Alineación vertical hacia arriba
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end, // Alineación vertical hacia arriba
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '10k',
                    style: TextStyle(
                      fontSize: 21, // Tamaño de fuente
                      fontWeight: FontWeight.bold, // Negrita del texto
                      // Otros estilos según sea necesario
                    ),
                  ),
                  Text('Vendido'),
                ],
              ),
              SizedBox(width: 20), // Separación vertical entre los textos
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '23k',
                    style: TextStyle(
                      fontSize: 21, // Tamaño de fuente
                      fontWeight: FontWeight.bold, // Negrita del texto
                      //fontFamily: 'Montserrat'
                      // Otros estilos según sea necesario
                    ),
                  ),
                  Text('Comprado'),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
