import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/shoppingCartProvider.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/buttonAdd.dart';
import 'package:etfi_point/Pages/allProducts.dart';
import 'package:etfi_point/Pages/filtros.dart';
import 'package:etfi_point/Pages/misProductos.dart';
import 'package:etfi_point/Pages/shoppingCart.dart';
import 'package:etfi_point/firebase_options.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

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
      child: const MyApp(),
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

    // Retrasa la llamada a checkUserSignedIn usando Future.delayed
    Future.delayed(Duration.zero, () {
      context.read<LoginProvider>().checkUserSignedIn();
      print('Una vez SE EJECUTA');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              color: Colors.grey.shade200 // Cambia el color de fondo del AppBar
              ),
          tabBarTheme: const TabBarTheme(
            labelColor:
                Colors.black, // Cambia el color del texto de la pestaña activa
            unselectedLabelColor: Colors
                .grey, // Cambia el color del texto de las pestañas inactivas
          ),
        ),
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
  int _currentIndex = 0;

  final List<Widget> screens = [
    Home(),
    ProfileNavigator(),
    CleanClass(),
    ShoppingCart(idUsuario: 1),
    Filtros(),
  ];

  void mostrarModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => ButtonAdd(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
    );
  }

  Future<void> obtenerIdUsuarioAsincrono() async {
    await context.read<UsuarioProvider>().obtenerIdUsuario();
  }

  @override
  void initState() {
    super.initState();
    obtenerIdUsuarioAsincrono();
  }

  @override
  Widget build(BuildContext context) {
    bool isUserSignedIn = Provider.of<LoginProvider>(context).isUserSignedIn; //
    int? idUsuario = context.watch<UsuarioProvider>().idUsuario;

    return Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 2) {
              mostrarModal(context);
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          showSelectedLabels:
              false, //Evitar que se desplace el icono hacia arriba al ser seleccionado
          showUnselectedLabels: false, //Sin text tipo label debajo del icono
          type: BottomNavigationBarType
              .fixed, //Evitar que se mueva el icono a los lados al ser seleccionado
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 0
                    ? CupertinoIcons.house_fill
                    : CupertinoIcons.house,
                color: _currentIndex == 0
                    ? Colors.black
                    : const Color.fromARGB(185, 0, 0, 0),
                size: _currentIndex == 0 ? 26.0 : 24.0,
              ),
              label: '',
            ),
            if (isUserSignedIn)
              BottomNavigationBarItem(
                icon: Icon(
                  _currentIndex == 1
                      ? CupertinoIcons.bag_fill
                      : CupertinoIcons.bag,
                  color: Colors.black,
                  size: _currentIndex == 1 ? 29.0 : 26.0,
                ),
                label: '',
              ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.add, size: 30,),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 2
                    ? CupertinoIcons.cart_fill
                    : CupertinoIcons.shopping_cart,
                color: Colors.black,
                size: _currentIndex == 2 ? 28.0 : 24.0,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.search,
                color: Colors.black,
                size: _currentIndex == 3 ? 28.0 : 24.0,
              ),
              label: '',
            ),
          ],
        ));
  }
}

class CleanClass extends StatelessWidget {
  const CleanClass({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

