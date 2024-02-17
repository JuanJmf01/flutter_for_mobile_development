import 'package:etfi_point/components/widgets/showModalsButtons/buttonAdd.dart';
import 'package:etfi_point/Data/services/providers/stateProviders.dart';
import 'package:etfi_point/Data/services/providers/userStateProvider.dart';
import 'package:etfi_point/Screens/NewsFeed/newsFeed.dart';
import 'package:etfi_point/Screens/perfilPrincipal.dart';
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
    final idUsuarioActualAsync = ref.watch(getCurrentUserProvider);

    return MaterialApp(
      title: 'Riverpod Providers',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(isDarkmode: isDarkMode).getTheme(),
      home: idUsuarioActualAsync.when(
        data: (idUsuarioActual) =>
            Menu(currentIndex: 0, idUsuario: idUsuarioActual),
        error: (_, __) => const Text('No se pudo cargar el nombre'),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class Menu extends ConsumerStatefulWidget {
  const Menu({super.key, required this.currentIndex, this.idUsuario});

  final int currentIndex;
  final int? idUsuario;

  @override
  MenuState createState() => MenuState();
}

class MenuState extends ConsumerState<Menu> {
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

  void _fetchUsuarioProfile(int index) {
    idUsuarioActual = ref.read(getCurrentUserProvider).value;

    _loadPages(idUsuarioActualPage: idUsuarioActual);

    setState(() {
      _currentIndex = index;
    });
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
          : const CleanClass(), //Mostrar mensaje de usuario no loguado e invitar a loguearse
      const CleanClass(),
      const Center(
        child: Text("Widget vacio"),
      ),
      const CleanClass(),
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
          _fetchUsuarioProfile(index);
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

class CleanClass extends StatelessWidget {
  const CleanClass({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
