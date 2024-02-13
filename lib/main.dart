import 'package:etfi_point/Components/Utils/showModalsButtons/buttonAdd.dart';
import 'package:etfi_point/Components/providers/stateProviders.dart';
import 'package:etfi_point/Components/providers/userStateProvider.dart';
import 'package:etfi_point/Screens/NewsFeed/newsFeed.dart';
import 'package:etfi_point/Screens/filtros.dart';
import 'package:etfi_point/Screens/perfilPrincipal.dart';
import 'package:etfi_point/Screens/shoppingCart.dart';
import 'package:etfi_point/config/router/app_router.dart';
import 'package:etfi_point/config/theme/appTheme.dart';
import 'package:etfi_point/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appThemeColorProvider);

    return MaterialApp(
      title: 'Riverpod Providers',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(isDarkmode: isDarkMode).getTheme(),
      home: const Home2(),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<LoginProvider>(
//           create: (_) => LoginProvider(),
//         ),
//         ChangeNotifierProvider<UsuarioProvider>(
//           create: (_) => UsuarioProvider(),
//         ),
//         ChangeNotifierProvider<ShoppingCartProvider>(
//             create: (_) => ShoppingCartProvider()),
//         ChangeNotifierProvider<SubCategoriaSeleccionadaProvider>(
//             create: (_) => SubCategoriaSeleccionadaProvider()),
//         ChangeNotifierProvider<ProServiciosProvider>(
//             create: (_) => ProServiciosProvider())
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int? idUsuarioActual;

//   Future<void> obtenerIdUsuarioAsincrono() async {
//     await context.read<UsuarioProvider>().obtenerIdUsuarioActual();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Retrasa la llamada a checkUserSignedIn usando Future.delayed
//     Future.delayed(Duration.zero, () {
//       context.read<LoginProvider>().checkUserSignedIn();
//       print('Una vez SE EJECUTA');
//     });

//     obtenerIdUsuarioAsincrono();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           appBarTheme: const AppBarTheme(
//             titleTextStyle: TextStyle(
//                 color: Colors.black, // Color del texto del título del AppBar
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 letterSpacing: 0.3),
//             iconTheme: IconThemeData(
//               color: Colors
//                   .black, // Color de los iconos en las acciones del AppBar
//             ),
//             elevation:
//                 0, // Establece la elevación en cero para quitar la línea inferior del AppBar
//             color: Colors.white, // Color AppBar
//           ),
//           scaffoldBackgroundColor:
//               Colors.white, // Color de fondo de la pantalla
//         ),
//         title: "Mi app",
//         home: FutureBuilder<int?>(
//           future: context.read<UsuarioProvider>().obtenerIdUsuarioActual(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return const Text('Error al cargar idUsuario');
//             } else if (snapshot.hasData) {
//               idUsuarioActual = snapshot.data;
//               return Menu(
//                 currentIndex: 0,
//                 idUsuario: idUsuarioActual,
//               );
//             } else {
//               return Menu(
//                 currentIndex: 0,
//                 idUsuario: idUsuarioActual,
//               );
//             }
//           },
//         ));
//   }
// }

class Menu extends StatefulWidget {
  const Menu(
      {super.key,
      required this.currentIndex,
      this.idUsuario,
      this.ejecutarIdActual});

  final int currentIndex;
  final int? idUsuario;
  final bool? ejecutarIdActual;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int? idUsuarioActual;
  int _currentIndex = 0;

  // Lista de clases (páginas) correspondientes a cada pestaña
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    idUsuarioActual = widget.idUsuario;

    _currentIndex = widget.currentIndex;
    _loadPages(
      idUsuarioActualPage: idUsuarioActual,
    );
  }

  //Se ejecuta despues del initState
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.ejecutarIdActual != null) {
      _fetchUsuarioProfile(widget.ejecutarIdActual!);
    }
  }

  void _fetchUsuarioProfile(bool ejecutarIdUsuarioActual) {
    // if (ejecutarIdUsuarioActual) {
    //   idUsuarioActual =
    //       Provider.of<UsuarioProvider>(context, listen: false).idUsuarioActual;
    //   _loadPages(idUsuarioActualPage: idUsuarioActual);
    // }
  }

  void mostrarModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => const ButtonAdd(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
    );
  }

  void _loadPages({int? idUsuarioActualPage}) {
    _pages = [
      const Home(),
      idUsuarioActualPage != null
          ? PerfilPrincipal(
              idUsuario: idUsuarioActual!,
            )
          : const Filtros(), //Mostrar mensaje de usuario no loguado e invitar a loguearse
      const CleanClass(),
      const ShoppingCart(),
      const Filtros(),
    ];
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
    List<IconData> icons = [
      _currentIndex == 0 ? CupertinoIcons.house_fill : CupertinoIcons.house,
      _currentIndex == 1 ? CupertinoIcons.bag_fill : CupertinoIcons.bag,
      CupertinoIcons.add,
      _currentIndex == 3
          ? CupertinoIcons.cart_fill
          : CupertinoIcons.shopping_cart,
      CupertinoIcons.search,
    ];

    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 1) {
          _fetchUsuarioProfile(true);
          setState(() {
            _currentIndex = index;
          });
        } else if (index == 2) {
          mostrarModal(context);
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      items: icons.map((icon) {
        return BottomNavigationBarItem(
          icon: Icon(
            icon,
            size: 26.0,
            color: _currentIndex == icons.indexOf(icon)
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
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Página de favoritos'),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Página de notificaciones'),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
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
