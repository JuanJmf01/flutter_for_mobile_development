import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/productImagesTb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';
import 'package:etfi_point/Components/Utils/Services/DataTime.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class productImageDb {
  static Future<void> uploadImage(Asset image, String fileName, int idProducto,
      int isPrincipalImage) async {
    final ByteData byteData = await image.getByteData();
    final Uint8List bytes = byteData.buffer.asUint8List();

    String currentDateTime = obtenerFechaHoraActual();
    String nameImage = image.name!;
    String finalNameImage = '${currentDateTime}_$nameImage';

    print('FINAL NAME: $finalNameImage');

    final Reference ref = storage
        .ref()
        .child('imagenes/$fileName/$idProducto')
        .child(finalNameImage);

    print('REF_: ${ref.fullPath}');

    final UploadTask uploadTask = ref.putData(bytes);

    try {
      final TaskSnapshot snapshot = await uploadTask;
      print('snapshot: $snapshot');

      final String url = await snapshot.ref.getDownloadURL();
      print('url: $url');

      if (snapshot.state == TaskState.success) {
        ProductImageCreacionTb productImage = ProductImageCreacionTb(
            idProducto: idProducto,
            nombreImage: finalNameImage,
            urlImage: url,
            isPrincipalImage: isPrincipalImage);

        await insertProductImages(productImage);
      } else {
        throw Exception('Error uploading image');
      }
    } catch (error) {
      print('Error uploading image: $error');
      throw Exception('Error uploading image');
    }
  }

  static Future<void> updateImage(Asset newImage, String fileName,
      String nombreImage, int idProducto) async {
    final ByteData byteData = await newImage.getByteData();
    final Uint8List imageData = byteData.buffer.asUint8List();

    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('imagenes/$fileName/$idProducto/$nombreImage');
      final UploadTask uploadTask = ref.putData(imageData);

      final TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        final String url = await snapshot.ref.getDownloadURL();

        ProductImageCreacionTb productImage = ProductImageCreacionTb(
            idProducto: idProducto,
            nombreImage: nombreImage,
            urlImage: url,
            isPrincipalImage: 1);

        //Actualizar url un base de datos
        await productImageDb.updateProductImage(productImage);
      } else {
        throw Exception('Error updating image');
      }
    } catch (error) {
      print('Error updating image: $error');
      throw Exception('Error updating image');
    }
  }

  static Future<void> insertProductImages(
      ProductImageCreacionTb productImage) async {
    Dio dio = Dio();
    String url = MisRutas.rutaProductImages;
    Map<String, dynamic> data = productImage.toMap();

    try {
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('productImage insertado correctamente (print)');
        print(response.data);
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }

  static Future<List<ProductImagesTb>> getProductSecondaryImages(
      int idProducto) async {
    Dio dio = Dio();

    try {
      Response response =
          await dio.get('${MisRutas.rutaProductImages}/$idProducto');

      if (response.statusCode == 200) {
        List<ProductImagesTb> productSecondaryImages =
            List<ProductImagesTb>.from(response.data
                .map((productoData) => ProductImagesTb.fromJson(productoData)));
        print('productoImageingetSecond: $productSecondaryImages');
        return productSecondaryImages;
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  static Future<void> updateProductImage(
      ProductImageCreacionTb productImage) async {
    Dio dio = Dio();
    String url = MisRutas.rutaProductImages;

    try {
      Response response = await dio.patch(
        url,
        data: productImage.toMap(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('productImage actualizado correctamente');
        print(response.data);
        // Realiza las operaciones necesarias con la respuesta
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      // Ocurrió un error en la conexión
      print('Error de conexión: $error');
    }
  }

  static Future<bool> deleteProductImages(int idProducto) async {
    Dio dio = Dio();
    String url = '${MisRutas.rutaProductImages}/$idProducto';

    try {
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 202) {
        print('ProductImages eliminados correctamente');
        return true;
      } else if (response.statusCode == 404) {
        print('ProductImages no encontrado');
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
    return false;
  }

  static Future<bool> deleteProductImage(
      int idProducto, int isPrincipalImage) async {
    Dio dio = Dio();
    String url = MisRutas.rutaProductImages;
    Map<String, dynamic> data = {
      'idProducto': idProducto,
      'isPrincipalImage': isPrincipalImage
    };

    try {
      Response response = await dio.delete(
        url,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 202) {
        print('ProductImage eliminado correctamente');
        return true;
      } else if (response.statusCode == 404) {
        print('ProductImage no encontrado');
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
    return false;
  }
}
