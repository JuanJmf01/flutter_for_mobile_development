import 'package:etfi_point/Components/Data/EntitiModels/newsFeedTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/seguidoresTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/usuarioTb.dart';
import 'package:etfi_point/Components/Data/Entities/seguidoresDb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:etfi_point/Pages/proServicios/productos/misProductos.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/elevatedGlobalButton.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Components/Utils/showModalsButtons/buttonFotoPerfilPortada.dart';
import 'package:etfi_point/Pages/enlaces/enlacesImagePublicaciones.dart';
import 'package:etfi_point/Pages/enlaces/enlacesReelPublicaciones.dart';
import 'package:etfi_point/Pages/proServicios/servicios/misServicios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilPrincipal extends StatefulWidget {
  const PerfilPrincipal({
    super.key,
    required this.idUsuario,
  });

  final int idUsuario;

  @override
  State<PerfilPrincipal> createState() => _PerfilPrincipalState();
}

class _PerfilPrincipalState extends State<PerfilPrincipal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late UsuarioPrincipalProfileTb usuarioPrincipal;
  Future<UsuarioPrincipalProfileTb?>? _usuarioProfileFuture;
  final ScrollController _scrollController = ScrollController();
  List<NewsFeedItem> enlacesPublicacion = [];

  UsuarioTb? updatedUserProfile;
  int? idUsuarioActual;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(_handleTabSelection);
    _updateCircleTabs();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('Llegaste al final de la página');
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _usuarioProfileFuture = _fetchUsuarioProfile();
  }

  Future<UsuarioPrincipalProfileTb?>? _fetchUsuarioProfile() async {
    idUsuarioActual = Provider.of<UsuarioProvider>(context).idUsuarioActual;
    if (idUsuarioActual != null) {
      return UsuarioDb.getUsuarioProfile(idUsuarioActual!, widget.idUsuario);
    }
    return null;
  }

  void _updateCircleTabs() {
    for (int i = 0; i < 3; i++) {
      _circleTabs[i].isSelected = (i == _tabController.index);
    }
  }

  void _handleTabSelection() {
    if (_circleTabs[_tabController.index].isSelected != true) {
      setState(() {
        _updateCircleTabs();
      });
    }
  }

  void showModalButtonFotoPerfilPortada(String typePhoto, bool isProfilePicture,
      {String? urlPhoto}) {
    bool isUrlPhotoAvailable = urlPhoto != null && urlPhoto != '';

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => ButtonFotoPerfilPortada(
        verFoto: "Ver foto de $typePhoto",
        cambiarFoto: isUrlPhotoAvailable
            ? "Cambiar foto de $typePhoto"
            : "Agregar foto de $typePhoto",
        eliminarFoto:
            isUrlPhotoAvailable ? "Eliminar foto de $typePhoto" : null,
        isProfilePicture: isProfilePicture,
        isUrlPhotoAvailable: isUrlPhotoAvailable,
        onProfileUpdated: (profile) async {
          setState(() {
            updatedUserProfile = profile;
          });
        },
      ),
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
    double screenHeight = MediaQuery.of(context).size.height;
    _updateCircleTabs();

    return Scaffold(
      body: FutureBuilder<UsuarioPrincipalProfileTb?>(
        future: _usuarioProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('Error al cargar el usuario');
          } else if (snapshot.hasData) {
            usuarioPrincipal = snapshot.data!;
            String? urlFotoPerfil = usuarioPrincipal.urlFotoPerfil;
            String? urlFotoPortada = usuarioPrincipal.urlFotoPortada;

            String? updatedUrlFotoPerfil;
            String? updatedUrlFotoPortada;
            if (updatedUserProfile != null) {
              updatedUrlFotoPerfil = updatedUserProfile!.urlFotoPerfil;
              updatedUrlFotoPortada = updatedUserProfile!.urlFotoPortada;
            }
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: screenHeight * 0.4,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalButtonFotoPerfilPortada(
                              "portada",
                              false,
                              urlPhoto: urlFotoPortada ?? updatedUrlFotoPortada,
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Colors.grey.shade200,
                            ),
                            child: Stack(
                              children: [
                                if ((urlFotoPortada != null &&
                                        urlFotoPortada.isNotEmpty) ||
                                    (updatedUrlFotoPortada != null &&
                                        updatedUrlFotoPortada.isNotEmpty))
                                  ShowImage(
                                    networkImage: '',
                                    //updatedUrlFotoPortada ?? urlFotoPortada,
                                    fit: BoxFit.cover,
                                    widthNetWork: double.infinity,
                                    heightNetwork: screenHeight * 0.5,
                                  ),
                                Positioned(
                                  left: 16.0,
                                  bottom: 16.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalButtonFotoPerfilPortada(
                                        "perfil",
                                        true,
                                        urlPhoto: updatedUrlFotoPerfil ??
                                            urlFotoPerfil,
                                      );
                                    },
                                    child: Container(
                                      width: 105.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        color: Colors.grey.shade300,
                                      ),
                                      child: (urlFotoPerfil != null &&
                                                  urlFotoPerfil != '') ||
                                              (updatedUrlFotoPerfil != null &&
                                                  updatedUrlFotoPerfil != '')
                                          ? ShowImage(
                                              networkImage:
                                                  updatedUrlFotoPerfil ??
                                                      urlFotoPerfil,
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              heightNetwork: 105.0,
                                              widthNetWork: 105.0,
                                              fit: BoxFit.cover,
                                            )
                                          : CircleAvatar(
                                              radius: 52.5,
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 60,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int index = 0; index < 3; index++)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: CircleTab(
                                        index: index,
                                        tabController: _tabController,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_tabController.index == 0)
                  ContenidoProServicios(
                    idUsuario: widget.idUsuario,
                  ),
                if (_tabController.index == 1 && idUsuarioActual != null)
                  PerfilCentral(
                      usuarioProfile: usuarioPrincipal,
                      idUsuarioActual: idUsuarioActual!),
                if (_tabController.index == 2)
                  ContenidoEnlaces(
                    idUsuario: widget.idUsuario,
                  ),
              ],
            );
          } else {
            return const Text('No se encontraron los productos');
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class CircleTab extends StatelessWidget {
  const CircleTab({
    super.key,
    required this.index,
    required this.tabController,
  });

  final int index;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tabController.animateTo(index);
      },
      child: CircleAvatar(
        radius: tabController.index == index ? 23.0 : 20.0,
        backgroundColor: tabController.index == index
            ? Colors.grey.shade600 // Color cuando está seleccionado
            : Colors.grey.shade500, // Color cuando no está seleccionado
        child: const Icon(
          Icons.star, // Puedes personalizar esto según tus necesidades
          color: Colors.white,
        ),
      ),
    );
  }
}

class CircleContainer extends StatefulWidget {
  const CircleContainer({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<CircleContainer> createState() => _CircleContainerState();
}

class _CircleContainerState extends State<CircleContainer> {
  @override
  Widget build(BuildContext context) {
    Color containerColor =
        widget.isSelected ? Colors.grey.shade700 : Colors.grey.shade400;
    double containerSize = widget.isSelected ? 45.0 : 40.0;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: containerColor,
        ),
        child: const Icon(
          Icons.star,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CircleTabData {
  bool isSelected;

  CircleTabData(this.isSelected);
}

List<CircleTabData> _circleTabs = [
  CircleTabData(false),
  CircleTabData(true),
  CircleTabData(false),
];

//Permitir idUsuarioActual como null, para que el usuario visitante (aunque no este loguado) pueda ver los demas perfiles
class PerfilCentral extends StatefulWidget {
  const PerfilCentral({
    super.key,
    required this.usuarioProfile,
    required this.idUsuarioActual,
  });

  final UsuarioPrincipalProfileTb usuarioProfile;
  final int idUsuarioActual;

  @override
  State<PerfilCentral> createState() => _PerfilCentralState();
}

class _PerfilCentralState extends State<PerfilCentral> {
  bool esSeguidor = false;
  int seguidores = 0;

  @override
  void initState() {
    super.initState();
    esSeguidor = widget.usuarioProfile.esSeguidor == 1;
    seguidores = widget.usuarioProfile.seguidores;
  }

  void insertSeguidor(int idUsuarioSeguidor, int idUsuarioSeguido) {
    if (esSeguidor) {
      SeguidoresDb.deleteSeguidor(idUsuarioSeguidor, idUsuarioSeguido);
      setState(() {
        esSeguidor = !esSeguidor;
        seguidores = seguidores - 1;
      });
    } else {
      SeguidoresCreacionTb seguidor = SeguidoresCreacionTb(
        idUsuarioSeguidor: idUsuarioSeguidor,
        idUsuarioSeguido: idUsuarioSeguido,
      );
      setState(() {
        esSeguidor = !esSeguidor;
        seguidores = seguidores + 1;
      });
      SeguidoresDb.insertSeguidor(seguidor);
    }
  }

  @override
  Widget build(BuildContext context) {
    UsuarioPrincipalProfileTb usuario = widget.usuarioProfile;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usuario.nombres,
                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 5.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Column(
                          children: [
                            Text(
                              seguidores.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            Text(
                              "Seguidores",
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            usuario.siguiendo.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          Text(
                            "Siguiendo",
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.47, // Establece el ancho máximo al 40%
                    child: const Text(
                      "Descripción previa del perfil de cierto usuario 🍟🍾il de cierto usuario 🍟🍾il de cierto usuario 🍟🍾",
                      style: TextStyle(fontSize: 14.6),
                    ),
                  ),
                ),
                widget.idUsuarioActual != usuario.idUsuario
                    ? ElevatedGlobalButton(
                        nameSavebutton: esSeguidor ? "Siguiendo" : "Seguir",
                        borderRadius: BorderRadius.circular(12.0),
                        heightSizeBox: 35.0,
                        widthSizeBox: 115.0,
                        backgroundColor:
                            esSeguidor ? Colors.grey.shade300 : Colors.blue,
                        colorNameSaveButton:
                            esSeguidor ? Colors.black : Colors.white,
                        onPress: () {
                          insertSeguidor(
                              widget.idUsuarioActual, usuario.idUsuario);
                        },
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ContenidoProServicios extends StatefulWidget {
  const ContenidoProServicios({super.key, required this.idUsuario});

  final int idUsuario;

  @override
  State<ContenidoProServicios> createState() => _ContenidoProServiciosState();
}

class _ContenidoProServiciosState extends State<ContenidoProServicios>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  icon: Icon(
                    CupertinoIcons.cube_box_fill,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  icon: Icon(
                    CupertinoIcons.heart_circle_fill,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          _tabController.index == 0
              ? MisProductos(idUsuario: widget.idUsuario)
              : _tabController.index == 1
                  ? MisServicios(idUsuario: widget.idUsuario)
                  : const SizedBox.shrink()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class ContenidoEnlaces extends StatefulWidget {
  const ContenidoEnlaces({super.key, required this.idUsuario});

  final int idUsuario;

  @override
  State<ContenidoEnlaces> createState() => _ContenidoEnlacesState();
}

class _ContenidoEnlacesState extends State<ContenidoEnlaces>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          TabBar(
            //mirar si al eliminar se deja de renderizar el estado
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(
                  CupertinoIcons.cube_box_fill,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(
                  CupertinoIcons.heart_circle_fill,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          _tabController.index == 0
              ? EnlacesImagePublicaciones(idUsuario: widget.idUsuario)
              : _tabController.index == 1
                  ? const EnlacesReelPublicaciones()
                  : const SizedBox.shrink()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class EnlaceImagePublicaciones extends StatelessWidget {
  const EnlaceImagePublicaciones({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
