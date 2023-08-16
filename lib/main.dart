import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/shoppingCartProvider.dart';
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
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> obtenerIdUsuarioAsincrono() async {
    await context.read<UsuarioProvider>().obtenerIdUsuario();
  }

  List<Widget> isUserLoggedIn(bool isUserSignedIn, {int? idUsuario}) {
    if (!isUserSignedIn) {
      _widgetOptions = <Widget>[
        const Home(),
        ShoppingCart(
          idUsuario: idUsuario,
        ),
        Filtros()
      ];
    } else {
      _widgetOptions = <Widget>[
        const Home(),
        ProfileNavigator(),
        ShoppingCart(
          idUsuario: idUsuario,
        ),
        Filtros()
      ];
    }

    return _widgetOptions;
  }

  @override
  void initState() {
    super.initState();
    obtenerIdUsuarioAsincrono();
    _selectedOptionBottom(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    bool isUserSignedIn = Provider.of<LoginProvider>(context).isUserSignedIn; //
    int? idUsuario = context.watch<UsuarioProvider>().idUsuario;

    return Scaffold(
      body: Container(
        child:
            isUserLoggedIn(isUserSignedIn, idUsuario: idUsuario).elementAt(_selectedIndex),
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
