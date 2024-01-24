import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/proServiciosProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/shoppingCartProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/subCategoriaSeleccionadaProvider.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/buttonAdd.dart';
import 'package:etfi_point/Pages/newsFeed.dart';
import 'package:etfi_point/Pages/filtros.dart';
import 'package:etfi_point/Pages/perfilPrincipal.dart';
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
            create: (_) => ShoppingCartProvider()),
        ChangeNotifierProvider<SubCategoriaSeleccionadaProvider>(
            create: (_) => SubCategoriaSeleccionadaProvider()),
        ChangeNotifierProvider<ProServiciosProvider>(
            create: (_) => ProServiciosProvider())
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
  Future<void> obtenerIdUsuarioAsincrono() async {
    await context.read<UsuarioProvider>().obtenerIdUsuarioActual();
  }

  @override
  void initState() {
    super.initState();
    obtenerIdUsuarioAsincrono();

    // Retrasa la llamada a checkUserSignedIn usando Future.delayed
    Future.delayed(Duration.zero, () {
      context.read<LoginProvider>().checkUserSignedIn();
      print('Una vez SE EJECUTA');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // theme: ThemeData(
        //   appBarTheme: AppBarTheme(
        //       color: Colors.grey.shade200 // Cambia el color de fondo del AppBar
        //       ),
        //   tabBarTheme: const TabBarTheme(
        //     labelColor:
        //         Colors.black, // Cambia el color del texto de la pestaña activa
        //     unselectedLabelColor: Colors
        //         .grey, // Cambia el color del texto de las pestañas inactivas
        //   ),
        // ),
        title: "Mi app",
        home: FutureBuilder<int>(
          future: context.read<UsuarioProvider>().obtenerIdUsuarioActual(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error al cargar idUsuario');
            } else if (snapshot.hasData) {
              int idUsuarioActual = snapshot.data!;
              return Menu(currentIndex: 0, idUsuario: idUsuarioActual);
            } else {
              return Text('No se encontro idUsuario');
            }
          },
        ));
  }
}

class Menu extends StatefulWidget {
  const Menu({
    super.key,
    required this.currentIndex,
    required this.idUsuario,
  });

  final int currentIndex;
  final int idUsuario;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late int idUsuarioActual;

  int _currentIndex = 0;

  // Lista de clases (páginas) correspondientes a cada pestaña
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _loadPages();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    idUsuarioActual = _fetchUsuarioProfile();
  }

  int _fetchUsuarioProfile() {
    return idUsuarioActual =
        Provider.of<UsuarioProvider>(context).idUsuarioActual;
  }

  void _loadPages() {
    _pages = [
      Home(),
      PerfilPrincipal(
        idUsuario: widget.idUsuario,
      ),
      CleanClass(),
      ShoppingCart(),
      Filtros(),
    ];
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    // Lista de iconos para las pestañas
    List<IconData> _icons = [
      _currentIndex == 0
          // || _currentIndex == 1 && widget.idUsuario != idUsuarioActual
          ? CupertinoIcons.house_fill
          : CupertinoIcons.house,
      _currentIndex == 1
          //&& widget.idUsuario == idUsuarioActual
          ? CupertinoIcons.bag_fill
          : CupertinoIcons.bag,
      CupertinoIcons.add,
      _currentIndex == 3
          ? CupertinoIcons.cart_fill
          : CupertinoIcons.shopping_cart,
      CupertinoIcons.search,
    ];

    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
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
      items: _icons.map((icon) {
        return BottomNavigationBarItem(
          icon: Icon(
            icon,
            size: 26.0,
            color: _currentIndex == _icons.indexOf(icon)
                ? Colors.black
                : Colors.grey.shade700,
          ),
          label: '',
        );
      }).toList(),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key, required this.idUsuario}) : super(key: key);

  final int idUsuario;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Mostrar idUsuario: $idUsuario"),
    );
  }
}

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Página de favoritos'),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Página de notificaciones'),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Página de perfil'),
    );
  }
}

class CleanClass extends StatelessWidget {
  const CleanClass({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
