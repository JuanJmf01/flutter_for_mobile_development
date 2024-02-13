import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginaUno extends ConsumerStatefulWidget {
  const PaginaUno({
    super.key,
    required this.callback,
    required this.productos,
    required this.servicios,
  });

  final Function(dynamic) callback;
  final List<ProductoTb> productos;
  final List<ServicioTb> servicios;

  @override
  PaginaUnoState createState() => PaginaUnoState();
}

class PaginaUnoState extends ConsumerState<PaginaUno> {
  bool isProducto = false;
  int selectedItemIndex = -1;
  dynamic selectedProServicio;

  @override
  Widget build(BuildContext context) {
    //final proServiciosProvider = context.watch<ProServiciosProvider>();

    //List<ServicioTb> servicios = proServiciosProvider.serviciosByNegocio;
    //List<ProductoTb> productos = proServiciosProvider.productosByNegocio;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Agregar enlace",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
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
                                print(isProducto);
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
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
                                print(isProducto);
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
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
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  dynamic proServicio = isProducto
                      ? widget.productos[index]
                      : widget.servicios[index];
                  final bool isSelect = index == selectedItemIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedItemIndex = index;
                        selectedProServicio = proServicio;
                      });
                      widget.callback(selectedProServicio);
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: Container(
                        height: 110.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: isSelect &&
                                    selectedProServicio == proServicio
                                ? Border.all(color: Colors.blue, width: 3.5)
                                : Border.all(color: Colors.black12, width: 2.0),
                            color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShowImage(
                              padding: const EdgeInsets.all(6.0),
                              networkImage: proServicio.urlImage,
                              borderRadius: BorderRadius.circular(15.0),
                              fit: BoxFit.fill,
                              height: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 20.0, 0.0),
                              child: Text(
                                proServicio.nombre,
                                style: const TextStyle(
                                    fontSize: 18.5,
                                    fontWeight: FontWeight.w500),
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
                childCount: isProducto
                    ? widget.productos.length
                    : widget.servicios.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
