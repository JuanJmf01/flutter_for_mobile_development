import 'package:etfi_point/Components/Auth/auth.dart';
import 'package:etfi_point/Pages/allProducts.dart';
import 'package:etfi_point/Pages/misProductos.dart';
import 'package:etfi_point/Pages/pagina02.dart';
import 'package:etfi_point/Pages/shoppingCart.dart';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


// void main () async{
//   WidgetsFlutterBinding.ensureInitialized();


//   ProductoTb producto1 = ProductoTb(
//     idNegocio: 1,
//     nombreProducto: "Doritos",
//     precio: 2000.00,
//     descripcion: "Doritos morados 75g",
//     cantidadDisponible: 10, 
//     oferta: 0,
//     imagePath: "/data/user/0/com.example.etfi_point/cache/7c8d9b65-918d-432b-acaf-a877db70bcbd/Dorito.jpg"
//   );

//    ProductoTb producto2 = ProductoTb(
//     idNegocio: 1,
//     nombreProducto: "Cocacola",
//     precio: 2300.00,
//     descripcion: "Cocacola con azucar 750Ml. Personal",
//     cantidadDisponible: 3, 
//     oferta: 1,
//     imagePath: "/data/user/0/com.example.etfi_point/cache/8b8008f4-7ac0-425e-a2b6-eb882c21bf71/Cocacola.jpg"
//   );

//   ProductoTb producto3 = ProductoTb(
//     idNegocio: 2,
//     nombreProducto: "Galleta de helado",
//     precio: 3000.00,
//     descripcion: "Galleta rellena de helado. Diferentes sabores",
//     cantidadDisponible: 3, 
//     oferta: 0,
//     imagePath: "/data/user/0/com.example.etfi_point/cache/9fdceb59-0e55-4a87-9d43-ef3617ed8c0c/GalletaHelado.jpg"
//   );

//   ProductoTb producto4 = ProductoTb(
//     idNegocio: 2,
//     nombreProducto: "Mango en bolsa",
//     precio: 2000.00,
//     descripcion: "Mango picado en bolsa maduro y biche. Sal, limon y/o pimienta",
//     cantidadDisponible: 7, 
//     oferta: 1,
//     imagePath: "/data/user/0/com.example.etfi_point/cache/bd2d5f0a-2d60-4bef-83a8-a23054fd3e1f/Mango.jpg"
//   );



//   await ProductoDb.insert(producto1);
//   await ProductoDb.insert(producto2);
//   await ProductoDb.insert(producto3);
//   await ProductoDb.insert(producto4);

// //Mecato
//   ProductoCategoriaTb productoCategoria1 = ProductoCategoriaTb(
//     idProducto: 1,
//     idCategoria: 1
//   );
  
//   //Liquido
//     ProductoCategoriaTb productoCategoria2 = ProductoCategoriaTb(
//     idProducto: 2,
//     idCategoria: 3
//   );

//     ProductoCategoriaTb productoCategoria22 = ProductoCategoriaTb(
//     idProducto: 2,
//     idCategoria: 2
//   );

//   //Helado
//     ProductoCategoriaTb productoCategoria3 = ProductoCategoriaTb(
//     idProducto: 3,
//     idCategoria: 2
//   );

//    //Helado
//     ProductoCategoriaTb productoCategoria33 = ProductoCategoriaTb(
//     idProducto: 3,
//     idCategoria: 4
//   );

//   //Fruta
//     ProductoCategoriaTb productoCategoria4 = ProductoCategoriaTb(
//     idProducto: 4,
//     idCategoria: 2
//   );


//     await ProductosCategoriasDb.insert(productoCategoria1);
//     await ProductosCategoriasDb.insert(productoCategoria2);
//     await ProductosCategoriasDb.insert(productoCategoria22);
//     await ProductosCategoriasDb.insert(productoCategoria3);
//     await ProductosCategoriasDb.insert(productoCategoria33);
//     await ProductosCategoriasDb.insert(productoCategoria4);










  // UsuarioTb usuario0 = UsuarioTb(
  //   nombres: "Juan",
  //   apellidos: "Cliente",
  //   email: "juanCliente@gmail.com",
  //   numeroCelular: "3003236322",
  //   domiciliario: 0,
  //   password: "JuanCliente123"
  // );


  // UsuarioTb usuario1 = UsuarioTb(
  //   nombres: "Juan",
  //   apellidos: "Vendedor",
  //   email: "juanVendedor@gmail.com",
  //   numeroCelular: "3003236322",
  //   domiciliario: 0,
  //   password: "JuanVendedor123"
  // );

  // UsuarioTb usuario2 = UsuarioTb(
  //   nombres: "Ana",
  //   apellidos: "Vendedora",
  //   email: "anaVendedora@gmail.com",
  //   numeroCelular: "3023680366",
  //   domiciliario: 0,
  //   password: "AnaVendedora123"
  // );

  // NegocioTb negocio1 = NegocioTb(
  //   idUsuario: 2,
  //   nombreNegocio: "JuanVende",
  //   descripcionNegocio: "DetoditoUnPoco",
  //   facebook: "https://es-la.facebook.com/",
  //   vendedor: 0
  // );

  // NegocioTb negocio2 = NegocioTb(
  //   idUsuario: 3,
  //   nombreNegocio: "AnaVende",
  //   descripcionNegocio: "UnPocoDeAna",
  //   instagram: "https://www.instagram.com/",
  //   vendedor: 0
  // );

  // await UsuarioDb.insert(usuario0);

  // await UsuarioDb.insert(usuario1);
  // await NegocioDb.insert(negocio1);
  // await UsuarioDb.insert(usuario2);
  // await NegocioDb.insert(negocio2);

  // CategoriaTb categoria1 = CategoriaTb(
  //   nombre: "Mecato",
  //   imagePath: "/data/user/0/com.example.etfi_point/cache/8884bfbb-4762-4799-88a3-5d5471da2868/MecatoLogoR.png"
  // );
  // CategoriaTb categoria2 = CategoriaTb(
  //   nombre: "Dulces",
  //   imagePath: "/data/user/0/com.example.etfi_point/cache/60b5c0d6-e29b-4afc-9a0e-e141bf4d97e8/chucheria.png"
  // );
  // CategoriaTb categoria3 = CategoriaTb(
  //   nombre: "Liquidos",
  //   imagePath: "/data/user/0/com.example.etfi_point/cache/f2a6110b-66d9-4e45-8ee3-c88458bdc43b/refresco.png"
  // );
  // CategoriaTb categoria4 = CategoriaTb(
  //   nombre: "Helados",
  //   imagePath: "/data/user/0/com.example.etfi_point/cache/3dd3479b-e762-40cd-a0c2-de278f809948/HeladoLogoR.png"
  // );
  // CategoriaTb categoria5 = CategoriaTb(
  //   nombre: "Frutas",
  //   imagePath: "/data/user/0/com.example.etfi_point/cache/ba669002-8c4d-4df6-bcfd-1394874191f9/FrutasLogoR.png"
  // );
  // CategoriaTb categoria6 = CategoriaTb(
  //   nombre: "Restaurantes",
  //   imagePath: "/data/user/0/com.example.etfi_point/cache/e96ca00f-5c62-4c0f-905d-084a95c81e15/pizza.png"
  // );


  // await CategoriaDb.insert(categoria1);
  // await CategoriaDb.insert(categoria2);
  // await CategoriaDb.insert(categoria3);
  // await CategoriaDb.insert(categoria4);
  // await CategoriaDb.insert(categoria5);
  // await CategoriaDb.insert(categoria6);


// }


// void main() async {

//   WidgetsFlutterBinding.ensureInitialized();

//   // Creamos un objeto PruebaTb con los datos que queremos insertar
//   PruebaTb nuevaPrueba = PruebaTb(nombre: "Prueba 1",);

//   // Insertamos el objeto en la tabla "pruebas"
//   await PruebasDb.insert(nuevaPrueba);

//   // Cerramos la conexión con la base de datos
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        
      ),
      title: "Mi app",
      home: Menu(index: 0,)
    );
  }
}

class Menu extends StatefulWidget {
  Menu({
    super.key,
    required this.index
  });

  int index;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [];

  
  void _selectedOptionBottom(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  
  List<Widget> isUserLoggedIn(){
    if(!Auth.isUserSignedIn()){
      _widgetOptions = <Widget>[
        const Home(),
        const ShoppingCart()
      ];
    }else{
      _widgetOptions = <Widget>[
        const Home(),
        MisProductos(),
        const ShoppingCart()
      ];
    }

    return _widgetOptions;
  }

  
  @override
  void initState() {
    super.initState();

    _selectedOptionBottom(widget.index);
    //_widgetOptions = isUserLoggedIn();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(child: isUserLoggedIn().elementAt(_selectedIndex),), 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _selectedOptionBottom,        

        items:  <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          if(Auth.isUserSignedIn())
            const BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              label: 'My store'
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_sharp),
            label: 'Car'
          ),
        ],
      )
    );
  }
}
























// ---------------------------------------------------------------------------//

class ApiRest extends StatefulWidget {
  const ApiRest({super.key});

  @override
  State<ApiRest> createState() => _ApiRestState();
}

class _ApiRestState extends State<ApiRest> {

  final List<Persona> _personas = [
    const Persona(name: 'Pepe', lastName: 'Lifzing', phone: '3004542216'),
    const Persona(name: 'Maria', lastName: 'Restrepo', phone: '3043234412'),
    const Persona(name: 'Sara', lastName: 'Cardona', phone: '30124661265'),
    const Persona(name: 'Martin', lastName: 'Gomez', phone: '3021237890'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: _personas.length,
        itemBuilder: (context, index){
          return ListTile(
            onTap: (){
              _borrarPersona(context, _personas[index]);
            },
            title: Text(_personas[index].name + ' ' + _personas[index].lastName),
            subtitle: Text(_personas[index].phone),
            leading: CircleAvatar(
              child: Text(_personas[index].name.substring(0,2)),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        }
      )
    );
  }

  _borrarPersona(context, Persona persona){
    showDialog(
      context: context, 
      builder: ( _ ) => AlertDialog(
        title: const Text("Eliminar Contacto"),
        content: Text('Seguro quieres eliminar a ${persona.name}'),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context);

          },child: const Text('Cancelar')),

          ElevatedButton(onPressed: (){
            setState(() {
              _personas.remove(persona);
            });

            Navigator.pop(context);

          },child: const Text('Borrar'))
        ],
    ));
  }

}

class Persona extends StatelessWidget {
  const Persona({super.key, 
    required this.name, 
    required this.lastName, 
    required this.phone
  });

  final name;
  final lastName;
  final phone;


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


// ---------------------------------------------------------------------------//

class Navegacion extends StatefulWidget {
  const Navegacion({super.key});

  @override
  State<Navegacion> createState() => _NavegacionState();
}

class _NavegacionState extends State<Navegacion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
      ),
      body:  Center(
       child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Navigation'),
          ElevatedButton(
            child: const Text('Precioname'),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Pagina02())
              )
            }

          )
        ],
       )
      ),
    );
  }
}


//----------------------------------------------------------------------------------//


class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: cuerpo());
  }
}

Widget cuerpo() {
  return Container(
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'https://img.freepik.com/vector-premium/fondo-abstracto-azulejos-hexagonales-negros-espacios-grises-ellos_444390-17273.jpg?w=360'),
            fit: BoxFit.cover)),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          const Text('Hola 2.0', style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),),
          const Usuario(placeholder: 'Usuario', passOrNot: false,),
          const Usuario(placeholder: 'Contraseña', passOrNot: true,),
          button()
        ],
      )
    ),
  );
}

class Usuario extends StatelessWidget{
    const Usuario({
      super.key, 
      required this.placeholder,
      required this.passOrNot
    });

    final String placeholder;
    final bool passOrNot;

    Widget build(BuildContext context){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
        child: TextField(
          obscureText: passOrNot,
          decoration: InputDecoration(
            hintText: placeholder ,
            fillColor: Colors.white54,
            filled: true
          ),
        ),
      );
    }

}


Widget button(){
  return ElevatedButton(
    child: const Text('Entrar'),
    onPressed: () => {
      print('Funciona')
    },
  );
}


//-------------------------------------------------------------------------------//

