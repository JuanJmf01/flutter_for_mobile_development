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
import 'package:etfi_point/Components/Utils/generalInputs.dart';
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

  int? enOferta = 0;
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
    Color colorTextField = Colors.white;

    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            toolbarHeight: 70, // Establecer una altura mayor
            title: Text(
          widget.titulo,
          style: TextStyle(color: Colors.black),
        )),
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Expanded(
              child: FocusScope(
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
                        GeneralInputs(
                            controller: _nombreController,
                            labelText: 'Agrega un nombre',
                            color: colorTextField),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                          child: GeneralInputs(
                            controller: _precioController,
                            labelText: 'Agrega un precio',
                            color: colorTextField,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                          ),
                        ),
                        GeneralInputs(
                            controller: _descripcionController,
                            labelText: 'Agrega una descripción',
                            color: colorTextField),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                          child: GeneralInputs(
                            controller: _cantidadDisponibleController,
                            labelText: 'Agrega una cantidad disponible',
                            color: colorTextField,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        DropdownButtonFormField<CategoriaTb>(
                          decoration: InputDecoration(
                            hintText: 'Selecciona una categoría',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          value: categoriaSeleccionada,
                          items: categoriasDisponibles
                              .map(
                                (categoria) => DropdownMenuItem<CategoriaTb>(
                                  value: categoria,
                                  child: Text(
                                    categoria.nombre,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (CategoriaTb? newValue) {
                            setState(() {
                              if (!categoriasSeleccionadas.contains(newValue)) {
                                categoriasSeleccionadas.add(newValue!);
                              }
                            });
                          },
                          dropdownColor: Colors.grey[200],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 35.0),
                          child: Wrap(
                            //direction: Axis.horizontal,
                            //alignment: WrapAlignment.start,
                            children: categoriasSeleccionadas.map((categoria) {
                              return Container(
                                margin: EdgeInsets.all(5.0),
                                padding: EdgeInsets.all(12.0),
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
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          categoriasSeleccionadas
                                              .remove(categoria);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        if (_imagePath != null && _imagePath!.isNotEmpty)
                          Container(
                            width: 350,
                            height: 300,
                            margin: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.file(
                                File(_imagePath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                          child: ElevatedButton.icon(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16.0), // Ajustar el padding del botón
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Establecer bordes redondeados
                              ),
                            ),
                            icon: Icon(Icons.image),
                            label: Text('Agrega una imagen'),
                          ),
                        ),
                        const SizedBox(height: 100.0)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (Auth.isUserSignedIn())
              SizedBox(
                width: double.infinity,
                height: 50.0,
               
                child: ElevatedButton(
                  onPressed: () async {
                    if (_imagePath != null && _imagePath!.isNotEmpty) {
                      
                      //-- Se crea un negocio en caso de que no exista. Si existe, se asigna el valor idNegocio en _producto a ser creado
                      final idUsuario = await UsuarioDb.getIdUsuario();
                      int? idNegocio;
                      int? idNegocioIfExists = await NegocioDb.findIdNegocioByIdUsuario(idUsuario!);
                      print('Existe o no : $idNegocioIfExists');
                      if (idNegocioIfExists == null) {
                        NegocioTb negocio = NegocioTb(
                          idUsuario: idUsuario,
                        );
                        idNegocio = await NegocioDb.insert(negocio);
                      } else {
                        idNegocio = idNegocioIfExists;
                      }
              
                      //--- Se asigna cada String de los campso de texto a una variable ---//
                      final nombreProducto = _nombreController.text;
                      double precio = double.tryParse(_precioController.text) ?? 0.0;
                      final descripcion = _descripcionController.text;
                      int cantidadDisponible = int.tryParse(_cantidadDisponibleController.text) ?? 0;
              
                      //-- Creamos el producto --//
                      _producto = ProductoTb(
                          idProducto: widget.data?.idProducto,
                          idNegocio: idNegocio,
                          nombreProducto: nombreProducto,
                          precio: precio,
                          descripcion: descripcion,
                          cantidadDisponible: cantidadDisponible,
                          oferta: enOferta,
                          imagePath: _imagePath ?? "");
                      
                      int idProducto = 0;

                          
              
                      try {
                        if(_producto?.idProducto != null && _producto != null){
                          await ProductoDb.update(_producto!, categoriasSeleccionadas);
                        }else{
                          print('Entroooo');
                          idProducto = await ProductoDb.insert(_producto!, categoriasSeleccionadas);
                        }


                        if(idProducto != null){
                          print('mi id producto $idProducto');
                        }else{
                          print('es nulo $idProducto');
                        }

                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmationDialog(
                                titulo: widget.exitoTitle,
                                message: widget.exitoMessage,
                                onAccept: () {
                                  Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                                  if (_producto?.idProducto != null) {
                                    Navigator.pop(context, 'update');
                                  } else {
                                    _producto?.idProducto = idProducto;
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
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(widget.nameSavebutton, style: const TextStyle(fontSize: 15)), //tamaño del texto del botón
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
