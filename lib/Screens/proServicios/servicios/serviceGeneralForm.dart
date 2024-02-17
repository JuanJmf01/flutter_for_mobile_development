import 'dart:typed_data';

import 'package:etfi_point/Data/models/proServicioImagesTb.dart';
import 'package:etfi_point/Data/models/productImagesStorageTb.dart';
import 'package:etfi_point/Data/models/servicioTb.dart';
import 'package:etfi_point/Data/services/api/FirebaseStorage/firebaseImagesStorage.dart';
import 'package:etfi_point/Data/services/api/negocioDb.dart';
import 'package:etfi_point/Data/services/api/serviceImageDb.dart';
import 'package:etfi_point/Data/services/api/servicioDb.dart';
import 'package:etfi_point/components/widgets/Services/randomServices.dart';
import 'package:etfi_point/Data/services/providers/categoriasProvider.dart';
import 'package:etfi_point/Data/services/providers/userStateProvider.dart';
import 'package:etfi_point/Screens/proServicios/proServicioGeneralForm.dart';
import 'package:etfi_point/config/routes/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ServiceGeneralForm extends ConsumerStatefulWidget {
  const ServiceGeneralForm({super.key, this.service});

  final ServicioTb? service;

  @override
  ServiceGeneralFormState createState() => ServiceGeneralFormState();
}

class ServiceGeneralFormState extends ConsumerState<ServiceGeneralForm> {
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

  // variables for third page
  String? urlSubCategories;

  @override
  void initState() {
    super.initState();

    defineUrlToUpdateService();
  }

  Future<void> crearServicio(ServicioCreacionTb servicio, int idUsuario) async {
    int idServicio;
    final categoriasSeleccionadas = ref.read(subCategoriasSelectedProvider);
    try {
      idServicio =
          await ServicioDb.insertServicio(servicio, categoriasSeleccionadas);
      String finalNameImage = RandomServices.assingName(principalImage!.name!);

      if (principalImageBytes != null || principalImage != null) {
        ImagesStorageTb image = ImagesStorageTb(
          idUsuario: idUsuario,
          idFile: idServicio,
          newImageBytes: principalImageBytes ??
              await RandomServices.assetToUint8List(principalImage!),
          fileName: 'servicios',
          imageName: finalNameImage,
        );
        String url = await ImagesStorage.cargarImage(image);

        ProServicioImageCreacionTb productImage = ProServicioImageCreacionTb(
          idProServicio: idServicio,
          nombreImage: finalNameImage,
          urlImage: url,
          width: principalImage!.originalWidth!.toDouble(),
          height: principalImage!.originalHeight!.toDouble(),
          isPrincipalImage: 1,
        );

        await ServiceImageDb.insertServiceImage(productImage);
      }

      if (myImageList.items.isNotEmpty) {
        for (var imagen in myImageList.items) {
          String finalNameImage =
              RandomServices.assingName(principalImage!.name!);
          if (imagen is ProServicioImageToUpload) {
            Uint8List imageBytes =
                await RandomServices.assetToUint8List(imagen.newImage);

            ImagesStorageTb image = ImagesStorageTb(
              idUsuario: idUsuario,
              idFile: idServicio,
              newImageBytes: imageBytes,
              imageName: finalNameImage,
              fileName: 'servicios',
            );

            String url = await ImagesStorage.cargarImage(image);

            ProServicioImageCreacionTb serviceImage =
                ProServicioImageCreacionTb(
              idProServicio: idServicio,
              nombreImage: finalNameImage,
              urlImage: url,
              width: principalImage!.originalWidth!.toDouble(),
              height: principalImage!.originalHeight!.toDouble(),
              isPrincipalImage: 0,
            );
            await ServiceImageDb.insertServiceImage(serviceImage);
          }
        }
      }
    } catch (error) {
      print('Problemas al insertar el servicio $error');
    }
  }

  void guardar(int idUsuario) async {
    final String nombreServicio = _nameController.text;
    final double precio = RandomServices.textToDouble(_priceController.text);
    final String descripcion = _descriptionController.text;
    final int descuento = int.tryParse(_discountController.text) ?? 0;

    ServicioCreacionTb servicioCreacion;
    int idNegocio = await NegocioDb.createBusiness(idUsuario);

    if (widget.service?.idServicio == null) {
      servicioCreacion = ServicioCreacionTb(
        idNegocio: idNegocio,
        nombre: nombreServicio,
        descripcion: descripcion,
        precio: precio,
        oferta: isOffert ? 1 : 0,
        descuento: descuento,
      );

      crearServicio(servicioCreacion, idUsuario);
    } else {
      // _servicio = ServicioTb(
      //   idServicio: _servicio!.idServicio,
      //   idNegocio: _servicio!.idNegocio,
      //   nombre: nombreServicio,
      //   precio: precio,
      //   oferta: enOferta,
      //   urlImage: _servicio!.urlImage,
      //   nombreImage: _servicio!.nombreImage,
      // );

      // print("PRIMER PARTE ${_servicio!.nombre}");
      // actualizarServicio(_servicio!, idUsuario);
    }
  }

  void defineUrlToUpdateService() {
    Type objectType = widget.service.runtimeType;
    if (widget.service != null && objectType == ServicioTb) {
      urlSubCategories =
          '${MisRutas.rutaSubCategorias}/${widget.service!.idServicio}';
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
      proServiceObjectType: widget.service.runtimeType,
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
          guardar(idUsuarioActual);
        } else {
          print("Manage logueo");
        }
      },
    );
  }
}
