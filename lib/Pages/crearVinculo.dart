import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/proServiciosProvider.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrearVinculo extends StatefulWidget {
  const CrearVinculo({super.key, required this.idUsuario});

  final int idUsuario;

  @override
  State<CrearVinculo> createState() => _CrearVinculoState();
}

class _CrearVinculoState extends State<CrearVinculo> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  int indicePagina = 1;

  bool automaticallyImplyLeading = true;
  bool isProducto = true;
  int selectedItemIndex = -1;

  dynamic selectedProServicio;

  void guardar() {
    print("Guardar");
  }

  @override
  Widget build(BuildContext context) {
    final proServiciosProvider = context.watch<ProServiciosProvider>();

    bool isUserSignedIn = context.watch<LoginProvider>().isUserSignedIn;
    List<ServicioTb> servicios = proServiciosProvider.serviciosByNegocio;
    List<ProductoTb> productos = proServiciosProvider.productosByNegocio;

    double fontSize = 19.0;
    double letterSpacing = 0.3;

    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(240, 245, 251, 1.0),
            iconTheme: IconThemeData(color: Colors.black, size: 25),
            toolbarHeight: 60,
            automaticallyImplyLeading: automaticallyImplyLeading,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                indicePagina == 1
                    ? const Text(
                        "Crear vinculo",
                        style: TextStyle(color: Colors.black),
                      )
                    : GlobalTextButton(
                        onPressed: () {
                          setState(() {
                            indicePagina -= 1;
                            automaticallyImplyLeading = true;
                          });
                        },
                        textButton: "Atras",
                        fontSizeTextButton: fontSize,
                        letterSpacing: letterSpacing,
                      ),
                GlobalTextButton(
                  onPressed: () {
                    if (isUserSignedIn && indicePagina == 2) {
                      guardar();
                    } else {
                      setState(() {
                        indicePagina += 1;
                        automaticallyImplyLeading = false;
                      });
                    }
                  },
                  textButton: indicePagina == 1 ? 'Siguiente' : 'Guardar',
                  fontSizeTextButton: fontSize,
                  letterSpacing: letterSpacing,
                )
              ],
            )),
        backgroundColor: Color.fromRGBO(240, 245, 251, 1.0),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child:
              indicePagina == 1 ? paginaUno(productos, servicios) : paginaDos(),
        ),
      ),
    );
  }

  Widget paginaUno(List<ProductoTb> productos, List<ServicioTb> servicios) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                      color: Colors.grey), // Para resaltar el contenedor
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!isProducto) {
                          setState(() {
                            isProducto = true;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: isProducto
                            ? const Icon(
                                CupertinoIcons.cube_box_fill,
                                color: Colors.blue,
                                size: 25,
                              )
                            : const Icon(
                                CupertinoIcons.cube_box,
                                size: 25,
                              ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isProducto) {
                          setState(() {
                            isProducto = false;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: !isProducto
                            ? const Icon(
                                CupertinoIcons.heart_circle_fill,
                                color: Colors.blue,
                                size: 25,
                              )
                            : const Icon(
                                CupertinoIcons.heart_circle,
                                size: 25,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 15.0, 0.0, 20.0),
                child: Text(
                  isProducto
                      ? "¿Qué producto deseas enlazar?"
                      : "¿Qué servicio deseas enlazar?",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              dynamic proServicio =
                  isProducto ? productos[index] : servicios[index];
              final bool isSelect = index == selectedItemIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedItemIndex = index;
                    selectedProServicio = proServicio;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: Container(
                    height: 110.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: isSelect && selectedProServicio == proServicio
                            ? Border.all(color: Colors.blue, width: 3.5)
                            : Border.all(color: Colors.black12, width: 2.0),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShowImage(
                          padding: EdgeInsets.all(6.0),
                          networkImage: proServicio.urlImage,
                          borderRadius: BorderRadius.circular(15.0),
                          fit: BoxFit.fill,
                          height: double.infinity,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                          child: Text(
                            proServicio.nombre,
                            style: const TextStyle(
                                fontSize: 18.5, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          height: double.infinity,
                          width: 30.0,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0)),
                            color: Color(0xFFC59400),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: isProducto ? productos.length : servicios.length,
          ),
        ),
      ],
    );
  }

  Widget paginaDos() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.grey.shade200),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 7.0),
                    child: Text(
                      'Bussines name',
                      style: TextStyle(
                          fontSize: 15.5, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 0.0),
                child: Text(
                  'Lorem ipsum es el texto que se usa habitualmente en diseño gráfico en demostraciones de tipografías',
                  style: TextStyle(fontSize: 16.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                child: Container(
                  width: 340,
                  height: 320,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey.shade200),
                ),
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}
