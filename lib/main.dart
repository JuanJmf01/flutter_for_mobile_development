import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/shoppingCartProvider.dart';
import 'package:etfi_point/Pages/allProducts.dart';
import 'package:etfi_point/Pages/filtros.dart';
import 'package:etfi_point/Pages/misProductos.dart';
import 'package:etfi_point/Pages/pagina02.dart';
import 'package:etfi_point/Pages/shoppingCart.dart';
import 'package:etfi_point/firebase_options.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// class CategoriaApi {
//   static const baseUrl = 'http://ipconfig/api';

//   static Future<List<CategoriaTb>> getCategorias() async {
//     try {
//       Dio dio = Dio();
//       Response response = await dio.get('$baseUrl/categorias');

//       if (response.statusCode == 200) {
//         List<dynamic> jsonList = response.data;
//         List<CategoriaTb> categorias = jsonList.map((json) => CategoriaTb.fromJson(json)).toList();
//         return categorias;
//       } else {
//         throw Exception('Failed to fetch categories');
//       }
//     } catch (error) {
//       throw Exception('Error: $error');
//     }
//   }
// }

// void main() async {
//   try {
//     List<CategoriaTb> categorias = await CategoriaApi.getCategorias();
//     print(categorias);
//     for (var categoria in categorias) {
//       print('ID: ${categoria.idCategoria}, Nombre: ${categoria.nombre}, ImagePath: ${categoria.imagePath}');
//     }
//   } catch (error) {
//     print('Error: $error');
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider<UsuarioProvider>(
          create: (_) => UsuarioProvider(),
        ),
        ChangeNotifierProvider<ShoppingCartProvider>(
            create: (_) => ShoppingCartProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    print('Una vez SE EJECUTA');
    context.read<LoginProvider>().checkUserSignedIn();
    context.read<UsuarioProvider>().obtenerIdUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(),
        title: "Mi app",
        home: Menu(
          index: 0,
        ));
  }
}

class Menu extends StatefulWidget {
  Menu({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [];

  void _selectedOptionBottom(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> isUserLoggedIn(bool isUserSignedIn) {
    print('IMPRIMIR: $isUserSignedIn');
    if (!isUserSignedIn) {
      _widgetOptions = <Widget>[const Home(), ShoppingCart(), Filtros()];
    } else {
      _widgetOptions = <Widget>[
        const Home(),
        MisProductos(),
        ShoppingCart(),
        Filtros()
      ];
    }

    return _widgetOptions;
  }

  @override
  void initState() {
    super.initState();
    _selectedOptionBottom(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    bool isUserSignedIn = context.watch<LoginProvider>().isUserSignedIn;

    return Scaffold(
      body: Container(
        child: isUserLoggedIn(isUserSignedIn).elementAt(_selectedIndex),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Builder(
          builder: (BuildContext context) {
            return BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _selectedOptionBottom,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    _selectedIndex == 0
                        ? CupertinoIcons.house_fill
                        : CupertinoIcons.house,
                    color: _selectedIndex == 0
                        ? Colors.black
                        : const Color.fromARGB(185, 0, 0, 0),
                    size: _selectedIndex == 0 ? 26.0 : 24.0,
                  ),
                  label: '',
                ),
                if (isUserSignedIn)
                  BottomNavigationBarItem(
                    icon: Icon(
                      _selectedIndex == 1
                          ? CupertinoIcons.bag_fill
                          : CupertinoIcons.bag,
                      color: Colors.black,
                      size: _selectedIndex == 1 ? 29.0 : 26.0,
                    ),
                    label: '',
                  ),
                BottomNavigationBarItem(
                  icon: Icon(
                    _selectedIndex == 2
                        ? CupertinoIcons.cart_fill
                        : CupertinoIcons.shopping_cart,
                    color: Colors.black,
                    size: _selectedIndex == 2 ? 28.0 : 24.0,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.search,
                    color: Colors.black,
                    size: _selectedIndex == 3 ? 28.0 : 24.0,
                  ),
                  label: '',
                ),
              ],
            );
          },
        ),
      ),
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
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  _borrarPersona(context, _personas[index]);
                },
                title: Text(
                    _personas[index].name + ' ' + _personas[index].lastName),
                subtitle: Text(_personas[index].phone),
                leading: CircleAvatar(
                  child: Text(_personas[index].name.substring(0, 2)),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              );
            }));
  }

  _borrarPersona(context, Persona persona) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Eliminar Contacto"),
              content: Text('Seguro quieres eliminar a ${persona.name}'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _personas.remove(persona);
                      });

                      Navigator.pop(context);
                    },
                    child: const Text('Borrar'))
              ],
            ));
  }
}

class Persona extends StatelessWidget {
  const Persona(
      {super.key,
      required this.name,
      required this.lastName,
      required this.phone});

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
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Navigation'),
          ElevatedButton(
              child: const Text('Precioname'),
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Pagina02()))
                  })
        ],
      )),
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
    return Scaffold(body: cuerpo());
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
      children: [
        const Text(
          'Hola 2.0',
          style: TextStyle(
              color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
        ),
        const Usuario(
          placeholder: 'Usuario',
          passOrNot: false,
        ),
        const Usuario(
          placeholder: 'Contraseña',
          passOrNot: true,
        ),
        button()
      ],
    )),
  );
}

class Usuario extends StatelessWidget {
  const Usuario(
      {super.key, required this.placeholder, required this.passOrNot});

  final String placeholder;
  final bool passOrNot;

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
      child: TextField(
        obscureText: passOrNot,
        decoration: InputDecoration(
            hintText: placeholder, fillColor: Colors.white54, filled: true),
      ),
    );
  }
}

Widget button() {
  return ElevatedButton(
    child: const Text('Entrar'),
    onPressed: () => {print('Funciona')},
  );
}

//-------------------------------------------------------------------------------//
