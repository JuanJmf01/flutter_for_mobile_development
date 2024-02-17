import 'dart:async';
import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/proServicioImagesTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesStorageTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
import 'package:etfi_point/Components/Data/EntitiModels/subCategoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/FirebaseStorage/firebaseImagesStorage.dart';
import 'package:etfi_point/Components/Data/Entities/negocioDb.dart';
import 'package:etfi_point/Components/Data/Entities/productImageDb.dart';
import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/crudImages.dart';
import 'package:etfi_point/Components/Utils/ImagesUtils/fileTemporal.dart';
import 'package:etfi_point/Components/Utils/Services/randomServices.dart';
import 'package:etfi_point/Components/providers/categoriasProvider.dart';
import 'package:etfi_point/Components/providers/userStateProvider.dart';
import 'package:etfi_point/Screens/proServicios/proServicioGeneralForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProductoGeneralForm extends ConsumerStatefulWidget {
  const ProductoGeneralForm({super.key, this.product});

  final ProductoTb? product;

  @override
  ProductoGeneralFormState createState() => ProductoGeneralFormState();
}

class ProductoGeneralFormState extends ConsumerState<ProductoGeneralForm> {
  // variables for first page
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isOffert = false;

  // variables for second page
  ImageList myImageList = ImageList([]);
  Asset? principalImage;
  String? urlPrincipalImage;
  Uint8List? principalImageBytes;

  // variables for second page
  List<SubCategoriaTb> selectedSubCategories = [];
  String? urlSubCategories;

  @override
  void initState() {
    super.initState();

    initializeVariables();
    defineUrlToUpdateProduct();
  }

  void initializeVariables() {
    if (widget.product != null) {
      print("Si entree");
      ProductoTb product = widget.product!;

      _nameController.text = product.nombre;
      _priceController.text = product.precio.toStringAsFixed(2);
      _discountController.text = product.descuento.toString();
      _descriptionController.text = product.descripcion ?? '';
    }else{
      print("No entree");
    }
  }

  Future<void> selectImages() async {
    List<ProServicioImageToUpload> selectedImagesAux =
        await CrudImages.agregarImagenes();

    setState(() {
      myImageList.items.addAll(selectedImagesAux);
    });
    if (widget.product?.idProducto == null && selectedImagesAux.isNotEmpty) {
      if (principalImage == null) {
        setState(() {
          principalImage = selectedImagesAux[0].newImage;
        });
      }
    }
  }

  Future<void> crearProducto(ProductoCreacionTb producto, int idUsuario) async {
    int idProducto;
    final categoriasSeleccionadas = ref.read(subCategoriasSelectedProvider);

    try {
      idProducto =
          await ProductoDb.insertProducto(producto, categoriasSeleccionadas);

      // Save principal image
      if ((principalImageBytes != null || principalImage != null)) {
        ImagesStorageTb image = ImagesStorageTb(
          idUsuario: idUsuario,
          idFile: idProducto,
          newImageBytes: principalImageBytes ??
              await RandomServices.assetToUint8List(principalImage!),
          imageName: principalImage!.name!,
          fileName: 'productos',
        );

        // Save principal image in firebase and retrieve  its url
        String url = await ImagesStorage.cargarImage(image);

        ProServicioImageCreacionTb productImage = ProServicioImageCreacionTb(
          idProServicio: idProducto,
          nombreImage: principalImage!.name!,
          urlImage: url,
          width: principalImage!.originalWidth!.toDouble(),
          height: principalImage!.originalHeight!.toDouble(),
          isPrincipalImage: 1,
        );

        await ProductImageDb.insertProductImages(productImage);
      }

      // Save secondary images
      if (myImageList.items.isNotEmpty) {
        for (var imagen in myImageList.items) {
          if (imagen is ProServicioImageToUpload) {
            ImagesStorageTb image = ImagesStorageTb(
              idUsuario: idUsuario,
              idFile: idProducto,
              newImageBytes:
                  await RandomServices.assetToUint8List(imagen.newImage),
              imageName: imagen.nombreImage,
              fileName: 'productos',
            );

            String url = await ImagesStorage.cargarImage(image);

            ProServicioImageCreacionTb productImage =
                ProServicioImageCreacionTb(
              idProServicio: idProducto,
              nombreImage: principalImage!.name!,
              urlImage: url,
              width: principalImage!.originalWidth!.toDouble(),
              height: principalImage!.originalHeight!.toDouble(),
              isPrincipalImage: 0,
            );

            await ProductImageDb.insertProductImages(productImage);
          }
        }
      }
      // mostrarCuadroExito(idProducto);
    } catch (error) {
      print('Problemas al insertar el producto $error');
    }
  }

  void actualizarProducto(ProductoTb producto, int idUsuario) async {
    int idProducto = producto.idProducto;

    if (urlPrincipalImage != null) {
      File urlImageInFile = await FileTemporal.convertToTempFile(
          urlImage: urlPrincipalImage, image: principalImage);
      Uint8List principalImageBytesAux = await urlImageInFile.readAsBytes();
      setState(() {
        principalImageBytes = principalImageBytesAux;
      });
    }

    if (principalImageBytes != null || principalImage != null) {
      ImagesStorageTb image = ImagesStorageTb(
        idUsuario: idUsuario,
        idFile: idProducto,
        newImageBytes: principalImageBytes ??
            await RandomServices.assetToUint8List(principalImage!),
        fileName: 'productos',
        imageName: producto.nombreImage,
      );

      await ImagesStorage.updateImage(image);
    } else {
      print('Imagen a actualizar es null');
    }

    try {
      await ProductoDb.updateProducto(producto, selectedSubCategories);
      //mostrarCuadroExito(idProducto);
    } catch (error) {
      print('Problemas al actualizar el producto $error');
    }
  }

  void guardar(int idUsuarioActual) async {
    //--- Se asigna cada String de los campos de texto a una variable ---//
    final String nombreProducto = _nameController.text;
    final double price = RandomServices.textToDouble(_priceController.text);
    final String description = _descriptionController.text;
    final int descuento = int.tryParse(_discountController.text) ?? 0;

    ProductoCreacionTb productoCreacion;

    //Create business if not exist
    int idNegocio = await NegocioDb.createBusiness(idUsuarioActual);

    if (widget.product?.idProducto == null) {
      //-- Creamos el producto --//
      productoCreacion = ProductoCreacionTb(
        idNegocio: idNegocio,
        nombreProducto: nombreProducto,
        precio: price,
        descripcion: description,
        cantidadDisponible: 0,
        oferta: isOffert ? 1 : 0,
        descuento: descuento,
      );

      myImageList.items.isNotEmpty
          ? crearProducto(productoCreacion, idUsuarioActual)
          : print('imagenToUpload es null o idUsuario es null');
    } else {
      // -- Actualir el producto --//
      ProductoTb producto = widget.product!;

      producto = ProductoTb(
        idProducto: producto.idProducto,
        idNegocio: producto.idNegocio,
        nombre: nombreProducto,
        precio: price,
        descripcion: description,
        cantidadDisponible: 0,
        oferta: isOffert ? 1 : 0,
        urlImage: producto.urlImage,
        nombreImage: producto.nombreImage,
      );

      actualizarProducto(producto, idUsuarioActual);
    }
  }

  void defineUrlToUpdateProduct() {
    Type objectType = widget.product.runtimeType;
    if (widget.product != null && objectType == ProductoTb) {
      urlSubCategories =
          '${MisRutas.rutaSubCategorias}/${widget.product!.idProducto}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final int? idUsuarioActual = ref.watch(getCurrentUserProvider).value;
    return ProServicioGeneralStructure(
      nameController: _nameController,
      priceController: _priceController,
      discountController: _discountController,
      descriptionController: _descriptionController,
      isOffert: isOffert,
      proServiceObjectType: ProductoTb,
      urlSubCategories: urlSubCategories,
      myImageList: myImageList,
      principalImage: principalImage,
      urlPrincipalImage: urlPrincipalImage,
      principalImageBytes: principalImageBytes,
      onUpDateOffert: (bool newIsOffert) {
        setState(() {
          isOffert = newIsOffert;
        });
      },
      onUpdatedImages: ({
        Asset? newPrincipalImage,
        String? newUrlPrincipalImage,
        Uint8List? newPrincipalImageBytes,
      }) {
        setState(() {
          principalImage = newPrincipalImage;
          urlPrincipalImage = newUrlPrincipalImage;
          principalImageBytes = newPrincipalImageBytes;
        });
      },
      onSelectedImageList: (List<ProServicioImageToUpload> newImageList) {
        setState(() {
          myImageList.items.addAll(newImageList);
        });
      },
      callbackGuardar: () {
        if (idUsuarioActual != null) {
          selectedSubCategories = ref.watch(subCategoriasSelectedProvider);

          guardar(idUsuarioActual);
        } else {
          print("Manage logueo");
        }
      },
    );
  }
}
