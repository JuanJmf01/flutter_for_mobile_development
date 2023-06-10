import 'dart:io';

import 'package:etfi_point/Components/Auth/auth.dart';
import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/negocioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosCategoriasDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Entities/usuarioDb.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProductosGeneralForm extends StatefulWidget {
  const ProductosGeneralForm({
    super.key,
    this.data,
    this.exitoTitle,
    required this.titulo,
    required this.nameSavebutton,
    required this.exitoMessage,
  });

  final ProductoTb? data;
  final String titulo;
  final String nameSavebutton;
  final String? exitoTitle;
  final String exitoMessage;

  @override
  State<ProductosGeneralForm> createState() => _ProductosGeneralFormState();
}

class _ProductosGeneralFormState extends State<ProductosGeneralForm> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _cantidadDisponibleController =
      TextEditingController();

  CategoriaTb? categoriaSeleccionada;
  List<CategoriaTb> categoriasDisponibles = [];
  List<CategoriaTb> categoriasSeleccionadas = [];
  String? _imagePath;
  int? idNegocio;

  int? enOferta;
  bool isChecked = false;

  ProductoTb? _producto;

  @override
  void initState() {
    super.initState();

    _nombreController.text = widget.data?.nombreProducto ?? '';
    _precioController.text = (widget.data?.precio ?? 0).toStringAsFixed(0);
    _descripcionController.text = widget.data?.descripcion ?? '';
    _cantidadDisponibleController.text =
        widget.data?.cantidadDisponible.toString() ?? '';

    _imagePath = widget.data?.imagePath;
    enOferta = widget.data?.oferta;
    estaEnOferta();
    obtenerCategoriasSeleccionadas();

    obtenerCategorias();

    _producto = widget.data;
  }

  void estaEnOferta() {
    if (enOferta == 1) {
      isChecked = true;
    } else {
      isChecked = false;
    }
  }

  Future<int?> getIdUsuario() async {
    int? idUsuario;
    if (FirebaseAuth.instance.currentUser != null) {
      String? email = FirebaseAuth.instance.currentUser?.email;
      if (email != null) {
        try {
          idUsuario = await UsuarioDb.getIdUsuarioPorCorreo(email);
        } catch (e) {
          // Manejo de errores
          print('Error al obtener el idUsuario: $e');
          return null; // Retornar null en caso de error
        }
      }
    }
    return idUsuario;
  }


  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePath = image?.path;
    });
  }

  void obtenerCategoriasSeleccionadas() async {
    final idCategoriasDeProducto;
    if (widget.data?.idProducto != null) {
      idCategoriasDeProducto =
          await ProductosCategoriasDb.obtenerIdCategoriasPorIdProducto(
              widget.data!.idProducto!);
      //print(idCategoriasDeProducto);

      for (int idCategoria in idCategoriasDeProducto) {
        final categoriaMap =
            await CategoriaDb.obtenerCategoriasPorId(idCategoria);
        if (categoriaMap.isNotEmpty) {
          final nombreCategoria = categoriaMap[idCategoria];
          if (nombreCategoria != null) {
            final categoria = CategoriaTb(
              idCategoria: idCategoria,
              nombre: nombreCategoria,
            );
            if (!categoriasSeleccionadas.contains(categoria)) {
              categoriasSeleccionadas.add(categoria);
            }

            //print(categoria);
          }
        }
      }
      print(categoriasSeleccionadas);
      //print('MisCateDisponibles');
      //print(categoriasDisponibles);
    }

    setState(() {});
  }

  void obtenerCategorias() async {
    categoriasDisponibles = await CategoriaDb.categorias();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        appBar:
            AppBar(backgroundColor: Colors.black, title: Text(widget.titulo)),
        body: FocusScope(
          node: _focusScopeNode,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CheckboxListTile(
                      title: const Text('¿Producto en oferta?'),
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                          enOferta = isChecked ? 1 : 0;
                        });
                      }),
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      hintText: 'Agrega un nombre',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _precioController,
                    decoration: const InputDecoration(
                      hintText: 'Agrega un precio',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        if (newValue.text.isEmpty) return newValue;
                        final double parsedValue =
                            double.tryParse(newValue.text) ?? 0;
                        final String newText = parsedValue.toStringAsFixed(0);
                        return newValue.copyWith(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(
                      hintText: 'Agrega una descripción',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _cantidadDisponibleController,
                    decoration: const InputDecoration(
                      hintText: 'Agrega una cantidad disponible',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<CategoriaTb>(
                    decoration: const InputDecoration(
                      hintText: 'Selecciona una categoría',
                    ),
                    value: categoriaSeleccionada,
                    items: categoriasDisponibles
                        .map(
                          (categoria) => DropdownMenuItem<CategoriaTb>(
                            value: categoria,
                            child: Text(categoria.nombre),
                          ),
                        )
                        .toList(),
                    onChanged: (CategoriaTb? newValue) {
                      setState(() {
                        if (!categoriasSeleccionadas.contains(newValue)) {
                          categoriasSeleccionadas.add(newValue!);
                          //print(newValue);
                          print(categoriasSeleccionadas);
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    //alignment: WrapAlignment.start,
                    children: categoriasSeleccionadas.map((categoria) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              categoria.nombre,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  categoriasSeleccionadas.remove(categoria);
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 17,
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Agrega una imagen'),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Icon(Icons.image),
                      ),
                    ],
                  ),
                  if (_imagePath != null && _imagePath!.isNotEmpty)
                    Container(
                      width: 330,
                      height: 330,
                      margin: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 35.0),
                      child: Image.file(File(_imagePath!)),
                    ),
                  if (Auth.isUserSignedIn())
                    ElevatedButton(
                      onPressed: () async {
                        if (_imagePath != null && _imagePath!.isNotEmpty) {
                          final nombreProducto = _nombreController.text;
                          double precio = double.tryParse(_precioController.text) ?? 0.0;
                          final descripcion = _descripcionController.text;
                          int cantidadDisponible = int.tryParse(_cantidadDisponibleController.text) ?? 0;

                          _producto = ProductoTb(
                              idProducto: widget.data?.idProducto,
                              idNegocio: 1,
                              nombreProducto: nombreProducto,
                              precio: precio,
                              descripcion: descripcion,
                              cantidadDisponible: cantidadDisponible,
                              oferta: enOferta,
                              imagePath: _imagePath ?? "");

                          try {
                            await ProductoDb.save(_producto!, categoriasSeleccionadas);
                            print('crecendiales : ');
                            if (context.mounted) {
                              print(_producto);
                              print(categoriasSeleccionadas);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmationDialog(
                                    titulo: widget.exitoTitle,
                                    message: widget.exitoMessage,
                                    onAccept: () {
                                      Navigator.of(context)
                                          .pop(); // Cerrar el cuadro de diálogo
                                      if (_producto?.idProducto != null) {
                                        Navigator.pop(context, 'update');
                                      } else {
                                        Navigator.pop(context, _producto);
                                      }
                                    },
                                    onAcceptMessage: 'Cerrar y volver',
                                  );
                                },
                              );
                            }
                          } catch (error) {
                            print('Error al actualizar el producto: $error');
                          }
                        }
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Ajustar el valor para cambiar la redondez del botón
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(widget.nameSavebutton,
                            style: const TextStyle(
                                fontSize: 15)), //tamaño del texto del botón
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
