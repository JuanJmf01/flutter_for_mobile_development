import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/negocioTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/Entities/categoriaDb.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Firebase/Storage/productImagesStorage.dart';
import 'package:etfi_point/Components/Utils/ElevatedGlobalButton.dart';
import 'package:etfi_point/Components/Utils/Services/selectImage.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/loginProvider.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

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
  String? urlImage;
  Asset? imagenToUpload;

  int? enOferta = 0;
  bool isChecked = false;

  ProductoTb? _producto;

  @override
  void initState() {
    super.initState();

    print('dataUpdat_: ${widget.data}');

    _nombreController.text = widget.data?.nombreProducto ?? '';
    _precioController.text = (widget.data?.precio ?? 0).toStringAsFixed(0);
    _descripcionController.text = widget.data?.descripcion ?? '';
    _cantidadDisponibleController.text =
        widget.data?.cantidadDisponible.toString() ?? '';
    urlImage = widget.data?.urlImage;
    enOferta = widget.data?.oferta;
    estaEnOferta();

    obtenerCategoriasSeleccionadas();

    obtenerCategorias();

    if (widget.data != null) {
      _producto = widget.data;
    }
  }

  void estaEnOferta() {
    enOferta == 1
        ? isChecked = true
        : enOferta == 0
            ? isChecked = false
            : isChecked = false;
  }

  void obtenerCategoriasSeleccionadas() async {
    if (widget.data?.idProducto != null) {
      categoriasSeleccionadas =
          await CategoriaDb.getCategoriasSeleccionadas(widget.data!.idProducto);
    }

    setState(() {});
  }

  void obtenerCategorias() async {
    categoriasDisponibles = await CategoriaDb.getCategorias();
    setState(() {});
  }

  Future<int> crearNegocioSiNoExiste(idUsuario) async {
    int idNegocio = 0;
    //-- Se crea un negocio en caso de que no exista. Si existe, se asigna el valor idNegocio en _producto a ser creado
    // En caso de que no exista 'idNegocioIfExists' sera igual a null por lo tanto se creara un nuevo negocio con 'idUsuario';
    NegocioTb? negocio = await NegocioDb.getNegocio(idUsuario);
    if (negocio?.idNegocio == null) {
      NegocioCreacionTb negocio = NegocioCreacionTb(
        idUsuario: idUsuario,
      );
      idNegocio = await NegocioDb.insertNegocio(negocio);
    } else {
      idNegocio = negocio!.idNegocio;
    }

    return idNegocio;
  }

  Future<int> crearProducto(ProductoCreacionTb producto, int idUsuario) async {
    int idProducto = 0;
    try {
      idProducto =
          await ProductoDb.insertProducto(producto, categoriasSeleccionadas);
      if (imagenToUpload != null) {
        await ProductImagesStorage.cargarImage(
            imagenToUpload!, 'productos', idUsuario, idProducto, 1);
      }
      mostrarCuadroExito(idProducto);
    } catch (error) {
      print('Problemas al insertar el producto $error');
    }

    return idProducto;
  }

  void actualizarProducto(ProductoTb producto, int idUsuario) async {
    int idProducto = producto.idProducto;
    if (imagenToUpload != null) {
      await ProductImagesStorage.updateImage(imagenToUpload!, 'productos',
          idUsuario, producto.nombreImage, idProducto, 1);
    } else {
      print('Imagen a actualizar es null');
    }
    try {
      await ProductoDb.updateProducto(producto, categoriasSeleccionadas);
      mostrarCuadroExito(idProducto);
    } catch (error) {
      print('Problemas al actualizar el producto $error');
    }
  }

  //Recibimos idProducto para enviarlo a la pagina anterior y poder renderizar un solo producto y no toda la pestaña
  void mostrarCuadroExito(int idProducto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          titulo: widget.exitoTitle,
          message: widget.exitoMessage,
          onAccept: () {
            Navigator.of(context).pop();
            if (_producto?.idProducto != null) {
              Navigator.pop(context, idProducto);
            } else {
              Navigator.pop(context, idProducto);
            }
          },
          onAcceptMessage: 'Cerrar y volver',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isUserSignedIn = context.watch<LoginProvider>().isUserSignedIn;
    int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuario;

    Color colorTextField = Colors.white;
    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            toolbarHeight: 70,
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
                            verticalPadding: 15.0,
                            controller: _nombreController,
                            labelText: 'Agrega un nombre',
                            color: colorTextField),
                        GeneralInputs(
                          controller: _precioController,
                          labelText: 'Agrega un precio',
                          color: colorTextField,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
                        GeneralInputs(
                          verticalPadding: 15.0,
                          controller: _descripcionController,
                          labelText: 'Agrega una descripción',
                          color: colorTextField,
                          keyboardType: TextInputType.multiline,
                          minLines: 2,
                        ),
                        // GeneralInputs(
                        //   verticalPadding: 15.0,
                        //   controller: _descripcionController,
                        //   labelText: 'Agrega una descripción',
                        //   color: colorTextField,
                        //   keyboardType: TextInputType.multiline,
                        //   minLines: 3,
                        //   maxLines: 10,
                        // ),
                        GeneralInputs(
                          controller: _cantidadDisponibleController,
                          labelText: 'Agrega una cantidad disponible',
                          color: colorTextField,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: DropdownButtonFormField<CategoriaTb>(
                            decoration: InputDecoration(
                              hintText: 'Selecciona una categoría',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            //value: categoriaSeleccionada,
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
                                if (!categoriasSeleccionadas
                                    .contains(newValue)) {
                                  categoriasSeleccionadas.add(newValue!);
                                }
                              });
                            },
                            dropdownColor: Colors.grey[200],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 35.0),
                          child: Wrap(
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
                        if (imagenToUpload != null || urlImage != null)
                          ShowImage(
                            width: 350,
                            height: 300,
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20.0),
                            widthAsset: 350,
                            heightAsset: 300,
                            imageAsset: imagenToUpload,
                            networkImage: urlImage,
                            fit: BoxFit.cover,
                          ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final asset = await getImageAsset();
                              if (asset != null) {
                                setState(() {
                                  imagenToUpload = asset;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(
                                  16.0), // Ajustar el padding del botón
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Establecer bordes redondeados
                              ),
                            ),
                            icon: Icon(Icons.image),
                            label: imagenToUpload != null
                                ? Text('Cambiar imagen')
                                : Text('Agrega una imagen'),
                          ),
                        ),
                        const SizedBox(height: 100.0)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isUserSignedIn)
              ElevatedGlobalButton(
                  nameSavebutton: widget.nameSavebutton,
                  widthSizeBox: double.infinity,
                  heightSizeBox: 50.0,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  onPress: () async {
                    //--- Se asigna cada String de los campso de texto a una variable ---//
                    final nombreProducto = _nombreController.text;
                    double precio =
                        double.tryParse(_precioController.text) ?? 0.0;
                    final descripcion = _descripcionController.text;
                    int cantidadDisponible =
                        int.tryParse(_cantidadDisponibleController.text) ?? 0;

                    ProductoCreacionTb productoCreacion;
                    int idNegocio = await crearNegocioSiNoExiste(idUsuario);

                    print('producto_:: ${widget.data?.idProducto}');
                    if (widget.data?.idProducto == null) {
                      //-- Creamos el producto --//
                      productoCreacion = ProductoCreacionTb(
                          idNegocio: idNegocio,
                          nombreProducto: nombreProducto,
                          precio: precio,
                          descripcion: descripcion,
                          cantidadDisponible: cantidadDisponible,
                          oferta: enOferta);

                      imagenToUpload != null && idUsuario != null
                          ? crearProducto(productoCreacion, idUsuario)
                          : print('imagenToUpload es null o idUsuario es null');
                    } else {
                      _producto = ProductoTb(
                        idProducto: widget.data!.idProducto,
                        idNegocio: widget.data!.idNegocio,
                        nombreProducto: nombreProducto,
                        precio: precio,
                        descripcion: descripcion,
                        cantidadDisponible: cantidadDisponible,
                        oferta: enOferta,
                        urlImage: urlImage!,
                        nombreImage: widget.data!.nombreImage,
                      );

                      urlImage != null && idUsuario != null
                          ? actualizarProducto(_producto!, idUsuario)
                          : print('urlImage es null');
                    }
                  })
          ],
        ),
      ),
    );
  }
}
